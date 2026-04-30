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
      local line = vim.fn.line "."           -- 获取当前行号
      local col = vim.fn.col "."             -- 获取当前列号
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
  nargs = "*",     -- 接受任意数量的参数
  complete = function()
    return { "%" } -- 自动补全建议
  end,
  desc = "在 Cursor 中打开工作目录或文件",
})

-- Copy file path using nvim-tree API
vim.api.nvim_create_user_command("CopyPath", function(opts)
  local api = require "nvim-tree.api"
  local view = require "nvim-tree.view"

  local file_path = nil

  -- Try to get node from nvim-tree if it's visible
  if view.is_visible() then
    local node = api.tree.get_node_under_cursor()
    if node and node.absolute_path then
      file_path = node.absolute_path
    end
  end

  -- Fallback to current file path if not in nvim-tree or node not found
  if not file_path then
    local current_file = vim.fn.expand "%:p"
    if current_file ~= "" then
      file_path = current_file
    end
  end

  if file_path then
    -- Convert to project-relative path
    local relative_path = vim.fn.fnamemodify(file_path, ":.")
    -- Append line range in visual mode
    if opts.range > 0 then
      relative_path = relative_path .. ":" .. opts.line1 .. "-" .. opts.line2
    end
    -- Copy to system clipboard (both + and * registers for cross-platform compatibility)
    vim.fn.setreg("+", relative_path)
    vim.fn.setreg("*", relative_path)
    vim.notify("Copied path: " .. relative_path, vim.log.levels.INFO)
  else
    vim.notify("Error: Could not get file path", vim.log.levels.ERROR)
  end
end, {
  range = true,
  desc = "Copy project-relative file path (with line range in visual mode)",
})

-- Custom commands - keymaps have been moved to lua/keymaps.lua
