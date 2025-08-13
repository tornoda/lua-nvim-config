local opt = vim.opt
local o = vim.o
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.toggle_theme_icon = "   "

-------------------------------------- options ------------------------------------------
o.laststatus = 3
o.showmode = false

o.clipboard = "unnamedplus"
-- o.cursorcolumn = true
o.cursorline = true
o.cursorlineopt = "both"

-- Indenting
o.expandtab = true
o.shiftwidth = 2
o.smartindent = true
o.tabstop = 2
o.softtabstop = 2

-- Disable auto change directory
o.autochdir = false

opt.fillchars = { eob = " " }
o.ignorecase = true
o.smartcase = true
o.mouse = "a"

-- Numbers
o.number = true
o.numberwidth = 2
o.ruler = false

-- disable nvim intro
opt.shortmess:append "sI"

o.signcolumn = "yes"
o.splitbelow = true
o.splitright = true
o.timeoutlen = 400
o.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
o.updatetime = 500

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
opt.whichwrap:append "<>[]hl"

-- see https://vim.fandom.com/wiki/Keep_your_cursor_centered_vertically_on_the_screen to become a pro
opt.scrolloff = 4
opt.wrap = false
-- opt.autoindent = false

-- opt.foldminlines = 2
-- opt.foldnestmax = 4

vim.cmd "set fillchars+=diff:╱"

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

-- diff mode colors
vim.api.nvim_set_hl(0, "DiffAdd", { fg = "NONE", bg = "#005f00" })
vim.api.nvim_set_hl(0, "DiffChange", { fg = "NONE", bg = "#005f5f" })
vim.api.nvim_set_hl(0, "DiffDelete", { fg = "NONE", bg = "#5f0000" })
vim.api.nvim_set_hl(0, "DiffText", { fg = "NONE", bg = "#870000" })

-- 性能优化配置
-- 减少交换文件写入频率
o.swapfile = false
o.backup = false
o.writebackup = false

-- 优化搜索性能
o.hlsearch = false
o.incsearch = true
o.lazyredraw = true

-- 优化文件类型检测
o.filetype = "on"
o.syntax = "on"

-- 优化缓冲区性能
o.hidden = true

-- 优化窗口性能
o.lazyredraw = true
o.ttyfast = true

-- 优化终端性能
o.termguicolors = true

-- 减少不必要的功能
o.compatible = false
o.showmatch = false
o.showmode = false
o.ruler = false
o.modeline = false
o.modelines = 0

-- 优化自动完成
o.completeopt = "menu,menuone,noinsert,noselect"
o.pumheight = 10
o.pumblend = 0

-- 优化文件监控
o.autoread = true
o.autowrite = false
o.autowriteall = false

-- 代码修复和格式化相关选项
-- 启用LSP代码操作
o.tagfunc = "v:lua.vim.lsp.tagfunc"
-- 启用LSP格式化
o.formatexpr = "v:lua.vim.lsp.formatexpr()"
-- 启用LSP缩进
o.indentexpr = "v:lua.vim.lsp.indentexpr()"

-- 优化诊断显示
o.updatetime = 500  -- 减少诊断更新频率
o.signcolumn = "yes"  -- 显示诊断标记列
