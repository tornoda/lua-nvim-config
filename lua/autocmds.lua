local autocmd = vim.api.nvim_create_autocmd
local utils = require "utils"

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

-- autocmd("User NvChadThemeReload", {
--   callback = function()
--     setDiffColors()
--   end,
-- })

-- vim.api.nvim_create_autocmd("QuickFixCmdPost", {
--   callback = function()
--     vim.cmd([[Trouble qflist open]])
--   end,
-- })
autocmd("BufWinEnter", {
  pattern = "quickfix",
  -- https://github.com/folke/trouble.nvim/issues/70
  callback = function()
    local buftype = "quickfix"
    if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
      buftype = "loclist"
    end

    local ok, trouble = pcall(require, "trouble")
    -- local ok, telescope_builtin = pcall(require, "telescope.builtin")
    if ok then
      vim.defer_fn(function()
        vim.cmd "cclose"
        -- telescope_builtin.quickfix()

        trouble.open(buftype)
        trouble.focus()
      end, 0)
    else
      local set = vim.opt_local
      set.colorcolumn = ""
      set.number = false
      set.relativenumber = false
      set.signcolumn = "no"
    end
  end,
})

-- NvimTree
-- autocmd('BufEnter', {
--   pattern = "NvimTree",
--   callback = function()
--     print('h')
--     vim.api.nvim_create_user_command('Search_under_dir', function()
--       print('hello')
--     end, {})
--   end
-- })
--https://github.com/NvChad/extensions/pull/35

--  global function
--  `:lua SetColors()` to call
function SetColors()
  -- package.loaded['chadrc'] = nil
  -- local themeName = vim.g.nvchad_theme
  local themeName = require("chadrc").ui.theme or ""

  if string.find(themeName, "light") ~= nil then
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#d7eed8", fg = nil })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#ffbebe" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#a6daa9", fg = nil })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#def1df", fg = nil })
  else
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#295337", fg = nil })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "brown", fg = "brown" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#157d38", fg = nil })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#295337" })
  end

  vim.cmd "set fillchars+=diff:╱"
  -- require("gitsigns").refresh()
  -- print(
  --   ("A new %s was opened on tab page %d!")
  --     :format(view.class:name(), view.tabpage)
  -- )
  -- require("base46").load_all_highlights()
end

function SetColor2()
  local diff_add = (utils.get_color("DiffAdd", "fg#"))
  local diff_text = (utils.get_color("DiffText", "fg#"))
  local diff_delete = (utils.get_color("DiffDelete", "fg#"))
  local diff_change = (utils.get_color("DiffChange", "fg#"))
  print(diff_add)

  vim.api.nvim_set_hl(0, "DiffAdd", { bg = diff_add, fg = nil })
  vim.api.nvim_set_hl(0, "DiffDelete", { bg = diff_delete, fg = nil })
  vim.api.nvim_set_hl(0, "DiffChange", { bg = diff_change, fg = nil })
end

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    local ret = vim.bo.filetype
    if ret ~= "DiffviewFiles" then
      return nil
    end

    -- SetColor2()
    SetColors()
  end,
})

-- autocmd('CursorHold',
--   {
--     callback = function()
--       print('CursorHold')
--     end
--   }
-- )
