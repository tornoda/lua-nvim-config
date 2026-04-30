-- Gitsigns keymaps have been moved to lua/keymaps.lua

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    return require "nvchad.configs.gitsigns"
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
  end,
  -- Export functions for keymaps.lua
  extra = {
    next_hunk = function()
      vim.cmd "Gitsigns next_hunk"
    end,
    prev_hunk = function()
      vim.cmd "Gitsigns prev_hunk"
    end,
  },
}
