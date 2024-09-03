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
        view_opened = function()
          func.setColor()
        end,
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
  end,
}
