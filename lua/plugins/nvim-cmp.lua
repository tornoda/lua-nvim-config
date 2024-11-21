return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  lazy = false,
  dependencies = {
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)
        require "nvchad.configs.luasnip"
      end,
    },

    -- autopairing of (){}[] etc
    {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "TelescopePrompt", "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },

    -- cmp sources plugins
    {
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "rasulomaroff/cmp-bufname",
      "uga-rosa/cmp-dictionary",
      -- "tzachar/cmp-fuzzy-buffer",
      "hrsh7th/cmp-omni",
      "f3fora/cmp-spell",
      "hrsh7th/cmp-path",
      "ray-x/cmp-treesitter",
    },
  },
  config = function()
    local cmp = require "cmp"

    -- for spell
    vim.opt.spell = true
    vim.opt.spelllang = { "en_us" }

    cmp.setup {
      completion = { completeopt = "menu,menuone" },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),

        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },

        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   elseif require("luasnip").expand_or_jumpable() then
        --     require("luasnip").expand_or_jump()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),

        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --   elseif require("luasnip").jumpable(-1) then
        --     require("luasnip").jump(-1)
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        -- { name = "treesitter" },
        -- {
        --   name = "spell",
        --   option = {
        --     keep_all_entries = false,
        --     enable_in_context = function()
        --       return true
        --     end,
        --     preselect_correct_word = true,
        --   },
        -- },
      },
    }
  end,
}
