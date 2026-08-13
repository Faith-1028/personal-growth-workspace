# 我的个人工作台

一个支持多设备实时同步的个人成长工作台，包含日历视图、五大模块（健身/技能/工作/职业/记账）、SVG 图表、Supabase 云端同步。

## 功能

- **日历视图**：月视图（6x7 网格 + 彩色圆点）+ 周视图（带复选框）
- **五大模块**：健身减肥、技能学习、工作任务、职业成长、花销记账
- **云端同步**：基于 Supabase，多设备打开同一链接数据自动同步
- **离线缓存**：localStorage 持久化，断网可用，恢复后自动同步
- **数据备份**：CSV 导入导出，支持跨设备迁移
- **响应式**：PC + 移动端适配，可添加到手机主屏幕当 APP 使用
- **零依赖**：单文件 HTML，所有 CSS/JS/SVG 内联，无外部框架

## 快速开始

### 方式一：直接使用（离线模式）

1. 下载 `personal-growth-workspace.html`
2. 用浏览器打开即可使用
3. 数据存储在浏览器 localStorage，可导出 CSV 跨设备同步

### 方式二：配置云端同步（推荐）

#### Step 1: 创建 Supabase 项目

1. 前往 [supabase.com](https://supabase.com) 注册并创建新项目（免费）
2. 进入项目的 **SQL Editor**
3. 粘贴 `supabase_schema.sql` 内容并执行
4. 进入 **Settings > API**
5. 复制 **Project URL** 和 **anon public key**

#### Step 2: 配置工作台

1. 打开工作台页面
2. 滚动到底部「云端同步 (Supabase)」面板
3. 填入 Project URL 和 anon Key
4. 点击「连接云端」

连接后，多设备打开同一链接即可看到同一份数据，一端修改另一端 20 秒内自动刷新。

### 方式三：部署到 GitHub Pages

```bash
# 1. Fork 或 clone 本仓库
git clone https://github.com/YOUR_USERNAME/personal-growth-workspace.git

# 2. 进入目录
cd personal-growth-workspace

# 3. 将 personal-growth-workspace.html 重命名为 index.html
cp personal-growth-workspace.html index.html

# 4. 推送到 GitHub
git add .
git commit -m "个人成长工作台"
git push origin main
```

然后在 GitHub 仓库中：
1. 进入 **Settings > Pages**
2. Source 选择 **Deploy from a branch**
3. Branch 选择 **main** / **root**
4. 保存后等待 1-2 分钟

访问 `https://YOUR_USERNAME.github.io/personal-growth-workspace/` 即可使用。

## 数据同步原理

```
设备 A (浏览器)
  ├─ localStorage (离线缓存)
  └─ Supabase REST API ──┐
                          ├─ PostgreSQL 数据库
设备 B (浏览器)            │
  ├─ localStorage ─────────┘
  └─ 每 20 秒轮询拉取最新数据
```

- **写入**：本地 localStorage 即时保存 + 异步推送到 Supabase
- **读取**：启动时从 Supabase 拉取 + 每 20 秒轮询
- **冲突处理**：以 `updated_at` 时间戳为准，最新覆盖最旧
- **离线模式**：断网时操作暂存 localStorage，恢复后自动推送

## 文件说明

| 文件 | 说明 |
|------|------|
| `personal-growth-workspace.html` | 工作台主文件（单文件 HTML） |
| `supabase_schema.sql` | Supabase 建表脚本 |
| `README.md` | 本文档 |

## 技术栈

- 纯 HTML + CSS + JavaScript（无框架）
- Supabase PostgREST API（fetch 调用，无需 SDK）
- 内联 SVG 手写图表（折线图/环形图/柱状图/进度条）
- localStorage 离线缓存

## License

MIT
