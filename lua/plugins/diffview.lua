local func = require "func"

local function set_mappings()
  local map = vim.keymap.set
  map({ "n", "v", "i" }, "<leader>do", function()
    vim.api.nvim_command "DiffviewOpen"
  end, { desc = "Diffview Open" })
  map({ "n", "v", "i" }, "<leader>dc", function()
    vim.api.nvim_command "DiffviewClose"
  end, { desc = "Diffview Close" })
  map({ "n", "v", "i" }, "<leader>dh", function()
    vim.api.nvim_command "DiffviewFileHistory"
  end, { desc = "Diffview File History" })
  map({ "n", "v", "i" }, "<leader>df", function()
    vim.api.nvim_command "DiffviewFileHistory %"
  end, { desc = "Diffview Current File History" })
end

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
  lazy = false,
  -- cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  config = function()
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
      view = {
        default = {
          -- Config for changed files, and staged files in diff views.
          layout = "diff2_horizontal",
          disable_diagnostics = false, -- Temporarily disable diagnostics for diff buffers while in the view.
          winbar_info = true, -- See |diffview-config-view.x.winbar_info|
        },
        merge_tool = {
          layout = "diff4_mixed",
        },
      },
    }

    set_mappings()
    set_autocmd()
    func.setColor()
  end,
}
