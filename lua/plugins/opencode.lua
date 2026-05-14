return {
  "sudo-tee/opencode.nvim",
  lazy = false,
  config = function()
    require("opencode").setup({
      preferred_completion = "nvim-cmp",
    })

    vim.keymap.set({ "n", "t" }, "<leader>og", "<cmd>Opencode toggle<cr>", { desc = "Toggle Opencode" })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'Avante', 'opencode_output', 'codecompanion' },
        heading = {
          sign = false,
          position = "inline",
          icons = { "" },
          width = "block",
          left_margin = 0,
          right_pad = 0,
          backgrounds = {
            "RenderMarkdownH1Bg",
            "RenderMarkdownH2Bg",
            "RenderMarkdownH3Bg",
            "RenderMarkdownH4Bg",
            "RenderMarkdownH5Bg",
            "RenderMarkdownH6Bg",
          },
          border = false,
        },
      },
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output', 'codecompanion' },
    },
    -- Optional, for file mentions and commands completion, pick only one
    -- 'saghen/blink.cmp',
    'hrsh7th/nvim-cmp',

    -- Optional, for file mentions picker, pick only one
    'folke/snacks.nvim',
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim_mini/mini.nvim',
  },
}
