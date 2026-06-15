return {
  "z4p5a9/blamer.nvim",
  lazy = false,
  init = function()
    vim.g.blamer_enabled = true
    vim.g.blamer_delay = 500
    vim.g.blamer_show_in_insert_modes = false
    vim.g.blamer_show_in_visual_modes = false
    vim.g.blamer_prefix = "  "
  end,
}
