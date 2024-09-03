local mappings = require "mappings"

local map = vim.keymap.set

map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  -- cmd = { "NvimTreeToggle", "NvimTreeFocus" },
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
      -- mappings.nvimtree(bufnr)
    end,
    -- for project.nvim
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}
