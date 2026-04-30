return {
  "sudo-tee/opencode.nvim",
  lazy = false,
  config = function()
    local function opencode_float_geometry()
      local editor_width = vim.o.columns
      local editor_height = math.max(1, vim.o.lines - vim.o.cmdheight - 1)
      local total_width = math.max(20, math.floor(editor_width * 0.70))
      local total_height = math.max(8, math.floor(editor_height * 0.50))
      local input_height = math.min(4, total_height - 3)
      local output_height = total_height - input_height - 2

      return {
        col = math.max(0, math.floor((editor_width - total_width) / 2)),
        input_height = input_height,
        input_row = math.max(0, editor_height - input_height),
        output_height = math.max(1, output_height),
        output_width = math.max(1, total_width - 2),
        row = math.max(0, editor_height - total_height),
        total_width = total_width,
      }
    end

    local function opencode_output_float_config()
      local geometry = opencode_float_geometry()
      return {
        relative = "editor",
        width = geometry.output_width,
        height = geometry.output_height,
        row = geometry.row,
        col = geometry.col,
        style = "minimal",
        border = "rounded",
        zindex = 40,
      }
    end

    local function opencode_input_float_config()
      local geometry = opencode_float_geometry()
      return {
        relative = "editor",
        width = geometry.total_width,
        height = geometry.input_height,
        row = geometry.input_row,
        col = geometry.col,
        style = "minimal",
        zindex = 41,
      }
    end

    local scrolloff_by_window = {}

    local function show_last_line_at_top(win)
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].buftype ~= "" then
        return
      end

      local line_count = vim.api.nvim_buf_line_count(buf)
      if line_count < 1 then
        return
      end

      pcall(vim.api.nvim_win_call, win, function()
        scrolloff_by_window[win] = scrolloff_by_window[win] or vim.wo.scrolloff
        vim.wo.scrolloff = 0

        local view = vim.fn.winsaveview()
        view.lnum = line_count
        view.topline = line_count
        vim.fn.winrestview(view)
      end)
    end

    local function restore_scrolloff()
      for win, scrolloff in pairs(scrolloff_by_window) do
        if vim.api.nvim_win_is_valid(win) then
          pcall(vim.api.nvim_win_call, win, function()
            vim.wo.scrolloff = scrolloff
          end)
        end

        scrolloff_by_window[win] = nil
      end
    end

    require("opencode").setup({
      preferred_completion = "nvim-cmp",
      ui = {
        position = "right",
        input_position = "bottom",
        window_width = 0.70,
        persist_state = false,
      },
    })

    local ui = require("opencode.ui.ui")
    local input_window = require("opencode.ui.input_window")
    local output_window = require("opencode.ui.output_window")
    local state = require("opencode.state")

    function ui.create_split_windows(input_buf, output_buf)
      if input_window.mounted() or output_window.mounted() then
        ui.close_windows(state.windows, false)
      end

      local output_win = vim.api.nvim_open_win(output_buf, false, opencode_output_float_config())
      local input_win = vim.api.nvim_open_win(input_buf, true, opencode_input_float_config())

      return { input_win = input_win, output_win = output_win }
    end

    function output_window.update_dimensions(windows)
      if not windows or not windows.output_win or not vim.api.nvim_win_is_valid(windows.output_win) then
        return
      end

      pcall(vim.api.nvim_win_set_config, windows.output_win, opencode_output_float_config())
    end

    function input_window.update_dimensions(windows)
      if not input_window.mounted(windows) then
        return
      end

      pcall(vim.api.nvim_win_set_config, windows.input_win, opencode_input_float_config())
    end

    local function opencode_visible()
      return input_window.mounted(state.windows) or output_window.mounted(state.windows)
    end

    local window_actions = require("opencode.commands.handlers.window").actions

    vim.keymap.set({ "n", "t" }, "<leader>og", function()
      if opencode_visible() then
        restore_scrolloff()
      else
        show_last_line_at_top(vim.api.nvim_get_current_win())
      end

      window_actions.toggle()
    end, { desc = "Toggle floating Opencode" })
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { 'markdown', 'Avante', 'opencode_output' },
        heading = {
          sign = false,
          position = "inline",
          icons = { "" },
          backgrounds = {},
          border = false,
        },
      },
      ft = { 'markdown', 'Avante', 'copilot-chat', 'opencode_output' },
    },
    -- Optional, for file mentions and commands completion, pick only one
    -- 'saghen/blink.cmp',
    'hrsh7th/nvim-cmp',

    -- Optional, for file mentions picker, pick only one
    'folke/snacks.nvim',
    -- 'nvim-telescope/telescope.nvim',
    -- 'ibhagwan/fzf-lua',
    -- 'nvim_mini/mini.nvim',
  },
}
