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
// Last modified: 20/04/2022
//
// ºººº----------------------------------------------------------------------ºººº \\

import Foundation
import SwiftExtensions

struct NuralTechKeys {

    static let masterKeyProduction: String = "l7JkQiRqAMBXnSg/mEMoAMkOLt897Na+QHKnQObBf6brGxME6mEI+lLObQIgqSjeycAggCq0YtBFxLETLEUHIw=="
    static let applicationIdProduction: String = "PUwv9fg+xLjaEcYQmVnRyNf4HaZcNpSrlOHJe8PhyXc="
    static let clientKeyProduction: String = "HFPofBC6Gh3rHdMW2fMPlQ=="
}

typealias ResourceRequest = (method: HTTPMethod, url: URL, body: Data?)
struct User: Codable { }
/*
 Task.detached {

 do {

 let user = try await RESTAPI(Resource<User>.crud.create(name: "users", content: User()).request)
 .authentication(username: "", password: "")
 .bearer(token: "")
 .request()
 .decode(User.self)

 print(user)
 } catch {
 print(error)
 }
 }
 */
actor RESTAPI {

    fileprivate var urlRequest: URLRequest
    fileprivate var data: Data?
    fileprivate var urlResponse: URLResponse?

    init(_ resource: ResourceRequest) {

        urlRequest = URLRequest(url: resource.url,
                                method: resource.method,
                                contentMimeType: .json,
                                body: resource.body)

        Task.detached {

            do {

                let user = try await RESTAPI(Resource.crud.create(name: "users", content: User()))
                    .authentication(username: "", password: "")
                    .bearer(token: "")
                    .request()
                    .decode(User.self)

                print(user)
            } catch {
                print(error)
            }
        }
    }

    fileprivate func applicationAccess() {

        urlRequest.addValue(NuralTechKeys.masterKeyProduction, forHTTPHeaderField: "X-Nural-Master-Key")
        urlRequest.addValue(NuralTechKeys.applicationIdProduction, forHTTPHeaderField: "X-Nural-Application-Id")
        urlRequest.addValue(NuralTechKeys.clientKeyProduction, forHTTPHeaderField: "X-Nural-Client-Key")
    }

    func authentication(username: String, password: String) -> Self {

        if let loginData = "\(username):\(password)".data(using: String.Encoding.utf8) {

            let base64LoginString = loginData.base64EncodedString()
            urlRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

#if debug
            print("+---------------------+---------------------------------------------------------------------------------------------+")
            print("| Username / Password |  \(basicAuth)")
            print("+---------------------+---------------------------------------------------------------------------------------------+")
#endif
        }

        return self
    }

    func bearer(token: String) -> Self {

        urlRequest.setValue( "Bearer \(token)", forHTTPHeaderField: "Authorization")

#if debug
        print("+--------------+----------------------------------------------------------------------------------------------------+")
        print("| Bearer Token |  \(token)")
        print("+--------------+----------------------------------------------------------------------------------------------------+")
#endif

        return self
    }

    func request() async throws -> Self {

        applicationAccess()

        if let body = urlRequest.httpBody {

            print("+--------------+")
            print("| Request Body |")
            print("+--------------+")
            print(String(data: body, encoding: .utf8) ?? "Cannot read data.")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        print("+--------+----------------------------------------------------------------------------------------------------------+")
        print("| \(urlRequest.httpMethod ?? "Unknown") |  \((response as? HTTPURLResponse)?.statusCode ?? 404)  | \(String(describing: urlRequest.url))")
        print("+--------+----------------------------------------------------------------------------------------------------------+")

        self.data = data
        self.urlResponse = response

        return self
    }

    func response() -> (data: Data?, response: URLResponse?) {
        return (data, urlResponse)
    }

    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {

        guard let data = data
        else {
            throw "Data is invalid"
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(.IsoDateFormatter)

        return try decoder.decode(type, from: data)
    }

    func rawData() -> Data? {

        data
    }
}






