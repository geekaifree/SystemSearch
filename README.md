# 🔍 SystemSearch — 系统级极速搜索

<p align="center">
  <img src="assets/icon.svg" width="128" height="128" alt="SystemSearch">
</p>

<p align="center">
  <strong>秒开程序、文件、搜索网页，一个搜索框搞定一切</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Android-6.0+-3DDC84?style=flat&logo=android" alt="Android">
  <img src="https://img.shields.io/badge/macOS-10.14+-007AFF?style=flat&logo=apple" alt="macOS">
  <img src="https://img.shields.io/badge/iOS-13.0+-007AFF?style=flat&logo=apple" alt="iOS">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat" alt="License">
</p>

---

## 📖 简介

SystemSearch 是一款系统级全局搜索工具，替代传统开始菜单，提供更快速、更智能的搜索体验。支持搜索应用、文件、系统设置和网页。

## ✨ 功能

| 功能 | 说明 |
|------|------|
| 🔍 全局搜索 | 一个搜索框搜索所有内容 |
| 📱 应用搜索 | 搜索已安装应用 |
| 📁 文件搜索 | 搜索本地文件 |
| ⚙️ 设置搜索 | 搜索系统设置项 |
| 🌐 网页搜索 | 快速发起网络搜索 |
| 🏷️ 分类筛选 | 按类型筛选结果 |
| 📋 搜索历史 | 自动保存搜索记录 |
| ⚡ 实时搜索 | 输入即搜，无需等待 |

## 🏗️ 技术栈

- Flutter 3.0+ / Dart 3.0+
- SharedPreferences 本地存储
- Material Design 3

## 📁 项目结构

```
SystemSearch/
├── lib/main.dart
├── assets/icon.svg
├── android/ ios/ macos/
├── pubspec.yaml
└── README.md
```

## 🚀 构建运行

```bash
flutter pub get
flutter run -d android / macos / ios
flutter build apk --release
flutter build macos --release
flutter build ios --release
```

## 📝 更新日志

### v1.0.0
- 首次发布
- 应用/文件/设置/网页搜索
- 分类筛选
- 搜索历史

## 📄 许可证

MIT License
