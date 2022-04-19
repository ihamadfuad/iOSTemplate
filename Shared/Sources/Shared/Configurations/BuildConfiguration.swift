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

enum Environment: String {

    case debugDevelopment = "Debug Development"
    case releaseDevelopment = "Release Development"

    case debugStaging = "Debug Staging"
    case releaseStaging = "Release Staging"

    case debug = "Debug"
    case release = "Release"
}

class BuildConfiguration {

    static let shared = BuildConfiguration()

    var environment: Environment

    var baseURL: String {

        switch environment {
        case .debugStaging, .releaseStaging:
            return "https://staging.example.com/api"
        case .debugDevelopment, .releaseDevelopment:
            return "https://dev.example.com/api"
        case .debug, .release:
            return "https://example.com/api"
        }
    }

    init() {

        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! [String: String]

        environment = Environment(rawValue: currentConfiguration["Environment"]!)!
    }
}
