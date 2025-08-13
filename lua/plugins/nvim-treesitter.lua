return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup {
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
        "luadoc",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
        -- 性能优化：限制高亮行数
        additional_vim_regex_highlighting = false,
      },

      indent = { enable = true },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<space>",
          node_incremental = "<space>",
          scope_incremental = false, -- means disabled
          node_decremental = "<bs>",
        },
      },

      -- 性能优化配置
      playground = {
        enable = false, -- 禁用 playground 功能
      },
      
      query_linter = {
        enable = false, -- 禁用查询检查器
      },

      -- 减少内存使用
      sync_install = false,
      auto_install = false,
    }
  end,
}
