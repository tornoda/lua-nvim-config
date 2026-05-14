local provider_cycle = { "codex", "opencode" }

return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false,
  build = "make",
  opts = {
    provider = "codex",
    acp_providers = {
      codex = {
        command = "npx",
        args = { "-y", "@zed-industries/codex-acp" },
        env = {
          HOME = os.getenv("HOME"),
          NODE_NO_WARNINGS = "1",
        },
      },
      opencode = {
        command = "opencode",
        args = { "acp", "--cwd", os.getenv("HOME") .. "/.config/nvim" },
        env = {
          OPENCODE_CONFIG_DIR = os.getenv("HOME") .. "/.config/opencode",
        },
      },
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = true,
    },
    input = {
      provider = "snacks",
    },
    windows = {
      position = "right",
      wrap = true,
      width = 35,
      sidebar_header = {
        align = "left",
        rounded = true,
      },
    },
    diff = {
      autojump = true,
      list_opener = "copen",
    },
    hints = { enabled = true },
  },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "folke/snacks.nvim",
    {
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true,
        },
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function()
        require("avante.api").ask()
      end,
      desc = "Avante ask",
      mode = { "n", "v" },
    },
    {
      "<leader>ar",
      function()
        require("avante.api").refresh()
      end,
      desc = "Avante refresh",
    },
    {
      "<leader>ae",
      function()
        require("avante.api").edit()
      end,
      desc = "Avante edit",
      mode = "v",
    },
    {
      "<leader>at",
      function()
        require("avante.api").toggle()
      end,
      desc = "Avante toggle",
    },
    {
      "<leader>ap",
      function()
        -- Read the live provider from avante.config (avante.llm has no
        -- get_provider helper — that was the bug in the previous setup).
        local current = require("avante.config").provider
        local next_provider = provider_cycle[1]
        for i, name in ipairs(provider_cycle) do
          if name == current then
            next_provider = provider_cycle[(i % #provider_cycle) + 1]
            break
          end
        end
        require("avante.api").switch_provider(next_provider)
        vim.notify("Avante provider: " .. next_provider, vim.log.levels.INFO)
      end,
      desc = "Avante cycle provider",
    },
    -- ACP model / mode pickers.
    { "<leader>am", "<cmd>AvanteACPModels<cr>", desc = "Avante ACP model" },
    { "<leader>aM", "<cmd>AvanteACPModes<cr>",  desc = "Avante ACP mode (plan/ask)" },
    -- Start a fresh chat — equivalent to codecompanion's <leader>cc
    { "<leader>an", "<cmd>AvanteChatNew<cr>",   desc = "Avante new chat" },
  },
}
