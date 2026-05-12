vim.api.nvim_create_user_command("NpmScript", function()
  require("scripts.run_npm_scripts").run_script_select()
end, {})
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
