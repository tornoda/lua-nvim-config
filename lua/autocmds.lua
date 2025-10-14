local autocmd = vim.api.nvim_create_autocmd
local utils = require "utils"

-- respect: https://github.com/github-naresh/auto-fold-imports.nvim/blob/main/lua/auto-fold-imports/init.lua
autocmd({ "BufRead", "BufNewFile" }, {
  callback = function()
    local ok, ufo = pcall(require, "ufo")
    if ok then
      ufo.closeAllFolds()
    end
  end,
})

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    local cur_type = vim.bo.filetype
    local filetypes = { "typescript", "typescriptreact", "react", "css", "sass", "scss", "lua" }

    local has_filetype = false
    for i = 0, #filetypes do
      if filetypes[i] == cur_type then
        has_filetype = true
      end
    end

    if has_filetype then
      vim.opt_local.foldmethod = "indent"
    end
  end,
})
-- autocmd("BufWinEnter", {
--   pattern = "quickfix",
--   -- https://github.com/folke/trouble.nvim/issues/70
--   callback = function()
--     local buftype = "quickfix"
--     if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
--       buftype = "loclist"
--     end
--
--     local ok, trouble = pcall(require, "trouble")
--     -- local ok, telescope_builtin = pcall(require, "telescope.builtin")
--     if ok then
--       vim.defer_fn(function()
--         vim.cmd "cclose"
--         -- telescope_builtin.quickfix()
--
--         trouble.open(buftype)
--         trouble.focus()
--       end, 0)
--     else
--       local set = vim.opt_local
--       set.colorcolumn = ""
--       set.number = false
--       set.relativenumber = false
--       set.signcolumn = "no"
--     end
--   end,
-- })

-- autocmd({ "FileType", "BufWinEnter", "BufEnter" }, {
--   callback = function()
--     local ret = vim.bo.filetype
--     if string.find(ret, "Diffview") ~= nil then
--       func.setColor()
--     end
--   end,
-- })

-- autocmd({ "BufEnter", "BufLeave" }, {
--   callback = function()
--     local is_trouble_open = require("trouble").is_open()
--     local filetype = vim.bo.filetype
--
--     if is_trouble_open and filetype == "trouble" then
--       -- vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bold = true, reverse = true })
--       vim.api.nvim_set_hl(0, "CursorLine", { link = "DiffChange" })
--     else
--       vim.api.nvim_set_hl(0, "CursorLine", { underline = false, bold = false, reverse = false })
--     end
--   end,
-- })

autocmd("BufHidden", {
  callback = function()
    local is_trouble_open = require("trouble").is_open()
  end,
})

autocmd("CursorHold", {
  callback = function()
    local function set_underline()
      -- vim.api.nvim_command "Gitsigns blame_line"
      local curWord = utils.get_current_word()
      local cmd_str = "match Underlined /\\<" .. curWord .. "\\>/"
      vim.api.nvim_command(cmd_str)
    end

    -- vim.defer_fn(set_underline, 0)
  end,
})

-- 当你聚焦回到 Neovim 时（比如从外部编辑器或 git checkout 后切换回 Neovim），它会尝试重新加载被外部修改的文件。
vim.o.autoread = true
autocmd({ "FocusGained", "BufEnter" }, {
  pattern = "*",
  command = "checktime",
})


vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    vim.opt.cursorline = true
  end,
})

-- vim.api.nvim_create_autocmd("WinLeave", {
--   callback = function()
--     vim.opt.cursorline = false
--   end,
-- })

-- 自动格式化配置
-- 保存时自动修复ESLint问题
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.vue", "*.svelte", "*.astro" },
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local clients = vim.lsp.get_clients({ bufnr = bufnr })
--     if #clients > 0 then
--       vim.lsp.buf.format({ async = false })
--     end
--   end,
-- })

-- 添加代码修复命令
vim.api.nvim_create_user_command("FixAll", function()
  local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

  -- 首先尝试使用null-ls的代码修复
  local null_ls_available = false
  for _, client in ipairs(clients) do
    if client.name == "null-ls" then
      null_ls_available = true
      break
    end
  end

  if null_ls_available then
    -- 使用null-ls的代码修复，尝试多种修复源
    local fix_sources = {
      "source.fixAll.eslint_d", -- 优先尝试 eslint_d
      "source.fixAll.eslint",   -- 然后尝试标准 eslint
      "source.fixAll"           -- 最后尝试通用修复
    }
    local fix_success = false
    local used_source = ""

    for _, source in ipairs(fix_sources) do
      local success, result = pcall(vim.lsp.buf.code_action, {
        context = { only = { source } },
        apply = true
      })

      if success then
        used_source = source
        fix_success = true
        break
      end
    end

    if fix_success then
      print("✅ 使用 " .. used_source .. " 修复成功")
      -- 等待一下让修复完成
      vim.defer_fn(function()
        -- 然后格式化代码
        vim.lsp.buf.format({ async = false })
        print("✨ 已修复所有可修复的问题并格式化代码")
      end, 100)
    else
      print("⚠️  所有代码修复方法都失败了，尝试直接格式化")
      vim.lsp.buf.format({ async = false })
    end
  else
    -- 如果没有null-ls，直接格式化
    vim.lsp.buf.format({ async = false })
    print("✨ 已格式化代码")
  end
end, {})

-- 添加Prettier格式化命令
vim.api.nvim_create_user_command("PrettierFormat", function()
  vim.lsp.buf.format({ async = false })
  print("💅 已使用Prettier格式化代码")
end, {})




local ollama = require("ollama_completion")

-- 补全当前选中的内容
function OllamaCompleteVisual()
    local start_pos = vim.fn.getpos("'<")
    local end_pos = vim.fn.getpos("'>")
    local lines = vim.fn.getline(start_pos[2], end_pos[2])
    local prompt = table.concat(lines, "\n")
    local completion = ollama.complete(prompt)
    if completion then
        vim.api.nvim_put({completion}, "l", true, true)
    else
        print("Ollama 补全失败")
    end
end

-- 你可以映射到快捷键
vim.api.nvim_set_keymap("v", "<leader>o", ":lua OllamaCompleteVisual()<CR>", { noremap = true, silent = true })
