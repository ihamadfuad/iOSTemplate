// ºººº----------------------------------------------------------------------ºººº \\
//
// Copyright (c) 2022 Hamad Fuad.
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
// associated documentation files (the "Software"), to deal in the Software without restriction,
// including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
// subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial
// portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
// NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
// THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// Author: Hamad Fuad
// Email: ihamadfouad@icloud.com
//
// Created At: 19/04/2022
// Last modified: 19/04/2022
//
// ºººº----------------------------------------------------------------------ºººº \\

import Foundation

enum APIError: Error, LocalizedError {

    case unacceptableStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .unacceptableStatusCode(let statusCode):
            return "Response status code was unacceptable: \(statusCode)."
        }
    }
}

protocol RESTAPIDelegate {

    func service(_ service: RESTAPI, willSendRequest request: inout URLRequest) async throws
    func shouldRetry(_ service: RESTAPI, for request: URLRequest, withError error: Error) async throws -> Bool
    func service(_ service: RESTAPI, didReceiveInvalidResponse response: HTTPURLResponse, data: Data) -> Error
}

extension RESTAPIDelegate {

    func service(_ service: RESTAPI, willSendRequest request: inout URLRequest) async throws {}
    func shouldRetry(_ service: RESTAPI, for request: URLRequest, withError error: Error) async throws -> Bool { false }
    func service(_ service: RESTAPI, didReceiveInvalidResponse response: HTTPURLResponse, data: Data) -> Error {
        APIError.unacceptableStatusCode(response.statusCode)
    }
}

private struct DefaultRESTAPIDelegate: RESTAPIDelegate {}

actor RESTAPI {

    private let configuration: Configuration
    private let session: URLSession
    private let serializer: Serializer
    private let delegate: RESTAPIDelegate
    private let sessionController = SessionController()

    struct Configuration {

        var baseURL: URL?
        var sessionConfiguration: URLSessionConfiguration = .default
        var decoder: JSONDecoder?
        var encoder: JSONEncoder?
        var delegate: RESTAPIDelegate?

        var sessionDelegate: URLSessionDelegate?

        init(url: URL?, configuration: URLSessionConfiguration = .default, delegate: RESTAPIDelegate? = nil) {

            baseURL = url
            sessionConfiguration = configuration
            self.delegate = delegate
        }
    }

    convenience init(baseURL: URL?, _ configure: (inout RESTAPI.Configuration) -> Void = { _ in }) {

        var configuration = Configuration(url: baseURL)
        configure(&configuration)

        self.init(configuration: configuration)
    }

    init(configuration: Configuration) {

        self.configuration = configuration

        let queue = OperationQueue(maxConcurrentOperationCount: 1)

        let delegate = URLSessionProxyDelegate.create(session: sessionController, delegate: configuration.sessionDelegate)

        session = URLSession(configuration: configuration.sessionConfiguration, delegate: delegate, delegateQueue: queue)
        self.delegate = configuration.delegate ?? DefaultRESTAPIDelegate()
        serializer = Serializer(decoder: configuration.decoder, encoder: configuration.encoder)
    }

    func send<T: Decodable>(_ request: Request<T?>) async throws -> Response<T?> {

        try await send(request) { data in

            guard !data.isEmpty
            else {
                return nil
            }

            return try await self.decode(data)
        }
    }

    func send<T: Decodable>(_ request: Request<T>) async throws -> Response<T> {
        try await send(request, decode)
    }

    private func decode<T: Decodable>(_ data: Data) async throws -> T {

        if T.self == Data.self {

            return data as! T

        } else if T.self == String.self {

            guard let string = String(data: data, encoding: .utf8)
            else {
                throw URLError(.badServerResponse)
            }

            return string as! T

        } else {

            return try await self.serializer.decode(data)
        }
    }

    @discardableResult
    func send(_ request: Request<Void>) async throws -> Response<Void> {
        try await send(request) { _ in () }
    }

    private func send<T>(_ request: Request<T>,
                         _ decode: @escaping (Data) async throws -> T) async throws -> Response<T> {

        let response = try await data(for: request)
        let value = try await decode(response.value)

        return response.map { _ in value }
    }

    func data<T>(for request: Request<T>) async throws -> Response<Data> {

        let request = try await createRequest(for: request)

        return try await send(request)
    }

    private func send(_ request: URLRequest) async throws -> Response<Data> {

        do {
            return try await requestData(request)
        } catch {

            guard try await delegate.shouldRetry(self, for: request, withError: error)
            else {
                throw error
            }

            return try await requestData(request)
        }
    }

    private func requestData(_ request: URLRequest) async throws -> Response<Data> {

        var request = request

        try await delegate.service(self, willSendRequest: &request)

        let (data, response, metrics) = try await sessionController.data(for: request, session: session)

        try validate(response: response, data: data)

        return Response(value: data, data: data, request: request, response: response, metrics: metrics)
    }

    private func createRequest<T>(for request: Request<T>) async throws -> URLRequest {

        let url = try createURL(path: request.path, query: request.query)

        return try await createRequest(url: url, method: request.method, body: request.body, headers: request.headers)
    }

    private func createURL(path: String, query: Params?) throws -> URL {

        func createAbsoluteURL() -> URL? {
            path.starts(with: "/") ? configuration.baseURL?.appendingPathComponent(path) : URL(string: path)
        }

        guard let url = createAbsoluteURL(),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw URLError(.badURL)
        }

        if let query = query, !query.isEmpty {

            components.queryItems = query.map({ (key: String, value: CustomStringConvertible) in
                URLQueryItem(name: key, value: value as? String)
            })
        }

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        return url
    }

    private func createRequest(url: URL, method: HTTPMethod, body: AnyEncodable?, headers: Params?) async throws -> URLRequest {

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpMethod = method.rawValue

        if let body = body {
            request.httpBody = try await serializer.encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }

    private func validate(response: URLResponse, data: Data) throws {

        guard let httpResponse = response as? HTTPURLResponse
        else {
            return
        }

        if !(200..<300).contains(httpResponse.statusCode) {
            throw delegate.service(self, didReceiveInvalidResponse: httpResponse, data: data)
        }
    }
}
