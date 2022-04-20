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

struct Request<Response> {
    
    var method: HTTPMethod
    var path: String
    var query: Params?
    var body: AnyEncodable?
    var headers: Params?
    var id: String?

    init(method: HTTPMethod = .get,
         path: String,
         query: Params? = nil,
         headers: Params? = nil) {

        self.method = method
        self.path = path
        self.query = query
        self.headers = headers
    }

    init<U: Encodable>(method: HTTPMethod = .post,
                       path: String,
                       query: Params? = nil,
                       headers: Params? = nil,
                       body: U?) {
        self.method = method
        self.path = path
        self.query = query
        self.headers = headers
        self.body = body.map(AnyEncodable.init)
    }

    static func send(method: HTTPMethod = .post,
                     _ path: String,
                     query: Params? = nil,
                     headers: Params? = nil) -> Request {

        Request(method: method,
                path: path,
                query: query,
                headers: headers)
    }

    static func send<U: Encodable>(method: HTTPMethod = .post,
                                   _ path: String,
                                   query: Params? = nil,
                                   headers: Params? = nil,
                                   body: U?) -> Request {

        Request(method: method,
                path: path,
                query: query,
                headers: headers,
                body: body)
    }
}
