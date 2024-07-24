require "nvchad.options"

-- text

-- add yours here!

local o = vim.o
o.cursorlineopt = "both" -- to enable cursorline!

vim.opt.scrolloff = 2
vim.opt.wrap = false
vim.opt.autoindent = false
-- vim.diagnostic.config { virtual_text = false }
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

vim.api.nvim_set_hl(0, "TelescopePreviewLine", { underline = true, bold = true })
