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

final class SessionController: NSObject, URLSessionDataDelegate {

    private final class SessionTaskController {

        var data: Data?
        var metrics: URLSessionTaskMetrics?
        let completion: Completion

        init(completion: @escaping Completion) {
            self.completion = completion
        }
    }

    private var tasks = [URLSessionTask: SessionTaskController]()
    private typealias Completion = (Result<(Data, URLResponse, URLSessionTaskMetrics?), Error>) -> Void

    func data(for request: URLRequest, session: URLSession) async throws -> (Data, URLResponse, URLSessionTaskMetrics?) {

        final class SessionTask {

            var task: URLSessionTask?
        }

        let sessionTask = SessionTask()

        return try await withTaskCancellationHandler(handler: {
            sessionTask.task?.cancel()
        }, operation: {

            try await withUnsafeThrowingContinuation { continuation in

                sessionTask.task = self.session(with: request, session: session) { result in

                    continuation.resume(with: result)
                }
            }
        })
    }

    private func session(with request: URLRequest, session: URLSession, completion: @escaping Completion) -> URLSessionTask {

        let task = session.dataTask(with: request)

        session.delegateQueue.addOperation {
            self.tasks[task] = SessionTaskController(completion: completion)
        }

        task.resume()

        return task
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        guard let handler = tasks[task]
        else {
            return
        }

        tasks[task] = nil

        if let response = task.response, error == nil {
            handler.completion(.success((handler.data ?? Data(), response, handler.metrics)))
        } else {
            handler.completion(.failure(error ?? URLError(.unknown)))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        tasks[task]?.metrics = metrics
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        guard let handler = tasks[dataTask]
        else {
            return
        }

        if handler.data == nil {
            handler.data = Data()
        }

        handler.data!.append(data)
    }
}
