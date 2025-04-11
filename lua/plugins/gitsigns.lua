local function set_mappings()
  local map = vim.keymap.set
  map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>")
  map("n", "]c", "<cmd>Gitsigns next_hunk<CR>")
end

return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  opts = function()
    return require "nvchad.configs.gitsigns"
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
    set_mappings()
  end,
}
