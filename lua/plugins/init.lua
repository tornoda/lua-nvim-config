local mappings = require "mappings"
local map = vim.keymap.set

return {
  {
    "folke/which-key.nvim",
    -- enabled = false,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    config = function()
      require "configs.conform"
    end,
  },
  {
    "tpope/vim-surround",
    event = "BufEnter", -- 在lazy.vim下这个必需加上
    config = function()
      vim.g.surround_115 = "**\r**" -- 115 is the ASCII code for 's'
      vim.g.surround_47 = "/* \r */" -- 47 is /
    end,
  },

  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
      mappings.gitsigns()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = {
      view = {
        centralize_selection = true,
      },
      renderer = {
        full_name = true,
        icons = {
          show = {
            file = false,
            folder = false,
            git = false,
          },
        },
      },
      on_attach = function(bufnr)
        local api = require "nvim-tree.api"
        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        mappings.nvimtree(bufnr)
      end,
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "Telescope" },
    opts = function()
      return require "configs.telescope"
    end,
    config = function(_, opts)
      local telescope = require "telescope"

      telescope.setup(opts)

      -- load extensions
      for _, ext in ipairs(opts.extensions_list) do
        telescope.load_extension(ext)
      end

      mappings.telescope()
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      preview = {
        type = "main",
        scratch = false,
      },
      focus = true,
      follow = false,
    },
    config = function(_, opts)
      require("trouble").setup(opts)
      mappings.trouble()
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufEnter",
    lazy = true,
    config = function()
      require("diffview").setup {
        enhanced_diff_hl = false,
        file_panel = {
          listing_style = "list",
          win_config = { -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 15,
          },
        },
        -- hooks = {
        --   view_opened = function()
        --   end,
        -- },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "html-lsp",
        "css-lsp",
        "prettier",
      },
    },
  },
  --
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "scss",
        "javascript",
        "typescript",
        "tsx",
      },
    },
  },
  {
    "lewis6991/hover.nvim",
    event = "LspAttach",
    enabled = false,
    config = function()
      require("hover").setup {
        init = function()
          -- Require providers
          require "hover.providers.diagnostic"
          require "hover.providers.lsp"
          -- require('hover.providers.gh')
          -- require('hover.providers.gh_user')
          -- require('hover.providers.jira')
          -- require('hover.providers.dap')
          -- require('hover.providers.fold_preview')
          -- require('hover.providers.man')
          -- require "hover.providers.dictionary"
        end,
        preview_opts = {
          border = "single",
        },
        -- Whether the contents of a currently open hover window should be moved
        -- to a :h preview-window when pressing the hover keymap.
        preview_window = false,
        title = true,
      }

      -- Setup keymaps
      vim.keymap.set("n", "<leader>k", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      vim.keymap.set("n", "<C-p>", function()
        require("hover").hover_switch "previous"
      end, { desc = "hover.nvim (previous source)" })
      vim.keymap.set("n", "<C-n>", function()
        require("hover").hover_switch "next"
      end, { desc = "hover.nvim (next source)" })
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "Bekaboo/dropbar.nvim",
    lazy = false,
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
  },
  {
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
  },
  {
    "aznhe21/actions-preview.nvim",
    enabled = false,
    config = function()
      vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    end,
  },
  {
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup {}
    end,
  },
  {
    "dnlhc/glance.nvim",
    enabled = false,
    config = function()
      require("glance").setup {
        -- your configuration
      }
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup {}
      require("telescope").load_extension "textcase"
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
}
