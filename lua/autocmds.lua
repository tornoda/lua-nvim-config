local autocmd = vim.api.nvim_create_autocmd

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

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    local ret = vim.bo.filetype
    if ret ~= "DiffviewFiles" then
      return nil
    end

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
