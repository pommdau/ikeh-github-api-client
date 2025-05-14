#!/bin/zsh

# ⚠️ 環境変数を設定するために、Xcodeを閉じた状態で本コマンドを起動してください
# refs: https://forums.swift.org/t/swiftpm-and-swappable-libraries/43593

# スクリプトが存在するディレクトリに移動
cd "$(dirname "$0")"

# 環境変数を設定してからXcodeでPackage.swiftを開く
## SwiftLint-Pluginsを有効にする
export ENABLE_SWIFTLINT_PLUGINS=true

open Package.swift
