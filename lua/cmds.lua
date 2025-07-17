vim.api.nvim_create_user_command("NpmScript", function()
  require("scripts.run_npm_scripts").run_script_select()
end, {})
