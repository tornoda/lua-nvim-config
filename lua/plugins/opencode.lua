return {
  "sudo-tee/opencode.nvim",
  cmd = "Opencode",
  keys = {
    { "<leader>og", "<cmd>Opencode toggle<cr>", mode = { "n", "t" }, desc = "Toggle Opencode" },
  },
  config = function()
    require("opencode").setup({
      preferred_completion = "nvim-cmp",
      ui = {
        position = "float",
        float = {
          width = 0.85,
          height = 0.9,
        },
      },
    })

    local tool_formatters = require "opencode.ui.formatter.tools"
    tool_formatters.skill = {
      format = function(output, part)
        local icons = require "opencode.ui.icons"
        local utils = require "opencode.ui.formatter.utils"
        local input = part.state and part.state.input or {}
        local skill_name = type(input.name) == "string" and input.name or ""

        utils.format_action(output, icons.get "tool", "skill", skill_name, utils.get_duration_text(part))
      end,
      summary = function(_, input)
        local icons = require "opencode.ui.icons"
        input = input or {}
        local skill_name = type(input.name) == "string" and input.name or ""

        return icons.get "tool", "skill", skill_name
      end,
    }
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
