local utils = require "utils"
local map = vim.keymap.set

map("n", "gF", function()
  require("spectre").open {
    is_insert_mode = true,
    -- the directory where the search tool will be started in
    -- cwd = "~/.config/nvim",
    search_text = utils.get_current_word(),
    -- replace_text = "test",
    -- the pattern of files to consider for searching
    -- path = "lua/**/*.lua",
    -- the directories or files to search in
    -- search_paths = { "lua/", "plugin/" },
    is_close = true, -- close an exists instance of spectre and open new
  }
end)
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
