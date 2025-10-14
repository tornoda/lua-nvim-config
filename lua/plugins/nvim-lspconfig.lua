local map = vim.keymap.set
local create_cmd = vim.api.nvim_create_user_command

create_cmd("ReloadDiagnostic", function()
  local bufnr = vim.api.nvim_get_current_buf()

  -- 重新加载诊断
  vim.diagnostic.reset(nil, bufnr)
  vim.lsp.buf.clear_references()
  vim.lsp.buf.document_highlight()

  -- 重新启动 Tree-sitter 高亮
  vim.treesitter.stop(bufnr)
  vim.treesitter.start(bufnr)

  print "诊断和 Tree-sitter 已重新加载 🌳✨"
end, {})

local function set_mappings(bufnr)
  bufnr = bufnr or 0
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end
  map("n", "gri", vim.lsp.buf.implementation, opts "Go to implementation")
  map("n", "grr", vim.lsp.buf.references, opts "Show references")
  map("n", "grn", function()
    vim.lsp.buf.rename()
    -- require "nvchad.lsp.renamer"()
  end, opts "NvRenamer")
  map("n", "grd", vim.lsp.buf.type_definition, opts "Go to type definition")
  map("n", "grD", vim.lsp.buf.declaration, opts "Go to declaration")
  map("n", "gre", vim.diagnostic.open_float, opts "Show diagnostics")

  -- map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
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
local servers = {
  "html",
  "cssls",
  "emmet_ls",
  "cssmodules_ls",
  "css_variables",
  "stylelint_lsp",
  -- "eslint", -- ESLint LSP
  "ts_ls", -- TypeScript LSP
}

local function on_attach(_, bufnr)
  set_mappings(bufnr)
end

-- disable semanticTokens
local function on_init(client, _)
  if client.supports_method "textDocument/semanticTokens" then
    client.server_capabilities.semanticTokensProvider = nil
  end

  -- 性能优化：禁用不必要的功能
  -- Note: documentSymbolProvider is needed for symbol navigation
  -- if client.supports_method "textDocument/documentSymbol" then
  --   client.server_capabilities.documentSymbolProvider = nil
  -- end

  if client.supports_method "textDocument/foldingRange" then
    client.server_capabilities.foldingRangeProvider = nil
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

-- for nvim-ufo
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

-- 性能优化：减少诊断频率
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  -- 增加诊断更新间隔
  update_in_insert = false,
  severity_sort = true,
}

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    opts = {},
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
