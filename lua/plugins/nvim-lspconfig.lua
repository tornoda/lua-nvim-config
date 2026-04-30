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

-- LSP keymaps have been moved to lua/keymaps.lua

-- 记得装server:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- 直接MasonInstallAll, 就可以把这里的都装上, 还会把mason配置里面的装上
local servers = {
  -- "html",
  "cssls",
  -- "emmet_ls",
  -- "cssmodules_ls",
  -- "css_variables",
  -- "stylelint_lsp",
  -- "eslint", -- ESLint LSP
  "ts_ls", -- TypeScript LSP
  -- "vtsls"
}

local function on_attach(_, bufnr)
  -- LSP keymaps are now handled in lua/keymaps.lua
end

-- disable semanticTokens
local function on_init(client, _)
  -- if client.supports_method "textDocument/semanticTokens" then
  --   client.server_capabilities.semanticTokensProvider = nil
  -- end

  -- 性能优化：禁用不必要的功能
  -- Note: documentSymbolProvider is needed for symbol navigation
  -- if client.supports_method "textDocument/documentSymbol" then
  --   client.server_capabilities.documentSymbolProvider = nil
  -- end

  -- if client.supports_method "textDocument/foldingRange" then
  --   client.server_capabilities.foldingRangeProvider = nil
  -- end
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
    cmd = "Mason",
    event = "VeryLazy",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local function setup_server(server, opts)
        local base_opts = vim.tbl_deep_extend(
          "force",
          {
            on_attach = on_attach,
            on_init = on_init,
            capabilities = capabilities,
          },
          opts or {}
        )

        if vim.lsp and vim.lsp.config then
          vim.lsp.config(server, base_opts)
          vim.lsp.enable(server)
        else
          -- Fallback for pre-0.11 Neovim (deprecated path)
          require("lspconfig")[server].setup(base_opts)
        end
      end

      for _, lsp in ipairs(servers) do
        if lsp == "ts_ls" then
          setup_server(lsp, {
            init_options = {
              maxTsServerMemory = 1024 * 6, -- 2GB in MB to keep memory usage reasonable
            },
          })
        else
          setup_server(lsp)
        end
      end

      setup_server("lua_ls", {
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
      })
    end,
  },
}
