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
    -- Inline blame on the current line (replaces blamer.nvim)
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "   <author>, <author_time:%Y-%m-%d> · <summary>",
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
