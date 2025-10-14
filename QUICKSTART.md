# Avante.nvim 快速启动指南

## 🚀 立即开始

### 1. 检查依赖项
确保以下依赖项已安装：
- plenary.nvim
- telescope.nvim  
- nvim-treesitter
- nvim-tree
- nvim-lspconfig
- mason.nvim

### 2. 重启 Neovim
配置完成后，重启 Neovim 以加载新插件：
```bash
nvim
```

### 2. 等待插件安装
首次启动时，lazy.nvim 会自动下载和安装 avante.nvim 插件。

### 3. 测试基本功能

#### 打开聊天窗口
```
<leader>ac
```
- 按 `;` 然后按 `ac`（因为你的 leader 键是 `;`）

#### 规划模式
```
<leader>ap
```
- 与 AI 一起规划项目结构和功能

#### 编辑模式
```
<leader>ae
```
- 在编辑模式下与 AI 协作编写代码

#### 建议模式
```
<leader>as
```
- 获取 AI 的建议和推荐

### 4. 测试代码操作

#### 解释代码
1. 选中要解释的代码
2. 按 `<leader>ae`

#### 优化代码
1. 选中要优化的代码
2. 按 `<leader>ao`

#### 重构代码
1. 选中要重构的代码
2. 按 `<leader>ar`

## 🔧 故障排除

### 插件未加载
检查 `:Lazy` 中是否有错误信息

### 依赖项问题
确保所有必需的依赖项已安装：
```bash
:Lazy sync
```

### 连接失败
确保 ollama 服务运行：
```bash
ollama serve
```

### API 密钥问题
如果提示输入 ANTHROPIC_API_KEY 或其他 API 密钥：
1. 确保配置中已禁用其他提供者
2. 检查 `default_provider = "ollama"` 设置
3. 重启 Neovim 让配置生效

### 模型不存在
检查可用模型：
```bash
ollama list
```

## 📚 下一步

- 阅读完整文档：`AVANTE_README.md`
- 自定义配置：编辑 `lua/plugins/avante.lua`
- 测试不同模型：修改配置中的 `model` 字段

## 💡 使用技巧

1. **聊天窗口**: 使用 `<C-h/j/k/l>` 在窗口间导航
2. **代码选择**: 在可视模式下选择代码后使用快捷键
3. **历史记录**: 聊天历史会自动保存
4. **流式响应**: 启用流式响应获得更好的交互体验

## 🎯 推荐工作流

1. 使用 `<leader>ap` 进行项目规划
2. 使用 `<leader>ae` 在编辑模式下协作编码
3. 使用 `<leader>as` 获取 AI 建议
4. 使用 `<leader>ar` 进行代码审查
5. 使用 `<leader>ac` 进行日常对话和问答

## 💡 使用建议

- 使用 `phi3:mini` 模型进行各种编程和对话任务
- **规划模式** (`<leader>ap`): 适合项目初始化和架构设计
- **编辑模式** (`<leader>ae`): 适合日常编码和代码协作
- **建议模式** (`<leader>as`): 适合获取代码改进建议
- **审查模式** (`<leader>ar`): 适合代码审查和问题诊断
- 聊天历史会自动保存，方便后续参考
- 使用文件选择器 (`<leader>a+/-`) 管理要分析的文件
