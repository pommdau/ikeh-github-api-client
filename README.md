# ikeh-github-api-client

## 概要
- GitHub APIを利用するためのクライアント
- 自身が利用する一部の機能のみの実装となっています

## 使用例

- 基本的な使用例は以下の通りです

```swift
let gitHubAPIClient = GitHubAPIClient(
    clientID: GitHubAPICredentials.clientID,
    clientSecret: GitHubAPICredentials.clientSecret,
    callbackURL: URL(string: "your-app-scheme://callback")!,
    scope: "repo",
    urlSession: URLSession.shared
)
let response = try await gitHubAPIClient.searchRepos(query: "SwiftUI", accessToken: nil)
for repo in response.items {
    print("\(repo.fullName)")
}
```

- またスターをつけるなど認証を必要とする場合、準備として個人のGitHubのOAuth Appを作成する必要があります
    - 参考: [iOSアプリでGitHubAPIのOAuth認証を行う](https://zenn.dev/ikeh1024/articles/dd5678087362c4)
- その後下記の通り認証を行いアクセストークンを取得し、このアクセストークンをメソッドに引数として渡してください

```swift
// 認証画面をブラウザで開く
try await gitHubAPIClient.openLoginPageInBrowser()

// コールバックURLの受取処理
.onOpenURL { url in
    Task {
        do {
            let accessToken = try await gitHubAPIClient.recieveLoginCallBackURLAndFetchAccessToken(url)
            // アクセストークンをKeychain等に保存
        } catch {
            print(error.localizedDescription)
        }
    }
}
```

- その他詳細に関してはサンプルリポジトリを参照ください
    - https://github.com/pommdau/ikeh-github-api-client/tree/main/PackageExample

# SwiftLint Plugins

- .zshrcに下記を記載

```sh
export ENABLE_SWIFTLINT_PLUGINS=true
```

- または下記で起動

```sh
ENABLE_SWIFTLINT_PLUGINS=true open -a /Applications/Xcode-14.0.0.app .
ENABLE_SWIFTLINT_PLUGINS=true open Package.swift -a /Applications/Xcode-14.0.0.app
ENABLE_SWIFTLINT_PLUGINS=true open Package.swift
```
