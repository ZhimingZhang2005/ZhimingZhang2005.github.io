# 本地维护说明

项目目录：`C:\Users\27430\Downloads\推免相关\personal_page`

这是网站的完整 Git 仓库，远端为 `ZhimingZhang2005/ZhimingZhang2005.github.io`，发布分支为 `master`。

## 启动预览

在此目录打开 PowerShell 或 VS Code 终端，运行：

```powershell
.\site.cmd preview
```

打开 **http://localhost:4000/**，等待终端显示 `Server running`。

保持该终端运行，然后用编辑器修改源文件并保存。预览会自动重新构建，浏览器通过 LiveReload 刷新。这里启用了轮询，以便 WSL 能检测 Windows 文件夹内的修改。

修改 `_config.yml`、`.scripts/preview.yml` 后，停止并重新启动预览。

停止方法：在预览终端按 **Ctrl+C**。若预览在后台运行，另开一个终端运行：

```powershell
.\site.cmd stop
```

若 4000 端口被其他程序占用，可使用：

```powershell
.\site.cmd preview 4001
```

此时打开 http://localhost:4001/。

## 修改哪些文件

| 内容 | 源文件 |
| --- | --- |
| 首页、自我介绍、研究经历、奖项 | `_pages/about.md` |
| 在线简历 | `_pages/cv.md` |
| 姓名、侧栏简介、邮箱、电话、GitHub、头像文件名 | `_config.yml` 中的 `author` |
| 顶部导航 | `_data/navigation.yml` |
| Notes 列表与空状态 | `_pages/year-archive.html` |
| 每篇学习笔记 | `_posts/YYYY-MM-DD-title.md` |
| 图片 | `images/` |
| PDF 等附件 | `files/` |
| 可选的结构化简历数据 | `_data/cv.json` |

主要页面使用 Markdown。文件开头两段 `---` 之间是 YAML 配置；修改正文时保留这段配置，YAML 缩进用空格。

`_site/` 是自动生成的预览页面，修改它会被下一次构建覆盖。日常修改上表中的源文件。

## 添加一篇笔记

如果 `_posts` 文件夹不存在，先创建它。然后创建例如 `_posts/2026-09-28-trustworthy-ai-reading.md`：

```markdown
---
title: "Reading Notes on Trustworthy AI"
date: 2026-09-28
excerpt: "A short summary of this reading."
comments: false
share: false
---

## Overview

Write your notes here.

## Takeaways

- First observation.
- Second observation.
```

保存后会自动出现在 Notes 页面。未来日期的文章不会显示，直到该日期到来。

插入图片的例子：

```markdown
![Diagram](/images/my-diagram.png)
```

添加 PDF 下载链接的例子：

```markdown
[Download PDF](/files/my-document.pdf)
```

添加自己的照片时，将照片放入 `images/`，再修改 `_config.yml` 的 `author.avatar`，例如 `avatar: "profile.jpg"`。

## 检查构建

先停止预览，再执行：

```powershell
.\site.cmd build
```

看到 `done` 且没有报错，表示生产配置构建完成。之后可重新运行预览。

## 发布到 GitHub

本地修改和预览不会更新线上网站。确认效果并完成构建后，检查并提交需要发布的文件：

```powershell
git status
git diff
git add .
git commit -m "Update personal website"
git push origin master
```

`git add .` 会包含当前目录所有未忽略的修改；提交前通过 `git status` 确认文件列表。`.local/`、`_site/` 和本机依赖不会被提交。

推送后查看仓库的 **Actions**，等待 GitHub Pages 发布完成，再打开 https://zhimingzhang2005.github.io/。

如果也在 GitHub 网页上改过代码，可在本地开始新修改前运行 `git pull --ff-only`。若提示本地存在修改，先查看 `git status` 并妥善保存这些修改。

## 依赖环境

此电脑使用 **WSL Ubuntu + Ruby 3.2 + Bundler 2.4 + Jekyll 3.10**。`site.cmd` 会进入 Ubuntu，但源文件一直保存在当前 Windows 文件夹内，可以用 Windows 编辑器修改。

项目在 `.local/` 保留依赖副本和快速恢复包 `bundle-cache.tar`，版本记录在本地 `Gemfile.lock`。运行时从 Ubuntu `/tmp/zhiming-jekyll-*` 中加载依赖缓存，以加快启动。缓存不存在时，脚本会从当前项目自动重新准备；不依赖之前 Documents/Codex 工作目录的位置。

需要重新安装项目依赖时：

```powershell
.\site.cmd setup
```

如果将项目搬到另一台已有 WSL Ubuntu 的电脑，先在 Ubuntu 安装 Ruby 工具，再执行上面的 `setup`：

```bash
sudo apt-get update
sudo apt-get install -y ruby ruby-dev ruby-bundler build-essential libssl-dev zlib1g-dev libyaml-dev
```

首次启动需要准备 Ubuntu 依赖缓存，稍后的启动会直接复用它。

官方说明：[Jekyll 命令行](https://jekyllrb.com/docs/usage/)、[预览与配置选项](https://jekyllrb.com/docs/configuration/options/)。
