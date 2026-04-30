return {
  -- Local cursor-agent.nvim plugin
  dir = "~/nvim-plugin/cursor-agent.nvim",
  name = "cursor-agent",
  event = "VeryLazy",
  config = function()
    -- Setup the plugin with default configuration
    require("cursor-agent").setup({
      cmd = "cursor-agent",
      args = { "-f" },
      window_type = "split",
      split_direction = "vertical",
      split_size = 0.35,
    })
  end,
}
