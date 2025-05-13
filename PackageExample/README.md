# IKEHGitHubAPIClientExample

## 前準備

- 手元でアプリの動きを見る場合は、自身で作成したOAuth Appの認証情報を含んだ`GitHubAPICredentials.swift`を作成してください

```swift
import Foundation

enum GitHubAPICredentials {
    static let clientID = "your-client-id"
    static let clientSecret = "yout-client-secret"
}
```
