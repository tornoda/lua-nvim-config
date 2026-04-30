local utils = require "utils"

-- 只在VSCode中加载这些映射
if not utils.isVsCode() then
  return
end

-- 辅助函数
local map = vim.keymap.set
local opts = { silent = true }
local vscode = require "vscode"

map("n", "j", "gj", { noremap = true })
-- 让 <leader>[ 像 ESC 一样退出插入模式
map({ "i", "v", "s", "c", "t", "n" }, "<leader>[", "<Esc>", opts)

map("n", "<leader>ff", '<cmd>call VSCodeNotify("workbench.action.quickOpen")<CR>', opts)
map("n", "<leader>fw", function()
  -- vscode.action "workbench.action.quickTextSearch"
  vscode.action("workbench.action.findInFiles", {
    args = {
      query = utils.get_current_word(),
    },
  })
  -- vscode.action("workbench.action.quickOpen", { prefix = "%" })
end, opts)
map("n", "<leader>fr", '<cmd>call VSCodeNotify("workbench.action.openRecent")<CR>', opts)
map("n", "<leader>fb", '<cmd>call VSCodeNotify("fuzzySearch.activeTextEditor")<CR>', opts)
map("n", "<leader>w", '<cmd>call VSCodeNotify("workbench.action.files.save")<CR>', opts)
-- search in current file
map("n", "<leader>f/", '<cmd>call VSCodeNotify("editor.actions.findWithArgs")<CR>', opts)

-- 在编辑器组间移动
map("n", "<C-h>", '<cmd>call VSCodeNotify("workbench.action.navigateLeft")<CR>', opts)
map("n", "<C-l>", '<cmd>call VSCodeNotify("workbench.action.navigateRight")<CR>', opts)
map("n", "<C-k>", '<cmd>call VSCodeNotify("workbench.action.navigateUp")<CR>', opts)
map("n", "<C-j>", '<cmd>call VSCodeNotify("workbench.action.navigateDown")<CR>', opts)


-- 符号导航
map("n", "<leader>ss", '<cmd>call VSCodeNotify("workbench.action.gotoSymbol")<CR>', opts)
map("n", "<leader>sw", '<cmd>call VSCodeNotify("workbench.action.showAllSymbols")<CR>', opts)
map("n", "gd", '<cmd>call VSCodeNotify("editor.action.revealDefinition")<CR>', opts)
map("n", "gr", '<cmd>call VSCodeNotify("editor.action.goToReferences")<CR>', opts)
map("n", "gi", '<cmd>call VSCodeNotify("editor.action.goToImplementation")<CR>', opts)
map("n", "K", '<cmd>call VSCodeNotify("editor.action.showHover")<CR>', opts)

-- ============================
-- 代码操作 Code Actions
-- ============================
map("n", "<leader>a", '<cmd>call VSCodeNotify("editor.action.quickFix")<CR>', opts)
map("n", "<leader>rn", '<cmd>call VSCodeNotify("editor.action.rename")<CR>', opts)
map("n", "<leader>cf", '<cmd>call VSCodeNotify("editor.action.formatDocument")<CR>', opts)
map("v", "<leader>cf", '<cmd>call VSCodeNotify("editor.action.formatSelection")<CR>', opts)

-- ============================
-- Git 操作 Git Operations
-- ============================
local function git_mapping()
  map("n", "<leader>df", '<cmd>call VSCodeNotify("workbench.view.scm")<CR>', opts)
  map("n", "<leader>gh", '<cmd>call VSCodeNotify("gitlens.showQuickFileHistory")<CR>', opts)
  --  go next hunk
  map("n", "]c", '<cmd>call VSCodeNotify("workbench.action.editor.nextChange")<CR>', opts)
  --  go previous hunk
  map("n", "[c", '<cmd>call VSCodeNotify("workbench.action.editor.previousChange")<CR>', opts)
end

git_mapping()

-- ============================
-- 侧边栏和面板 Sidebar & Panels
-- ============================
map("n", "<leader>e", '<cmd>call VSCodeNotify("workbench.files.action.showActiveFileInExplorer")<CR>', opts)
map("n", "<leader>t", '<cmd>call VSCodeNotify("workbench.action.terminal.toggleTerminal")<CR>', opts)
map("n", "<leader>o", '<cmd>call VSCodeNotify("outline.focus")<CR>', opts)

-- ============================
-- 编辑增强 Enhanced Editing
-- ============================
map("n", "<leader>/", '<cmd>call VSCodeNotify("editor.action.commentLine")<CR>', opts)
map("v", "<leader>/", '<cmd>call VSCodeNotify("editor.action.commentLine")<CR>', opts)
-- Map to VSCode fold commands (overwrite default Neovim mappings)
map("n", "zc", '<cmd>call VSCodeNotify("editor.fold")<CR>', { silent = true, noremap = true })
map("n", "za", '<cmd>call VSCodeNotify("editor.unfold")<CR>', { silent = true, noremap = true })
map("n", "zA", '<cmd>call VSCodeNotify("editor.unfoldAll")<CR>', opts)
map("n", "zM", '<cmd>call VSCodeNotify("editor.foldAll")<CR>', opts)
map("n", "zR", '<cmd>call VSCodeNotify("editor.unfoldAll")<CR>', opts)

-- ============================
-- 命令面板和设置 Command Palette & Settings
-- ============================
map("n", "<leader>p", '<cmd>call VSCodeNotify("workbench.action.showCommands")<CR>', opts)
map("n", "<leader>,", '<cmd>call VSCodeNotify("workbench.action.openSettings")<CR>', opts)
map("n", "<leader>k", '<cmd>call VSCodeNotify("workbench.action.openGlobalKeybindings")<CR>', opts)
