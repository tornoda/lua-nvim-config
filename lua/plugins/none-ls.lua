return {
  "nvimtools/none-ls.nvim",
  event = "BufEnter",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        -- null_ls.builtins.formatting.stylua,
        -- null_ls.builtins.completion.spell,
        null_ls.builtins.code_actions.gitsigns,
        require "none-ls.diagnostics.eslint",
      },
    }
  end,
}
