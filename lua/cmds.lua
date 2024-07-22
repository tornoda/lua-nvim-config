local create_cmd = vim.api.nvim_create_user_command
local runCmd = vim.api.nvim_command

create_cmd("DF", function()
  runCmd "DiffviewOpen"
end, {})

create_cmd("DC", function()
  runCmd "DiffviewClose"
end, {})
