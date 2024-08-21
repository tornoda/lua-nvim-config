local mappings = require "mappings"

return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  opts = {
    view = {
      centralize_selection = true,
    },
    renderer = {
      full_name = true,
      icons = {
        show = {
          file = false,
          folder = false,
          git = false,
        },
      },
    },
    on_attach = function(bufnr)
      local api = require "nvim-tree.api"
      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      mappings.nvimtree(bufnr)
    end,
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
