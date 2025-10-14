# Avante.nvim 配置说明

## 概述

这个配置将 `avante.nvim` 插件集成到你的 Neovim 配置中，并配置它使用本地的 ollama 接口而不是 `ollama.nvim`。

## 依赖项

avante.nvim 需要以下依赖项才能正常工作：

- **plenary.nvim**: 提供 Lua 工具函数
- **telescope.nvim**: 文件搜索和选择
- **nvim-treesitter**: 语法树解析和代码分析
- **nvim-tree**: 文件树浏览和文件选择
- **nvim-lspconfig**: LSP 配置和集成
- **mason.nvim**: 语言服务器管理

**注意**: 这些依赖项在你的 NvChad 配置中应该已经安装了，如果没有，lazy.nvim 会自动安装它们。

## 功能特性

- 🤖 本地 ollama 接口集成
- 💬 智能聊天窗口
- 🚀 代码生成和优化
- 🔧 代码解释和重构
- 📝 文件操作支持
- ⚡ 异步处理和缓存

## 前置要求

1. **安装 ollama**: 确保你的系统上已经安装并运行了 ollama 服务
2. **可用模型**: 你的系统上已有以下模型：
   - `phi3:mini` (3.8B) - 轻量级通用模型，当前默认
   - `deepseek-coder:latest` (1B) - 代码生成专用
   - `deepseek-coder:1.3b-base` (1B) - 代码生成基础版
   - `qwen3:4b` (4B) - 通用模型
   - `qwen:latest` (4B) - 通用模型

3. **切换模型**: 如需使用其他模型，修改 `lua/plugins/avante.lua` 中的 `model` 字段

## 快捷键配置

### 主要功能
- `<leader>ac` - 打开聊天窗口
- `<leader>ap` - 规划模式（Planning）
- `<leader>ae` - 编辑模式（Editing）
- `<leader>as` - 建议模式（Suggesting）
- `<leader>ar` - 审查模式（Reviewing）

### 文件选择
- `<leader>a+` - 添加文件到选择
- `<leader>a-` - 从选择中移除文件

### 代码操作
- `<leader>ae` - 解释当前代码
- `<leader>ao` - 优化当前代码
- `<leader>ar` - 重构当前代码
- `<leader>at` - 生成测试

### 聊天窗口导航
- `<C-c>` - 退出终端模式
- `<C-w>` - 窗口操作
- `<C-h/j/k/l>` - 窗口间导航

## 配置说明

### Ollama 接口配置
```lua
providers = {
  ollama = {
    enabled = true,
    base_url = "http://localhost:11434",  -- ollama 服务地址
    model = "phi3:mini",                  -- 默认模型
    timeout = 30000,                      -- 超时时间
    stream = true,                        -- 流式响应
  },
  -- 禁用其他提供者
  anthropic = { enabled = false },
  openai = { enabled = false },
  google = { enabled = false },
}

-- 设置默认提供者为 ollama
default_provider = "ollama"
```

**注意**: 当前配置使用 `phi3:mini` 作为默认模型，这是一个轻量级但功能强大的通用模型，适合各种编程和对话任务。

**重要**: 配置中已禁用其他 AI 提供者（Anthropic、OpenAI、Google），确保只使用本地 ollama 服务。

### 支持的编程语言
- Lua, Python, JavaScript, TypeScript
- Go, Rust, C++, C, Java
- C#, PHP, Ruby, Swift, Kotlin

### 自定义提示词
配置中包含了针对不同代码操作的预定义提示词，可以根据需要进行调整。

## 使用方法

1. **启动聊天**: 按 `<leader>ac` 打开聊天窗口
2. **代码生成**: 按 `<leader>ag` 开始代码生成对话
3. **代码解释**: 选中代码后按 `<leader>ae` 获取解释
4. **代码优化**: 选中代码后按 `<leader>ao` 获取优化建议

## 故障排除

### 常见问题

1. **连接失败**: 确保 ollama 服务正在运行在 `localhost:11434`
2. **模型不存在**: 使用 `ollama list` 检查可用模型，并更新配置中的 `model` 字段
3. **响应缓慢**: 调整 `timeout` 值或检查模型大小

### 日志查看
日志文件位置: `~/.local/share/nvim/avante.log`

## 自定义配置

你可以根据需要修改 `lua/plugins/avante.lua` 文件中的配置选项：

- 调整模型参数（temperature, top_p 等）
- 修改聊天窗口样式和位置
- 自定义提示词模板
- 调整性能参数

## 更新和升级

使用你的包管理器（如 lazy.nvim）来更新插件：

```vim
:Lazy update avante.nvim
```

## 支持

如果遇到问题，可以：
1. 检查 ollama 服务状态
2. 查看日志文件
3. 参考 avante.nvim 官方文档
4. 检查网络连接和防火墙设置
