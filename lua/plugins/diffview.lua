local func = require "func"

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen" },
  config = function()
    require("diffview").setup {
      enhanced_diff_hl = false,
      file_panel = {
        listing_style = "list",
        win_config = { -- See ':h diffview-config-win_config'
          position = "bottom",
          height = 15,
        },
      },
      hooks = {
        view_opened = function()
          func.setColor()
        end,
      },
    }
  end,
}
