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
// Created At: 20/04/2022
// Last modified: 20/04/2022
//
// ºººº----------------------------------------------------------------------ºººº \\

import Foundation

func createAPIURL(_ collection: String = "collections", _ path: String) -> URL {

    var components = URLComponents()
    components.scheme = "https"
    components.host = "nural-tech-server.herokuapp.com"
    components.path = "/" + collection + "/" + path

    guard let url = components.url else {

        preconditionFailure("⚠️ Invalid URL Components: \(components)")
    }

    return url
}

// Resource.crud.create(name: "E", content: E())
struct Resource<Content> where Content: Encodable {

    struct crud {

        static func create(_ method: HTTPMethod = .post, name: String, content: Content) -> (method: HTTPMethod, url: URL, body: Data?) {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.IsoDateFormatter)
            return (method, createAPIURL(name, String()), try? encoder.encode(content))
        }

        static func retrieve(_ method: HTTPMethod = .get, name: String) -> (method: HTTPMethod, url: URL, body: Data?) {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.IsoDateFormatter)
            return (method, createAPIURL(name, String()), nil)
        }

        static func find(_ method: HTTPMethod = .get, name: String, id: String) -> (method: HTTPMethod, url: URL, body: Data?) {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.IsoDateFormatter)
            return (method, createAPIURL(name, id), nil)
        }

        static func update(_ method: HTTPMethod = .patch, name: String, id: String, content: Content) -> (method: HTTPMethod, url: URL, body: Data?) {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.IsoDateFormatter)
            return (method, createAPIURL(name, id), try? encoder.encode(content))
        }

        static func delete(_ method: HTTPMethod = .delete, name: String, id: String) -> (method: HTTPMethod, url: URL, body: Data?) {

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(.IsoDateFormatter)
            return (method, createAPIURL(name, id), nil)
        }
    }
}






























