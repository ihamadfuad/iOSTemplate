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

class URLSessionProxyDelegate: NSObject {

    private var delegate: URLSessionDelegate
    private let interceptedSelectors: Set<Selector>
    private let sessionController: SessionController

    static func create(session: SessionController, delegate: URLSessionDelegate?) -> URLSessionDelegate {

        guard let delegate = delegate
        else {
            return session
        }

        return URLSessionProxyDelegate(session: session,
                                       delegate: delegate)
    }

    init(session: SessionController, delegate: URLSessionDelegate) {

        sessionController = session
        self.delegate = delegate
        interceptedSelectors = [
            #selector(URLSessionDataDelegate.urlSession(_:dataTask:didReceive:)),
            #selector(URLSessionTaskDelegate.urlSession(_:task:didCompleteWithError:)),
            #selector(URLSessionTaskDelegate.urlSession(_:task:didFinishCollecting:))
        ]
    }

    override func responds(to aSelector: Selector!) -> Bool {

        if interceptedSelectors.contains(aSelector) {
            return true
        }

        return delegate.responds(to: aSelector) || super.responds(to: aSelector)
    }

    override func forwardingTarget(for selector: Selector!) -> Any? {

        interceptedSelectors.contains(selector) ? nil : delegate
    }
}

extension URLSessionProxyDelegate: URLSessionTaskDelegate, URLSessionDataDelegate {

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        sessionController.urlSession(session, dataTask: dataTask, didReceive: data)

        (delegate as? URLSessionDataDelegate)?.urlSession?(session, dataTask: dataTask, didReceive: data)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

        sessionController.urlSession(session, task: task, didCompleteWithError: error)

        (delegate as? URLSessionTaskDelegate)?.urlSession?(session, task: task, didCompleteWithError: error)
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {

        sessionController.urlSession(session, task: task, didFinishCollecting: metrics)

        (delegate as? URLSessionTaskDelegate)?.urlSession?(session, task: task, didFinishCollecting: metrics)
    }
}
