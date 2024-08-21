local mappings = require "mappings"

return {
  "lewis6991/gitsigns.nvim",
  event = "User FilePost",
  opts = function()
    return require "nvchad.configs.gitsigns"
  end,
  config = function(_, opts)
    require("gitsigns").setup(opts)
    mappings.gitsigns()
  end,
}
