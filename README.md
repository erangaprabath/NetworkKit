# NetworkKit

A lightweight async/await networking layer for Swift.

## Requirements

- iOS 15+ / macOS 12+ / tvOS 15+ / watchOS 8+
- Swift 6.0+ (Xcode 16+)

## Installation (Swift Package Manager)

### Xcode

1. **File → Add Package Dependencies…**
2. Enter the URL: `https://github.com/erangaprabath/NetworkKit.git`
3. Choose a version rule (e.g. *Up to Next Major* from `0.0.1`) and add the `NetworkKit` library to your target.

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/erangaprabath/NetworkKit.git", from: "0.0.1")
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "NetworkKit", package: "NetworkKit")
        ]
    )
]
```

## Usage

```swift
import NetworkKit

struct UserEndpoint: EndpointsProtocol {
    var baseURL: String? { "https://api.example.com" }
    var path: String { "/users/1" }
    var httpMethod: HTTPMethod { .get }
    var header: [String: String]? { ["Content-Type": "application/json"] }
    var queryItems: [String: String]? { nil }
    var body: (any Encodable & Sendable)? { nil }
    var isAuthTokenRequired: Bool { false }
    var authToken: (key: String, value: String)? { nil }
    var publickKey: String? { nil }
    var privateKey: String? { nil }
    var rawBody: Data? { nil }
}

struct User: Decodable {
    let id: Int
    let name: String
}

let network = NetworkKit(
    cacheManager: CacheManager(logs: NetworkLogger()),
    requestManager: RequestManager()
)

do {
    let user: User = try await network.dataFetch(UserEndpoint())
    print(user.name)
} catch let error as NetworkError {
    print("Network error: \(error)")
}
```
