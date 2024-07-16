require "nvchad.options"

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!

-- vim.opt.signcolumn = "number"
vim.opt.scrolloff = 2
vim.opt.wrap = false
vim.opt.autoindent = false
-- vim.diagnostic.config { virtual_text = false }
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false
    }
)

--https://github.com/NvChad/extensions/pull/35
local function setDiffColors()
  -- local themeName = vim.g.nvchad_theme
  local themeName = require("chadrc").ui.theme

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

setDiffColors()
