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
      width = 30,
      sidebar_header = {
        align = "center",
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
        local current = require("avante.llm").get_provider()
        local next_provider = current == "codex" and "opencode" or "codex"
        require("avante.api").switch_provider(next_provider)
        print("Switched to " .. next_provider)
      end,
      desc = "Avante switch provider",
    },
  },
}
