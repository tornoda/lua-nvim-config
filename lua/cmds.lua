local cmd = vim.api.nvim_create_user_command
local runCmd = vim.api.nvim_command

cmd('DF', function()
  runCmd('DiffviewOpen')
end, {})

cmd('DC', function()
  runCmd('DiffviewClose')
end, {})
