return {
  "nvim-pack/nvim-spectre",
  cmd = { "Spectre" },
  config = function()
    require("spectre").setup {
      mapping = {
        ["send_to_qf"] = {
          map = "<C-q>",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix",
        },
      },
    }
  end,
}
