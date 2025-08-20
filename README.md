# sennsi_app

就活支援ゲームアプリ - タスク管理とゲーム要素を組み合わせたFlutterアプリケーション

## プロジェクト概要

このアプリは就職活動を支援するためのタスク管理アプリで、ゲーム要素を取り入れることでユーザーのモチベーション維持を図っています。

### 主な機能
- 📋 タスク・目標管理
- 📅 カレンダー統合
- 🎮 ゲーム要素（Flameエンジン使用）
- 👤 プロフィール・ステータス管理
- 🎵 BGM・効果音

### 技術スタック
- **フレームワーク**: Flutter 3.35.1
- **状態管理**: Provider
- **ルーティング**: go_router
- **ゲームエンジン**: Flame
- **音声**: flame_audio
- **ローカルストレージ**: shared_preferences

## libディレクトリ構造

```
lib/
├── main.dart                 # アプリのメイン起動ファイル
├── config/                   # 設定関連
│   ├── router.dart          # ナビゲーション設定
│   └── themes.dart          # テーマ・スタイル設定
├── core/                     # コア機能
│   ├── config/              # コア設定
│   ├── constants/           # 定数定義
│   └── utils/               # ユーティリティ関数
├── features/                 # 機能別モジュール
│   ├── auth/                # 認証機能
│   │   └── login_screen.dart
│   ├── home/                # ホーム画面
│   │   └── home_screen.dart
│   ├── tasks/               # タスク管理
│   │   └── task_list_screen.dart
│   ├── calendar/            # カレンダー
│   │   └── calender_screen.dart
│   ├── profile/             # プロフィール
│   │   ├── profile_screen.dart
│   │   ├── status_screen.dart
│   │   └── profile_data_input_screen.dart
│   └── game/                # ゲーム機能（Flameエンジン）
│       ├── game.dart        # メインゲームロジック
│       ├── game_screen.dart # ゲーム画面
│       ├── stage_screen.dart # ステージ選択
│       ├── battle/          # バトル機能
│       │   └── battle_screen.dart
│       └── components/      # ゲームコンポーネント
│           ├── sennsi.dart  # キャラクター
│           └── background.dart
├── shared/                   # 共有リソース
│   ├── models/              # データモデル
│   │   ├── user.dart        # ユーザーモデル
│   │   └── task.dart        # タスクモデル
│   └── widgets/             # 共通ウィジェット
│       ├── shell.dart       # ナビゲーションシェル
│       ├── BottomNavigationBar.dart
│       ├── add_edit_medium_goal_dialog.dart
│       └── add_edit_small_goal_dialog.dart
├── game/                     # レガシーゲームファイル
│   └── task_battle_game.dart
└── components/              # レガシーコンポーネント
    ├── sennsi.dart
    ├── flash_effect.dart
    └── background.dart
```

### アーキテクチャの特徴
- **機能ベース設計**: 各機能が独立したディレクトリ
- **クリーンアーキテクチャ**: UI、ビジネスロジック、データが分離
- **Provider状態管理**: リアクティブなUI更新
- **再利用可能な設計**: 共通コンポーネントの共有

## Getting Started

### 前提条件
- Flutter 3.7.2以上
- Dart SDK
- Android Studio / Xcode（モバイル開発の場合）

### セットアップ
```bash
# 依存関係のインストール
flutter pub get

# アプリの実行
flutter run

# 静的解析
flutter analyze

# テスト実行
flutter test
```

### 対応プラットフォーム
- iOS
- Android
- Web
- macOS
- Windows
- Linux

## 開発リソース

Flutterを初めて使用する場合は、以下のリソースを参照してください：

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter公式ドキュメント](https://docs.flutter.dev/)
