-- Conform keymaps have been moved to lua/keymaps.lua

return {
  "stevearc/conform.nvim",
  -- event = "BufWritePre", -- uncomment for format on save (disabled)
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        scss = { "prettierd" },
      },
      -- format_on_save = {
      --   -- These options will be passed to conform.format()
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      --   lsp_format = "first",
      --   quiet = true,
      -- },
    }
  end,
}
