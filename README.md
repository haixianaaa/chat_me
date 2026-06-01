# ChatMe - AI 角色聊天应用

一款基于 Flutter 开发的 AI 角色聊天应用，支持多种预设 AI 角色，采用流式响应实现打字机效果，支持 Markdown 渲染，带来流畅自然的对话体验。

## 应用截图

> 欢迎提交 PR 补充应用截图

## 功能特性

### AI 角色系统
- **6 种预设角色**：AI 助手、程序员、作家、老师、心理咨询师、厨师
- 每个角色拥有独立的人设、系统提示词和开场白
- 同一角色只保留一个会话，避免重复创建

### 聊天功能
- **流式响应**：实时显示 AI 回复，打字机效果
- **Markdown 渲染**：支持标题、代码块、列表、引用等格式
- **长按复制**：长按消息气泡即可复制内容
- **会话管理**：支持查看历史会话、删除会话

### 配置管理
- **自定义 API Key**：支持配置自己的 API 密钥
- **自定义 Base URL**：可切换不同的 API 服务端点
- **自定义模型**：可指定使用的 AI 模型
- 配置信息本地持久化存储

### 技术亮点
- **Provider 状态管理**：使用 Provider 进行全局状态管理
- **本地持久化**：使用 SharedPreferences 存储会话和配置
- **SSE 流式传输**：基于 Server-Sent Events 实现流式对话
- **Material Design 3**：采用最新 Material 3 设计规范

## 技术栈

| 技术 | 说明 |
|------|------|
| Flutter | 跨平台 UI 框架 |
| Provider | 状态管理方案 |
| http | 网络请求 |
| shared_preferences | 本地数据持久化 |
| flutter_markdown_plus | Markdown 渲染 |
| uuid | 唯一标识生成 |
| dart_openai | OpenAI 兼容 API 客户端 |

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/
│   ├── character.dart           # AI 角色模型（预设角色定义）
│   ├── chat_message.dart        # 聊天消息模型
│   └── chat_session.dart        # 聊天会话模型
├── pages/
│   ├── home_page.dart           # 首页（角色列表 + 会话列表）
│   └── chat_page.dart           # 聊天页面
├── providers/
│   └── chat_provider.dart       # 聊天状态管理
└── services/
    ├── ai_service.dart          # AI API 服务（SSE 流式请求）
    └── storage_service.dart     # 本地存储服务
```

## 预设角色

| 角色 | 头像 | 描述 |
|------|------|------|
| AI 助手 | 🤖 | 通用 AI 助手，可以回答各种问题 |
| 程序员 | 👨‍💻 | 资深程序员，擅长编程和技术问题 |
| 作家 | ✍️ | 创意作家，擅长写作和文案 |
| 老师 | 👩‍🏫 | 耐心老师，擅长知识讲解 |
| 心理咨询师 | 🧠 | 温暖的心理咨询师，倾听你的心声 |
| 厨师 | 👨‍🍳 | 美食达人，教你做各种美食 |

## 快速开始

### 环境要求

- Flutter SDK >= 3.11.1
- Dart SDK >= 3.11.1
- Android Studio / VS Code

### 安装与运行

```bash
# 克隆项目
git clone git@github.com:haixianaaa/chat_me.git
cd chat_me

# 安装依赖
flutter pub get

# 运行项目
flutter run
```

### 构建 APK

```bash
# 方式一：直接使用 Flutter 命令
flutter build apk --release

# 方式二：使用项目提供的构建脚本（自动读取版本号并重命名）
powershell -ExecutionPolicy Bypass -File build_apk.ps1
```

构建完成后，APK 文件位于 `build/app/outputs/flutter-apk/` 目录下。

## 下载安装

可以直接下载已构建好的 APK 文件进行安装：

📥 [下载 APK（v1.0.0）](releases/chat_me-v1.0.0.apk)

> 文件大小约 49MB，支持 Android 5.0 及以上版本

## API 配置

应用默认使用小米 MiMo API 服务，你也可以在设置中自定义配置：

| 配置项 | 默认值 | 说明 |
|--------|--------|------|
| API Key | （空） | 需自行填写，点击右上角设置图标 |
| Base URL | `https://api.xiaomimimo.com/v1` | API 服务地址 |
| Model | `mimo-v2-flash` | 使用的 AI 模型名称 |

应用兼容所有 OpenAI 格式的 API 接口，你可以替换为其他服务商的 API。

## 许可证

本项目仅供学习交流使用。
