-- EXAMPLE
-- local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local mappings = dofile(vim.fn.stdpath "config" .. "/lua/mappings.lua")

local lspconfig = require "lspconfig"
-- 记得装server:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- 直接MasonInstallAll, 就可以把这里的都装上, 还会把mason配置里面的装上
local servers = { "html", "cssls", "tsserver", "emmet_ls", "cssmodules_ls", "css_variables", "eslint" }

return {
  "neovim/nvim-lspconfig",
  config = function()
    require("nvchad.configs.lspconfig").defaults()
    -- lsps with default config
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = function(_, bufnr)
          mappings.lsp(bufnr)
        end,
        on_init = on_init,
        capabilities = capabilities,
      }
    end
  end,
}
