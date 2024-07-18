local cmd = vim.api.nvim_create_user_command
local runCmd = vim.api.nvim_command
local telescope_builtin = require "telescope.builtin"
local utils = require "utils"

cmd("DF", function()
  runCmd "DiffviewOpen"
end, {})

cmd("DC", function()
  runCmd "DiffviewClose"
end, {})

cmd("SearchLive", telescope_builtin.live_grep, {})

cmd("Search", function(opts)
  local _args = utils.get_split_args(opts.args)

  local conf = {}

  if utils.table_has(_args, "reg") then
    conf.use_regex = true
  end

  print(vim.inspect(conf))

  telescope_builtin.live_grep(conf)
end, { nargs = 1 })
