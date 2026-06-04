# 时光囊·树洞

[![HarmonyOS NEXT](https://img.shields.io/badge/HarmonyOS-NEXT-000000?logo=harmonyos)](https://developer.harmonyos.com/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**一个匿名心情记录 App**，支持图文混排、视频、音频附件，内置点赞评论。无需注册，只需一个数字 ID，所有数据都存储在本地，真正的“树洞”。

## ✨ 功能特性

- **匿名身份**：无需注册登录，仅需一个数字 ID（如手机尾号或随机数），即可开启记录。
- **富媒体内容**：支持 **图文混排 + 视频 + 音频** 附件，一条心情可包含多种元素。
- **社交互动**：对每条心情可 **点赞**、**评论**，评论支持外键级联删除。
- **卡片展示**：使用 `Swiper` 组件实现卡片式滑动浏览。
- **图片墙**：网格布局展示所有图片附件，点击可放大预览。
- **视频缩略图**：自动提取视频首帧（最近关键帧）作为封面，使用 `AVImageGenerator` + `AVMetadataExtractor`。
- **纯本地存储**：数据库使用 `@kit.ArkData` 的 `relationalStore`，所有媒体文件拷贝到应用沙箱，不上传任何内容。
- **附件选择**：
  - 图片/视频：`PhotoViewPicker`
  - 音频：`DocumentViewPicker`
  - 选取后通过 `fileIo.copyFileSync` 复制到应用私有目录

## 📸 应用预览

> 
<img width="400" height="400" alt="reehole" src="https://github.com/user-attachments/assets/cc9f3c5b-e9f7-4393-85dd-054caaee8d86" />
<img width="400" height="400" alt="nspirationdrawer" src="https://github.com/user-attachments/assets/c89d82d0-a078-4ce9-a7cd-e6ba2f6b815c" />
<img width="400" height="400" alt="led" src="https://github.com/user-attachments/assets/27c3378e-ca81-4f1a-aac6-2bcb88b5271a" />


## 🛠️ 技术实现

- **开发语言**：ArkTS
- **UI 框架**：`@kit.ArkUI` 声明式开发
- **数据库**：`relationalStore`（SQLite）
  - `mood` 表：存储心情（id, digital_id, content, media_paths_json, like_count, create_time）
  - `comment` 表：存储评论（id, mood_id, content, create_time），外键 `mood_id` 关联 `mood(id)`，并设置 **级联删除**
- **文件选取**：
  - `PhotoViewPicker`：选择图片/视频，返回 uri
  - `DocumentViewPicker`：选择音频文件，返回 uri
- **文件操作**：
  - `fileIo.copyFileSync`：将选取的文件复制到应用沙箱（`/data/app/el2/100/base/...`），便于持久化
- **视频缩略图**：
  - `AVImageGenerator`：`fetchFrameByTime` 获取指定时间点的关键帧
  - `AVMetadataExtractor`：辅助获取视频信息
- **卡片滑动**：`Swiper` 组件实现全屏卡片切换
- **图片墙**：`Grid` + `GridItem`，点击可触发 `Image` 预览组件
- **点赞/评论**：`@State` 管理本地计数，修改数据库对应字段

## 📁 项目结构


<pre><code>```text LED/
time-capsule-treehole/
├── AppScope/
├── entry/
│ ├── src/
│ │ ├── main/
│ │ │ ├── ets/
│ │ │ │ ├── common/ # 数据库 helper、文件工具类
│ │ │ │ ├── entryability/ # 应用入口
│ │ │ │ └── pages/
│ │ │ │ ├── Index.ets # Swiper 卡片列表主页面
│ │ │ │ ├── Editor.ets # 新建心情（图文/视频/音频混合）
│ │ │ │ ├── Detail.ets # 心情详情（展示评论、点赞）
│ │ │ │ └── ImageWall.ets # 图片墙（网格展示所有图片）
│ │ │ └── resources/ # 资源文件（图标、默认图等）
│ │ ├── ohosTest/
│ │ └── test/
│ ├── build-profile.json5
│ └── oh-package.json5
├── hvigor/
├── build-profile.json5
├── oh-package.json5
└── README.md  ```</code></pre>




## ⚙️ 环境要求

- **DevEco Studio**：5.0.0 Release 或更高版本
- **HarmonyOS SDK**：API 12 或更高版本（HarmonyOS NEXT）
- **设备**：搭载 HarmonyOS NEXT 的真机或模拟器

## 🚀 安装与运行

1. 克隆仓库到本地：
   ```bash
   git clone https://github.com/shippingzhou/treeHole


   使用 DevEco Studio 打开项目。
等待项目同步和依赖下载完成。
连接鸿蒙设备或开启模拟器，点击运行按钮 Run 'entry'。


📖 使用说明

首次进入：输入一个数字 ID（例如手机尾号 4 位），后续所有心情将关联此 ID（纯本地，不上传）。
新建心情：

点击「+」进入编辑器。
输入文字内容（支持多行）。
点击图片/视频按钮，调用 PhotoViewPicker 选择媒体文件，自动复制到沙箱。
点击音频按钮，调用 DocumentViewPicker 选择 MP3/AAC 文件，同样复制到沙箱。
卡片浏览：主界面以卡片形式展示所有心情，可左右滑动切换。
点赞/评论：

卡片下方显示点赞数，点击即可点赞（再次点击取消）。
点击评论图标进入详情页，可查看已有评论并添加新评论。
图片墙：点击任意心情卡片中的图片区域，可进入网格视图浏览所有图片。
数据管理：所有数据均存储在本地，卸载 App 前可考虑手动备份（后续可增加导出功能）。


🤝 贡献指南

欢迎通过 Issue 或 PR 参与改进。

Fork 本仓库
新建分支 git checkout -b feature/你的功能
提交更改 git commit -m 'Add some feature'
推送到分支 git push origin feature/你的功能
创建 Pull Request
📜 许可证

本项目基于 MIT 许可证开源，详情见 LICENSE 文件。

🙏 鸣谢

HarmonyOS NEXT 提供开发平台
图标来自 Iconify 和本地资源


