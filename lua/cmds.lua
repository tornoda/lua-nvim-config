local create_cmd = vim.api.nvim_create_user_command
local runCmd = vim.api.nvim_command
local telescope_builtin = require "telescope.builtin"
local utils = require "utils"

create_cmd("DF", function()
  runCmd "DiffviewOpen"
end, {})

create_cmd("DC", function()
  runCmd "DiffviewClose"
end, {})

create_cmd("DCA", function()
  local buffers = vim.api.nvim_list_bufs()
  for index, bufnr in ipairs(buffers) do
    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

    if string.find(filetype, "Diffview") ~= nil then
      vim.api.nvim_buf_delete(bufnr, { force = true })
      utils.log(filetype)
    end
  end
end, {})

create_cmd("SearchLive", telescope_builtin.live_grep, {})

create_cmd("Search", function(opts)
  local _args = utils.get_split_args(opts.args)

  local conf = {}

  if utils.table_has(_args, "reg") then
    conf.use_regex = true
  end

  print(vim.inspect(conf))

  telescope_builtin.live_grep(conf)
end, { nargs = 1 })
