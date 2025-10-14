return {
  "nvimtools/none-ls.nvim",
  ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
  lazy = true,
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require "null-ls"

    -- 检查可用的源
    local sources = {}

    -- 基础功能
    table.insert(sources, null_ls.builtins.code_actions.gitsigns)

    -- ESLint 功能
    local eslint_available = pcall(function()
      return null_ls.builtins.diagnostics.eslint
    end)
    if eslint_available then
      table.insert(sources, null_ls.builtins.diagnostics.eslint)
    end

    local eslint_actions_available = pcall(function()
      return null_ls.builtins.code_actions.eslint
    end)
    if eslint_actions_available then
      table.insert(sources, null_ls.builtins.code_actions.eslint)
    end

    -- Prettier格式化
    local prettier_available = pcall(function()
      return null_ls.builtins.formatting.prettierd.with({
        filetypes = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "vue", "svelte", "astro", "json", "css", "scss", "less", "html"
        },
      })
    end)

    if prettier_available then
      table.insert(sources, null_ls.builtins.formatting.prettierd.with({
        filetypes = {
          "javascript", "javascriptreact", "typescript", "typescriptreact",
          "vue", "svelte", "astro", "json", "css", "scss", "less", "html"
        },
      }))
    end

    -- 过滤掉nil的源并验证
    local valid_sources = {}
    for _, source in ipairs(sources) do
      if source and type(source) == "table" then
        table.insert(valid_sources, source)
      end
    end

    null_ls.setup {
      -- 性能优化
      debounce = 150,
      default_timeout = 5000,
      sources = valid_sources,

      -- 调试信息
      debug = false,
    }

    -- 打印加载的源
    print("✅ none-ls 已加载 " .. #valid_sources .. " 个源")
  end,
}
