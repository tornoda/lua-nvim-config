# which-key 快捷键布局重构完成报告

## 实施总结

已成功完成 which-key 快捷键布局重构，实现了干净、分层、零冲突的快捷键系统。

## 主要变更

### 1. 新建文件
- **`lua/keymaps.lua`** - 统一的快捷键定义文件
- **`test_keymaps.lua`** - 快捷键冲突检测脚本

### 2. 重构文件
- **`lua/plugins/which-key.lua`** - 完整的 which-key 配置和分组
- **`lua/mappings.lua`** - 简化为核心功能映射
- **`lua/init.lua`** - 添加 keymaps.lua 加载

### 3. 更新插件配置
移除了以下文件中的全局 keymap 定义：
- `lua/plugins/telescope.lua`
- `lua/plugins/diffview.lua` 
- `lua/plugins/_trouble.lua`
- `lua/plugins/gitsigns.lua`
- `lua/plugins/nvim-lspconfig.lua`
- `lua/plugins/nvim-spectre.lua`
- `lua/plugins/confirm.lua`
- `lua/cmds.lua`

## 快捷键分组结构

### 主要分组（两级层级）

```
<leader>
├── f - Find/Search (🔍)
│   ├── ff - find files
│   ├── fw - find word (grep)
│   ├── fb - find in buffer
│   ├── fo - find old files
│   ├── fa - find all files
│   ├── fd - find in directory
│   ├── fg - find in git modified
│   ├── fl - find LSP symbols (doc)
│   ├── fs - find LSP symbols (workspace)
│   └── fh - find help
├── g - Git operations ()
│   ├── gs - status
│   ├── gc - commits
│   ├── gb - branches
│   ├── gn - next hunk
│   └── gp - prev hunk
├── d - Diff/Diffview (📊)
│   ├── do - diffview open
│   ├── dc - diffview close
│   ├── dh - diffview history
│   ├── df - diffview file history
│   ├── dg - diffget
│   └── dp - diffput
├── t - Toggle/Terminal/Trouble (🔄)
│   ├── tt - toggle trouble
│   ├── tc - close trouble
│   ├── tf - focus trouble
│   ├── th - terminal horizontal
│   ├── tv - terminal vertical
│   ├── ti - terminal float
│   └── tn - toggle line numbers
├── l - LSP operations ()
│   ├── la - code action (moved from <leader>a)
│   ├── lf - format
│   ├── lr - rename
│   ├── li - implementation
│   ├── ld - definition
│   ├── lt - type definition
│   ├── lD - declaration
│   ├── le - show diagnostics
│   ├── ls - signature help
│   ├── lwa - add workspace folder
│   ├── lwr - remove workspace folder
│   └── lwl - list workspace folders
├── c - Code utilities (💻)
│   ├── cl - console.log
│   ├── cc - jump to context
│   ├── co - open in Cursor (dir)
│   └── cf - open in Cursor (file)
├── w - Window operations (🪟)
├── b - Buffer operations (📄)
├── r - Run/Replace (▶️)
│   └── rs - run npm script
├── j - Jump operations (↗️)
│   └── jl - jumplist
├── m - Marks (📍)
│   └── ma - marks list
├── p - Project/Picker (📁)
│   └── pt - pick terminal
└── Quick actions
    ├── n - toggle line numbers
    ├── rn - toggle relative numbers
    ├── q - quit
    ├── e - file explorer
    ├── / - comment toggle
    ├── * - highlight word
    ├── <leader><leader> - telescope builtin
    ├── 1-6 - tab switching
    ├── wK - whichkey all keymaps
    └── wk - whichkey query lookup
```

## 冲突解决

### 已解决的冲突
1. **`<leader>h`** - terminal horizontal → `<leader>th`
2. **`<leader>w`** - workspace operations → `<leader>lw*`
3. **`<leader>a`** - code action → `<leader>la`
4. **`[c]`/`]c`** - nvim-tree git nav → 保持 buffer-local，不影响全局 gitsigns

### 保留的映射
- 数字键 `<leader>1-6` → tab switching
- Insert mode 快捷移动 `<C-h/j/k/l/b/e>`
- Visual mode 特殊操作
- Alt 键终端切换 `<A-v/h/i>`

## which-key 配置特性

### 现代化配置
- 启用 marks、registers、spelling 插件
- 预设 operators、motions、text_objects 等
- 自定义图标和布局
- 自动触发和黑名单配置

### 分组图标
- 🔍 Find/Search
-  Git operations  
- 📊 Diff/Diffview
- 🔄 Toggle/Terminal/Trouble
-  LSP operations
- 💻 Code utilities
- 🪟 Window operations
- 📄 Buffer operations
- ▶️ Run/Replace
- ↗️ Jump operations
- 📍 Marks
- 📁 Project/Picker

## 测试验证

运行测试脚本验证配置：
```lua
:lua require('test_keymaps')
```

## 使用说明

### 查看所有快捷键
- `<leader>wK` - 显示所有 which-key 快捷键
- `<leader>wk` - 查询特定快捷键

### 常用快捷键保持不变
- `<leader>ff` - 查找文件
- `<leader>w` - 保存所有文件
- `<leader>q` - 退出
- `<leader>/` - 注释切换

### 新增功能快捷键
- `<leader>la` - LSP 代码操作（原 `<leader>a`）
- `<leader>th` - 水平终端（原 `<leader>h`）
- `<leader>lwa/lwr/lwl` - LSP 工作区操作

## 技术实现

### 文件加载顺序
1. `init.lua` - 基础配置
2. `options.lua` - Neovim 选项
3. `mappings.lua` - 核心映射
4. `keymaps.lua` - 统一快捷键（新增）
5. `autocmds.lua` - 自动命令
6. `cmds.lua` - 自定义命令

### 插件集成
- 所有插件的 keymap 定义统一到 `keymaps.lua`
- 插件配置文件只保留 setup 和配置
- which-key 自动检测和显示快捷键

## 优势

1. **零冲突** - 每个快捷键只有一个明确含义
2. **分层清晰** - 按功能分组，易于记忆
3. **向后兼容** - 常用快捷键保持不变
4. **统一管理** - 所有快捷键集中定义
5. **智能提示** - which-key 提供实时帮助
6. **易于扩展** - 新功能可轻松添加到对应分组

## 后续维护

- 新增快捷键时，请添加到 `lua/keymaps.lua` 对应分组
- 同时更新 `lua/plugins/which-key.lua` 中的描述
- 运行测试脚本验证无冲突
- 保持分组逻辑的一致性

重构完成！🎉
