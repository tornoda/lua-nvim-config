-- filename with a _ prefix in order to making trouble open in telescope works
-- because Lazy.nvim loads pluigns one by one from top to bottom
local mappings = require "mappings"

return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    -- pinned = true,
    auto_jump = true,
    preview = {
      type = "main",
      scratch = false,
    },
    focus = true,
    follow = false,
  },
  config = function(_, opts)
    require("trouble").setup(opts)
    mappings.trouble()
  end,
}
