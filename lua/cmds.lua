vim.api.nvim_create_user_command("NpmScript", function()
  require("scripts.run_npm_scripts").run_script_select()
end, {})

-- 创建自定义命令
vim.api.nvim_create_user_command("Code", function(opts)
  local args = opts.fargs
  local cwd = vim.fn.getcwd()

  if #args == 0 then
    -- Code: 打开当前工作目录
    vim.fn.system('code "' .. cwd .. '"')
    print("🎯 在 Cursor 中打开工作目录: " .. cwd)
  elseif args[1] == "%" then
    -- Code %: 打开当前文件并跳转到对应行列号
    local current_file = vim.fn.expand "%:p" -- 获取当前文件的完整路径
    if current_file ~= "" then
      local line = vim.fn.line "." -- 获取当前行号
      local col = vim.fn.col "." -- 获取当前列号
      vim.fn.system('code --goto "' .. current_file .. ':' .. line .. ':' .. col .. '"')
      print("📄 在 Cursor 中打开文件: " .. current_file .. " (行:" .. line .. ", 列:" .. col .. ")")
    else
      print "❌ 错误: 没有当前文件"
    end
  else
    -- Code <其他参数>: 打开指定文件或目录
    local target = args[1]
    vim.fn.system('code "' .. target .. '"')
    print("🔧 在 Cursor 中打开: " .. target)
  end
end, {
  nargs = "*", -- 接受任意数量的参数
  complete = function()
    return { "%" } -- 自动补全建议
  end,
  desc = "在 Cursor 中打开工作目录或文件",
})

-- 可选：设置快捷键映射
vim.keymap.set("n", "<leader>co", ":Code<CR>", { desc = "在 Cursor 中打开工作目录" })
vim.keymap.set("n", "<leader>cf", ":Code %<CR>", { desc = "在 Cursor 中打开当前文件" })
