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

  -- These are some examples, uncomment them if you want to see them work!
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
        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        -- default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- custom mappings
        map("n", "<c-n>", api.tree.toggle, opts "Toggle Tree")
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
  { -- 快速修改变量命名风格
    "chenasraf/text-transform.nvim",
    tag = "stable",
    lazy = false,
    priority = 60,
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    config = function()
      require("text-transform").setup {
        debug = false,
        keymap = {
          telescope_popup = {
            -- Normal mode keymap.
            ["n"] = "<leader>`",
            -- Visual mode keymap.
            ["v"] = "<leader>`",
          },
        },
        popup_type = "telescope",
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "BufEnter",
    lazy = true,
    config = function()
      require("diffview").setup {
        file_panel = {
          win_config = { -- See ':h diffview-config-win_config'
            position = "bottom",
            height = 15,
          },
        },
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
    "ibhagwan/fzf-lua",
    enabled = false,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup {}
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    enabled = false,
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {}
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- optional
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
    enabled = false,
    "aznhe21/actions-preview.nvim",
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
}
