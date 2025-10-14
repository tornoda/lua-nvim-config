return {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
  opts = {
    -- 配置代码操作预览
    telescope = {
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          width = 0.8,
          height = 0.8,
          preview_width = 0.5,
        },
      },
    },
  },
  keys = {
    {
      "<leader>ca",
      function()
        require("actions-preview").code_actions()
      end,
      mode = { "n", "v" },
      desc = "code actions preview",
    },
  },
}
