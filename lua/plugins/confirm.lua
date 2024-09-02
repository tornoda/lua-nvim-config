local function set_mapping()
  local map = vim.keymap.set
  map("n", "<leader>fm", function()
    require("conform").format { lsp_fallback = true }
  end, { desc = "format files" })
end

return {
  "stevearc/conform.nvim",
  event = "BufWritePre", -- uncomment for format on save
  config = function()
    require("conform").setup {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_fallback = true,
        lsp_format = "first",
        quiet = true,
      },
    }

    set_mapping()
  end,
}
