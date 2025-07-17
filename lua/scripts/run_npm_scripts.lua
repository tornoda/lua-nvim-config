local M = {}

-- 尝试寻找最近的 package.json（从当前工作目录向上）
local function find_package_json()
  local cwd = vim.fn.getcwd()
  local path = cwd .. "/package.json"
  if vim.fn.filereadable(path) == 1 then
    return path
  else
    print("No package.json found in workspace root: " .. cwd)
    return nil
  end
end

function M.run_script_select()
  local file = find_package_json()
  if not file then
    return
  end

  local json_content = vim.fn.readfile(file)
  local json_string = table.concat(json_content, "\n")
  local ok, parsed = pcall(vim.fn.json_decode, json_string)
  if not ok or not parsed.scripts then
    print "Failed to parse scripts from package.json"
    return
  end

  local scripts = parsed.scripts
  local entries = {}
  local lookup = {}

  for name, cmd in pairs(scripts) do
    local display = string.format("%-15s → %s", name, cmd)
    table.insert(entries, display)
    lookup[display] = name -- 反查原始脚本名
  end

  table.sort(entries)

  vim.ui.select(entries, {
    prompt = "Select an npm script to run:",
  }, function(choice)
    if choice then
      local script_name = lookup[choice]
      local cmd = "npm run " .. script_name
      print("Running: " .. cmd)
      vim.cmd("split | terminal cd " .. vim.fn.getcwd() .. " && " .. cmd)
      -- 强制 terminal 滚动到底部
      vim.schedule(function()
        vim.cmd "normal! G"
      end)
    end
  end)
end

return M
