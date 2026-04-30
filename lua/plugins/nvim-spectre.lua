local utils = require "utils"
local map = vim.keymap.set

-- Spectre keymaps have been moved to lua/keymaps.lua
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
  -- Export functions for keymaps.lua
  extra = {
    open_search_replace = function()
      local utils = require "utils"
      require("spectre").open {
        is_insert_mode = true,
        search_text = utils.get_current_word(),
        is_close = true,
      }
    end,
  },
}
