-- Gitsigns keymaps have been moved to lua/keymaps.lua

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signs_staged = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    current_line_blame = false,
    preview_config = {
      border = "single",
    },
  },
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
