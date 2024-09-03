-- EXAMPLE

local map = vim.keymap.set

local function set_mappings(bufnr)
  bufnr = bufnr or 0
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gri", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "grr", vim.lsp.buf.references, opts "Show references")
  map("n", "grn", function()
    require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")
  map("n", "grd", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "grD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gre", vim.diagnostic.open_float, opts "Show diagnostics")

  map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
  map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
  map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

  map("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts "List workspace folders")

  map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action)
  map("n", "[e", vim.diagnostic.goto_prev)
  map("n", "]e", vim.diagnostic.goto_next)
end

local lspconfig = require "lspconfig"
-- 记得装server:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- 直接MasonInstallAll, 就可以把这里的都装上, 还会把mason配置里面的装上
local servers = { "html", "cssls", "tsserver", "emmet_ls", "cssmodules_ls", "css_variables", "eslint" }
local servers_name_in_mason = {
  "html-lsp",
  "css-lsp",
  "typescript-language-server",
  "emmet-language-server",
  "cssmodules-language-server",
  "lua-language-server",
  "stylua",
  "prettier",
  "eslint-lsp",
}

local function on_attach(_, bufnr)
  set_mappings(bufnr)
end

-- disable semanticTokens
local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- vim.diagnostic.config { virtual_text = false }
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false,
})

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {
      ensure_installed = servers_name_in_mason,
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- lsps with default config
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
          on_attach = on_attach,
          on_init = on_init,
          capabilities = capabilities,
        }
      end

      lspconfig.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
        on_init = on_init,

        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                vim.fn.expand "$VIMRUNTIME/lua",
                vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
                vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
                vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
                "${3rd}/luv/library",
              },
              maxPreload = 100000,
              preloadFileSize = 10000,
            },
          },
        },
      }
    end,
  },
}
