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

public enum ContentMimeType: String {

    case md = "text/markdown"
    case html, htm, shtml = "text/html"
    case css = "text/css"
    case xml = "text/xml"
    case gif = "image/gif"
    case jpeg, jpg = "image/jpeg"
    case js = "application/javascript"
    case atom = "application/atom+xml"
    case rss = "application/rss+xml"
    case mml = "text/mathml"
    case txt = "text/plain"
    case jad = "text/vnd.sun.j2me.app-descriptor"
    case wml = "text/vnd.wap.wml"
    case htc = "text/x-component"
    case png = "image/png"
    case tif, tiff = "image/tiff"
    case wbmp = "image/vnd.wap.wbmp"
    case ico = "image/x-icon"
    case jng = "image/x-jng"
    case bmp = "image/x-ms-bmp"
    case svg, svgz = "image/svg+xml"
    case webp = "image/webp"
    case woff = "application/font-woff"
    case jar, war, ear = "application/java-archive"
    case json = "application/json"
    case hqx = "application/mac-binhex40"
    case doc = "application/msword"
    case pdf = "application/pdf"
    case ps, eps, ai = "application/postscript"
    case rtf = "application/rtf"
    case m3u8 = "application/vnd.apple.mpegurl"
    case xls = "application/vnd.ms-excel"
    case eot = "application/vnd.ms-fontobject"
    case ppt = "application/vnd.ms-powerpoint"
    case wmlc = "application/vnd.wap.wmlc"
    case kml = "application/vnd.google-earth.kml+xml"
    case kmz = "application/vnd.google-earth.kmz"
    case _7z = "application/x-7z-compressed"
    case cco = "application/x-cocoa"
    case jardiff = "application/x-java-archive-diff"
    case jnlp = "application/x-java-jnlp-file"
    case run = "application/x-makeself"
    case pl, pm = "application/x-perl"
    case prc, pdb = "application/x-pilot"
    case rar = "application/x-rar-compressed"
    case rpm = "application/x-redhat-package-manager"
    case sea = "application/x-sea"
    case swf = "application/x-shockwave-flash"
    case sit = "application/x-stuffit"
    case tcl, tk = "application/x-tcl"
    case der, pem, crt = "application/x-x509-ca-cert"
    case xpi = "application/x-xpinstall"
    case xhtml = "application/xhtml+xml"
    case xspf = "application/xspf+xml"
    case zip = "application/zip"
    case bin, exe, dll, deb, dmg, iso, img, msi, msp, msm = "application/octet-stream"
    case docx = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    case xlsx = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    case pptx = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
    case mid, midi, kar = "audio/midi"
    case mp3 = "audio/mpeg"
    case ogg = "audio/ogg"
    case m4a = "audio/x-m4a"
    case ra = "audio/x-realaudio"
    case _3gpp, _3gp = "video/3gpp"
    case ts = "video/mp2t"
    case mp4 = "video/mp4"
    case mpeg, mpg = "video/mpeg"
    case mov = "video/quicktime"
    case webm = "video/webm"
    case flv = "video/x-flv"
    case m4v = "video/x-m4v"
    case mng = "video/x-mng"
    case asx, asf = "video/x-ms-asf"
    case wmv = "video/x-ms-wmv"
    case avi = "video/x-msvideo"
}
