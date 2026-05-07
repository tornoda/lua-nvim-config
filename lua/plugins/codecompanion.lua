return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    -- Adapter configuration
    -- Default uses GitHub Copilot (requires copilot.vim or copilot.lua)
    -- Uncomment and configure other adapters as needed:
    adapters = {
      -- Example: Anthropic Claude
      -- anthropic = function()
      --   return require("codecompanion.adapters").extend("anthropic", {
      --     env = {
      --       api_key = os.getenv("ANTHROPIC_API_KEY"),
      --     },
      --   })
      -- end,
      -- Example: OpenAI
      -- openai = function()
      --   return require("codecompanion.adapters").extend("openai", {
      --     env = {
      --       api_key = os.getenv("OPENAI_API_KEY"),
      --     },
      --   })
      -- end,
      -- Example: Ollama (local LLM)
      -- ollama = function()
      --   return require("codecompanion.adapters").extend("ollama", {
      --     schema = {
      --       model = {
      --         default = "llama3.2:latest",
      --       },
      --     },
      --   })
      -- end,
    },
    -- Interactions configuration
    interactions = {
      chat = {
        adapter = "copilot",
      },
      inline = {
        adapter = "copilot",
      },
      cmd = {
        adapter = "copilot",
      },
      background = {
        adapter = "copilot",
      },
    },
    -- Display settings
    display = {
      action_palette = {
        provider = "telescope",
      },
      chat = {
        window = {
          layout = "vertical",
          position = "right",
          width = 0.35,
          height = 0.8,
        },
      },
      diff = {
        enabled = true,
        close_chat_at = 240,
      },
    },
    -- General options
    opts = {
      log_level = "ERROR",
      send_code = true,
      use_default_actions = true,
      use_default_prompts = true,
    },
  },
  config = function(_, opts)
    require("codecompanion").setup(opts)
  end,
  keys = {
    {
      "<leader>cc",
      "<cmd>CodeCompanionChat<cr>",
      desc = "CodeCompanion Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ct",
      "<cmd>CodeCompanionChat Toggle<cr>",
      desc = "CodeCompanion Toggle Chat",
      mode = { "n", "v" },
    },
    {
      "<leader>ca",
      "<cmd>CodeCompanionActions<cr>",
      desc = "CodeCompanion Actions",
      mode = { "n", "v" },
    },
    {
      "<leader>ci",
      "<cmd>CodeCompanion<cr>",
      desc = "CodeCompanion Inline",
      mode = { "n", "v" },
    },
    {
      "<leader>cA",
      "<cmd>CodeCompanionChat Add<cr>",
      desc = "CodeCompanion Add to Chat",
      mode = "v",
    },
  },
}
