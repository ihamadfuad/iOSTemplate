[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) 
[![SPM compatible](https://img.shields.io/badge/SPM-Compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager/)
[![Swift](https://img.shields.io/badge/Swift-5.6-orange.svg)](https://swift.org)
[![Xcode](https://img.shields.io/badge/Xcode-13.3-blue.svg)](https://developer.apple.com/xcode)
![Issues](https://img.shields.io/github/issues/ihamadfuad/iOSTemplate) 
![Releases](https://img.shields.io/github/v/release/ihamadfuad/iOSTemplate)

# Sponsor
[![Sponsor](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://paypal.me/nuralme?country.x=BH&locale.x=en_US)

# iOSTemplate

This template repository will allow you to get a new project up more quicker, so you can focus on 
starting the actual developing process and not wasting too much time on making configurations 
that are shared for every project.

## Installation
### Swift Package Manager (SPM)

You can use The Swift Package Manager to install iOSTemplate by adding it to your Package.swift file:

    import PackageDescription

    let package = Package(
        name: "MyApp",
        targets: [],
        dependencies: [
            .Package(url: "https://github.com/ihamadfuad/iOSTemplate.git", .from: "1.0.0")
        ]
    )
