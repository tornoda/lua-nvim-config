return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    {
      -- snippet plugin
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      dependencies = "rafamadriz/friendly-snippets",
      opts = { history = true, updateevents = "TextChanged,TextChangedI" },
      config = function(_, opts)
        require("luasnip").config.set_config(opts)
        -- vscode format
        require("luasnip.loaders.from_vscode").lazy_load { exclude = vim.g.vscode_snippets_exclude or {} }
        require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }

        -- snipmate format
        -- require("luasnip.loaders.from_snipmate").load()
        -- require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

        -- lua format
        -- require("luasnip.loaders.from_lua").load()
        -- require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }
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
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-path",
      "ray-x/cmp-treesitter",
      -- "lukas-reineke/cmp-rg",
    },
  },
  config = function()
    local cmp = require "cmp"

    local function get_bufnrs_by_filetype(filetypes)
      local filetype_set = {}
      for _, filetype in ipairs(filetypes) do
        filetype_set[filetype] = true
      end

      local bufnrs = {}

      for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(bufnr) then
          local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
          if filetype_set[ft] then
            table.insert(bufnrs, bufnr)
          end
        end
      end

      return bufnrs
    end

    local function get_opencode_output_bufnrs()
      return get_bufnrs_by_filetype({ "opencode_output" })
    end

    local function get_existing_dictionary_paths()
      local candidate_paths = {
        vim.fn.stdpath("data") .. "/lazy/cmp-dictionary/data/words",
        "/usr/share/dict/words",
      }
      local paths = {}

      for _, path in ipairs(candidate_paths) do
        if vim.fn.filereadable(path) == 1 then
          table.insert(paths, path)
        end
      end

      return paths
    end

    local source_tags = {
      buffer = "[OUTPUT]",
      dictionary = "[WORD]",
      nvim_lsp = "[LSP]",
      path = "[PATH]",
      luasnip = "[SNIP]",
    }

    local function format_opencode_completion(entry, vim_item)
      vim_item.kind = ""
      vim_item.menu = source_tags[entry.source.name] or ("[" .. entry.source.name .. "]")
      return vim_item
    end

    local ok_dictionary, cmp_dictionary = pcall(require, "cmp_dictionary")
    if ok_dictionary then
      cmp_dictionary.setup({
        paths = get_existing_dictionary_paths(),
        exact_length = 2,
        first_case_insensitive = true,
      })
    end

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

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },

      sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
        -- { name = "rg" },
      },
    }

    cmp.setup.filetype({ "opencode", "opencode_output" }, {
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "path" },
        {
          name = "dictionary",
          keyword_length = 2,
        },
        {
          name = "buffer",
          keyword_length = 2,
          option = {
            get_bufnrs = get_opencode_output_bufnrs,
          },
        },
      }, {
        { name = "luasnip" },
      }),
      formatting = {
        format = format_opencode_completion,
      },
    })
  end,
}
