local func = require "func"

-- Diffview keymaps have been moved to lua/keymaps.lua

local function set_autocmd()
  local create_cmd = vim.api.nvim_create_user_command
  local runCmd = vim.api.nvim_command
  create_cmd("DF", function()
    runCmd "DiffviewOpen"
  end, {})

  create_cmd("DC", function()
    runCmd "DiffviewClose"
  end, {})
end

-- 存储原始的 TelescopePreviewLine 高亮信息
local original_hl = {}

-- 获取高亮组信息
local function get_hl(group)
  local hl_info = vim.api.nvim_get_hl(0, { name = group })
  return hl_info
end

-- 自定义 preview line 样式
local function set_custom_preview_line()
  -- 示例：使用 CursorLine 的背景颜色作为 preview line 的背景
  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = vim.api.nvim_get_hl(0, { name = "Search" }).ctermbg,
    bold = true,
    italic = true,
  })
end

-- 恢复原始样式
local function restore_preview_line()
  vim.api.nvim_set_hl(0, "CursorLine", original_hl)
end

-- 是否已注册 color_scheme 回调
local color_scheme_attached = false

-- 控制是否启用 custom preview line
local enable_custom_hl = false

local function refresh_view(view)
  local ok_diff, DiffView = pcall(require, "diffview.scene.views.diff.diff_view")
  local ok_history, FileHistoryView = pcall(require, "diffview.scene.views.file_history.file_history_view")

  if ok_diff and view:instanceof(DiffView.DiffView) then
    vim.schedule(function()
      view:update_files()
    end)
    return
  end

  if ok_history and view:instanceof(FileHistoryView.FileHistoryView) then
    vim.schedule(function()
      view.panel:update_entries(function(_, status)
        if status >= require("diffview.vcs.utils").JobStatus.ERROR then
          return
        end

        if not view:cur_file() then
          view:next_item()
        end
      end)
    end)
  end
end

local function focus_existing_diffview(view_class)
  local ok_lib, lib = pcall(require, "diffview.lib")
  if not ok_lib then
    return false
  end

  for _, view in ipairs(lib.views or {}) do
    if view:instanceof(view_class) and view.tabpage and vim.api.nvim_tabpage_is_valid(view.tabpage) then
      vim.api.nvim_set_current_tabpage(view.tabpage)
      refresh_view(view)
      return true
    end
  end

  return false
end

local function has_current_view()
  local ok_lib, lib = pcall(require, "diffview.lib")
  if not ok_lib then
    return false
  end

  return lib.get_current_view() ~= nil
end

-- 统一管理设置
local function update_preview_line()
  if enable_custom_hl then
    set_custom_preview_line()
  else
    restore_preview_line()
  end
end

-- -- Diffview 进入时设置样式
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "DiffviewViewEnter",
--   callback = function()
--     original_hl = get_hl "CursorLine"
--     enable_custom_hl = true
--     update_preview_line()
--
--     -- 如果尚未监听 ColorScheme，则添加监听
--     if not color_scheme_attached then
--       vim.api.nvim_create_autocmd("ColorScheme", {
--         callback = function()
--           if enable_custom_hl then
--             set_custom_preview_line()
--           end
--         end,
--       })
--       color_scheme_attached = true
--     end
--   end,
-- })
--
-- -- Diffview 离开时恢复样式
-- vim.api.nvim_create_autocmd("User", {
--   pattern = "DiffviewViewLeave",
--   callback = function()
--     enable_custom_hl = false
--     restore_preview_line()
--   end,
-- })

return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewFocusFiles", "DiffviewClose" },
  config = function()
    local actions = require "diffview.actions"

    require("diffview").setup {
      enhanced_diff_hl = false,
      file_panel = {
        listing_style = "list",
        win_config = { -- See ':h diffview-config-win_config'
          position = "bottom",
          height = 10,
        },
      },
      hooks = {
        view_enter = func.setColor,
        view_opened = func.setColor,
      },
      keymaps = {
        view = {
          { "n", "<leader>b", false },
          { "n", "<leader>e", false },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel." } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
        },
        file_panel = {
          { "n", "<leader>b", false },
          { "n", "<leader>e", false },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel" } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
        },
        file_history_panel = {
          { "n", "<leader>b", false },
          { "n", "<leader>e", false },
          { "n", "<leader>db", actions.toggle_files, { desc = "Toggle the file panel" } },
          { "n", "<leader>de", actions.focus_files, { desc = "Bring focus to the file panel" } },
        },
      },
      view = {
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
          disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = true,          -- See |diffview-config-view.x.winbar_info|
        },
        merge_tool = {
          layout = "diff4_mixed",
        },
      },
    }

    set_autocmd()
    func.setColor()
  end,
  -- Export functions for keymaps.lua
  extra = {
    open = function()
      local DiffView = require("diffview.scene.views.diff.diff_view").DiffView
      if not focus_existing_diffview(DiffView) then
        vim.api.nvim_command "DiffviewOpen"
      end
    end,
    close = function()
      vim.api.nvim_command "DiffviewClose"
    end,
    file_history = function()
      local FileHistoryView = require("diffview.scene.views.file_history.file_history_view").FileHistoryView
      if not focus_existing_diffview(FileHistoryView) then
        vim.api.nvim_command "DiffviewFileHistory"
      end
    end,
    current_file_history = function()
      local FileHistoryView = require("diffview.scene.views.file_history.file_history_view").FileHistoryView
      if not focus_existing_diffview(FileHistoryView) then
        vim.api.nvim_command "DiffviewFileHistory %"
      end
    end,
    has_current_view = has_current_view,
    toggle_files = function()
      vim.api.nvim_command "DiffviewToggleFiles"
    end,
    focus_files = function()
      vim.api.nvim_command "DiffviewFocusFiles"
    end,
    diffget = function()
      vim.api.nvim_command "diffget"
    end,
    diffput = function()
      vim.api.nvim_command "diffput"
    end,
  },
}
