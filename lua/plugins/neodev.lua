-- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
return {
  lazy = false,
  "folke/neodev.nvim",
  config = function()
    require("neodev").setup {
      library = { plugins = { "nvim-dap-ui" }, types = true },
    }
  end,
}
