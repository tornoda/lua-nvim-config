-- Unified keymaps configuration
-- This file consolidates all leader key mappings with which-key integration

local map = vim.keymap.set
local utils = require "utils"
local _trouble = require "plugins._trouble"
local indent_blankline = require "plugins.indent-blankline"
local has_comment, comment_api = pcall(require, "Comment.api")

-- Unified keymaps configuration
-- This file consolidates all leader key mappings with which-key integration

-- Helper function to create keymaps with which-key integration
local function create_keymap(mode, lhs, rhs, opts)
  opts = opts or {}
  -- Handle both single mode string and table of modes
  if type(mode) == "table" then
    for _, m in ipairs(mode) do
      map(m, lhs, rhs, opts)
    end
  else
    map(mode, lhs, rhs, opts)
  end
end

-- ============================================================================
-- MODULE DEFINITIONS
-- ============================================================================

-- Find/Search module
local Find = {
  group = "find",
  icon = "🔍",
  name = "Find/Search",
  leader = "<leader>f",
  keymaps = function()
    local telescope = require "plugins.telescope"

    create_keymap("n", "<leader>ff", telescope.extra.smart_find_files, { desc = "find files" })
    create_keymap({ "v", "n" }, "<leader>fw", telescope.extra.smart_live_grep, { desc = "find word (grep)" })
    -- create_keymap({ "v", "n" }, "<leader>fw", "<cmd>Telescope grep_string<CR>", { desc = "find word (grep)" })
    create_keymap("n", "<leader>fb", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "find in buffer" })
    create_keymap("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "find old files" })
    create_keymap("n", "<leader>fa", telescope.extra.find_all_files, { desc = "find all files (including hidden)" })
    create_keymap("n", "<leader>fd", telescope.extra.find_files_in_directory,
      { desc = "find files in specific directory" })
    create_keymap("n", "<leader>fg", telescope.extra.grep_git_modified, { desc = "find in git modified files" })

    create_keymap(
      "n",
      "<leader>fsb",
      "<cmd>Telescope lsp_document_symbols<cr>",
      { desc = "find LSP symbols (document)" }
    )
    create_keymap(
      "n",
      "<leader>fsg",
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      { desc = "find LSP symbols (workspace)" }
    )
    create_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "find help" })
  end,
}

-- Git module
local Git = {
  group = "git",
  icon = "",
  name = "Git Operations",
  leader = "<leader>g",
  keymaps = function()
    local gitsigns = require "plugins.gitsigns"

    create_keymap("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "git status" })
    create_keymap("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "git commits" })
    create_keymap("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "git branches" })
    create_keymap("n", "<leader>gn", gitsigns.extra.next_hunk, { desc = "next git hunk" })
    create_keymap("n", "<leader>gp", gitsigns.extra.prev_hunk, { desc = "prev git hunk" })
  end,
}

-- Diff module
local Diff = {
  group = "diff",
  icon = "📊",
  name = "Diff/Diffview",
  leader = "<leader>d",
  keymaps = function()
    local diffview = require "plugins.diffview"

    create_keymap({ "n", "v", "i" }, "<leader>do", diffview.extra.open, { desc = "diffview open" })
    create_keymap({ "n", "v", "i" }, "<leader>dc", diffview.extra.close, { desc = "diffview close" })
    create_keymap({ "n", "v", "i" }, "<leader>dh", diffview.extra.file_history, { desc = "diffview history" })
    create_keymap({ "n", "v", "i" }, "<leader>df", diffview.extra.current_file_history,
      { desc = "diffview file history" })
    create_keymap({ "n", "v", "i" }, "<leader>db", diffview.extra.toggle_files, { desc = "diffview toggle files" })
    create_keymap({ "n", "v", "i" }, "<leader>de", diffview.extra.focus_files, { desc = "diffview focus files" })
    create_keymap({ "n", "v", "i" }, "<leader>dg", diffview.extra.diffget, { desc = "diffget" })
    create_keymap({ "n", "v", "i" }, "<leader>dp", diffview.extra.diffput, { desc = "diffput" })
  end,
}

-- Toggle module
local Toggle = {
  group = "toggle",
  icon = "🔄",
  name = "Toggle/Terminal/Trouble",
  leader = "<leader>t",
  keymaps = function()
    create_keymap({ "n", "v" }, "<leader>tt", "<cmd>Trouble<cr>", { desc = "toggle trouble" })

    create_keymap({ "n", "v" }, "<leader>tc", function()
      require("trouble").close()
    end, { desc = "close trouble" })

    create_keymap({ "n", "v" }, "<leader>tf", function()
      require("trouble").focus()
    end, { desc = "focus trouble" })

    create_keymap("n", "<leader>tz", "<cmd>ZenMode<CR>", { desc = "toggle zen mode" })

    -- Terminal operations (moved from <leader>h to <leader>th)
    create_keymap("n", "<leader>th", function()
      require("nvchad.term").new { pos = "sp" }
    end, { desc = "terminal horizontal" })

    create_keymap("n", "<leader>tv", function()
      require("nvchad.term").new { pos = "vsp" }
    end, { desc = "terminal vertical" })

    create_keymap({ "n", "t" }, "<A-v>", function()
      require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
    end, { desc = "terminal toggleable vertical" })

    create_keymap({ "n", "t" }, "<A-h>", function()
      require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
    end, { desc = "terminal toggleable horizontal" })

    create_keymap({ "n", "t" }, "<A-i>", function()
      require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
    end, { desc = "terminal toggle floating" })

    create_keymap("n", "<leader>tn", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })

    -- Append nvim-tree path or selection coordinates to active terminal
    create_keymap({ "n", "v" }, "<leader>ta", function()
      local mode = vim.fn.mode()
      local content

      if mode == "v" or mode == "\22" then
        -- Character/Block visual mode: get selected text content
        local utils = require "utils"
        content = utils.get_visual_selection()
      elseif mode == "V" then
        -- Line visual mode: get path:startLine:endLine format
        local utils = require "utils"
        content = utils.get_selection_coordinates()
      else
        -- Normal mode: get nvim-tree path
        local nvim_tree = require "plugins.nvim-tree"
        content = nvim_tree.extra.get_path()
      end

      if not content or content == "" then
        vim.notify("No content found", vim.log.levels.WARN)
        return
      end

      -- Find first terminal buffer
      local term_chan = nil
      local term_buf = nil
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
          term_chan = vim.api.nvim_buf_get_var(buf, "terminal_job_id")
          if term_chan then
            term_buf = buf
            break
          end
        end
      end

      if term_chan then
        vim.api.nvim_chan_send(term_chan, content)
        vim.notify("Content appended to terminal", vim.log.levels.INFO)

        -- Exit visual mode if in visual mode
        if mode == "v" or mode == "V" or mode == "\22" then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end

        -- Focus to terminal and enter terminal mode
        -- Find the window containing the terminal buffer
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_buf(win) == term_buf then
            vim.api.nvim_set_current_win(win)
            vim.cmd("startinsert")
            return
          end
        end
      else
        vim.notify("No active terminal found", vim.log.levels.WARN)
      end
    end, { desc = "terminal append content" })
  end,
}

-- LSP module
local LSP = {
  group = "lsp",
  icon = "",
  name = "LSP Operations",
  leader = "<leader>l",
  keymaps = function()
    -- Code action (moved from <leader>a to <leader>la)
    create_keymap({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "code action" })

    create_keymap("n", "<leader>lf", function()
      require("conform").format { lsp_fallback = true }
    end, { desc = "format" })

    create_keymap("n", "<leader>lr", function()
      vim.lsp.buf.rename()
    end, { desc = "rename" })

    create_keymap("n", "<leader>li", vim.lsp.buf.implementation, { desc = "implementation" })
    create_keymap("n", "<leader>ld", vim.lsp.buf.definition, { desc = "definition" })
    create_keymap("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "type definition" })
    create_keymap("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "declaration" })
    create_keymap("n", "<leader>le", vim.diagnostic.open_float, { desc = "show diagnostics" })
    create_keymap("n", "<leader>ls", vim.lsp.buf.signature_help, { desc = "signature help" })

    -- Workspace operations (moved from <leader>w to <leader>lw)
    create_keymap("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
    create_keymap("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
    create_keymap("n", "<leader>lwl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, { desc = "list workspace folders" })
  end,
}

-- Code module
local Code = {
  group = "code",
  icon = "💻",
  name = "Code Utilities",
  leader = "<leader>c",
  keymaps = function()
    create_keymap("n", "<leader>cl", function()
      local curWord = vim.fn.expand "<cword>"
      local line = vim.fn.line "."
      local str = "console.log(`" .. curWord .. "`, " .. curWord .. ")"
      vim.fn.append(line, str)
    end, { desc = "console.log" })

    create_keymap("n", "<leader>cc", indent_blankline.extra.jump_to_scope, { desc = "jump to context" })

    create_keymap("n", "<leader>co", ":Code<CR>", { desc = "open in Cursor (dir)" })
    create_keymap("n", "<leader>cf", ":Code %<CR>", { desc = "open in Cursor (file)" })
  end,
}

-- Window module
local Window = {
  group = "window",
  icon = "🪟",
  name = "Window/Buffer",
  leader = "<leader>w",
  keymaps = function()
    local nvim_tree = require "plugins.nvim-tree"
    local telescope = require "plugins.telescope"

    create_keymap({ "n", "i", "v", "t" }, "<leader>w", function()
      local ok, err = pcall(vim.lsp.buf.format, { async = false })
      if not ok then
        vim.notify("Format failed: " .. tostring(err), vim.log.levels.WARN)
      end
      vim.cmd "wa"
    end, { desc = "format and save all files" })
    create_keymap("n", "<leader>b", telescope.extra.select_buffers_and_tabs, { desc = "buffer/diffview list" })
    create_keymap("n", "<leader><Tab>", telescope.extra.select_tabs, { desc = "tab list" })
    create_keymap("n", "<leader>e", nvim_tree.extra.focus, { desc = "file explorer" })
  end,
}

-- Run module
local Run = {
  group = "run",
  icon = "▶️",
  name = "Run/Replace",
  leader = "<leader>r",
  keymaps = function()
    create_keymap({ "t", "n", "i" }, "<leader>rs", function()
      require("scripts.run_npm_scripts").run_script_select()
    end, { desc = "run npm script" })
  end,
}

-- Jump module
local Jump = {
  group = "jump",
  icon = "↗️",
  name = "Jump Operations",
  leader = "<leader>j",
  keymaps = function()
    create_keymap("n", "<leader>jl", "<cmd>Telescope jumplist<CR>", { desc = "jumplist" })
  end,
}

-- Marks module
local Marks = {
  group = "marks",
  icon = "📍",
  name = "Marks",
  leader = "<leader>m",
  keymaps = function()
    create_keymap("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "marks list" })
  end,
}

-- Project module
local Project = {
  group = "project",
  icon = "📁",
  name = "Project/Picker",
  leader = "<leader>p",
  keymaps = function()
    create_keymap("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "pick terminal" })
  end,
}

-- Quick module
local Quick = {
  group = "quick",
  icon = "⚡",
  name = "Quick Actions",
  leader = "<leader>",
  keymaps = function()
    create_keymap("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line numbers" })
    create_keymap("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative numbers" })
    create_keymap({ "n", "v" }, "<leader>q", "<cmd>q<CR>", { desc = "quit" })
    -- File explorer moved to Window module

    -- Translation
    create_keymap("n", "<leader>tr", "viw<Cmd>Translate ZH<CR>", { desc = "translate word" })
    create_keymap("v", "<leader>tr", ":<C-u>Translate ZH<CR>", { desc = "translate selection" })

    -- Tab switching
    create_keymap("n", "<leader>1", "1gt", { desc = "tab 1" })
    create_keymap("n", "<leader>2", "2gt", { desc = "tab 2" })
    create_keymap("n", "<leader>3", "3gt", { desc = "tab 3" })
    create_keymap("n", "<leader>4", "4gt", { desc = "tab 4" })
    create_keymap("n", "<leader>5", "5gt", { desc = "tab 5" })
    create_keymap("n", "<leader>6", "6gt", { desc = "tab 6" })

    -- Comment toggle
    create_keymap("n", "<leader>/", function()
      if not has_comment then
        vim.notify("Comment.nvim not available", vim.log.levels.WARN)
        return
      end
      comment_api.toggle.linewise.current()
    end, { desc = "comment toggle" })
    create_keymap("v", "<leader>/", function()
      if not has_comment then
        vim.notify("Comment.nvim not available", vim.log.levels.WARN)
        return
      end
      local mode = vim.fn.visualmode()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      comment_api.toggle.linewise(mode)
    end, { desc = "comment toggle" })

    -- Highlight word
    create_keymap({ "n", "v" }, "<leader>*", function()
      local curWord = utils.get_current_word()
      local cmd_str = "match IncSearch /\\<" .. curWord .. "\\>/"
      vim.api.nvim_command(cmd_str)
    end, { desc = "highlight word" })

    -- Telescope builtin
    create_keymap("n", "<leader>tb", "<cmd>Telescope builtin<CR>", { desc = "telescope builtin" })
  end,
}


-- ============================================================================
-- MODULE REGISTRY
-- ============================================================================

local modules = {
  Find,
  Git,
  Diff,
  Toggle,
  LSP,
  -- AI,
  Code,
  Window,
  Run,
  Jump,
  Marks,
  Project,
  Quick,
  WhichKey,
}

-- ============================================================================
-- WHICH-KEY INTEGRATION
-- ============================================================================

local function register_which_key_groups()
  local ok, wk = pcall(require, "which-key")
  if not ok then
    return
  end

  local groups = {}
  for _, module in ipairs(modules) do
    -- Skip bare leader registration to avoid which-key overlap warnings
    if module.leader and module.leader ~= "<leader>" then
      local entry = { module.leader, group = module.group }

      if module.icon and module.icon ~= "" then
        entry.icon = module.icon
      end

      table.insert(groups, entry)
    end
  end

  wk.add(groups)
end

-- ============================================================================
-- INITIALIZATION
-- ============================================================================

local M = {}

M.default = function()
  -- Register which-key groups first
  register_which_key_groups()

  -- Initialize all modules
  for _, module in ipairs(modules) do
    module.keymaps()
  end

  -- Additional global mappings
  M.global()
  M.insert()
  M.visual()
  M.navigation()
  M.search()
  M.terminal()
end

-- ============================================================================
-- ADDITIONAL MAPPINGS
-- ============================================================================

M.global = function()
  -- Remove default mappings that conflict with leader based setup
  pcall(vim.keymap.del, "n", "gc")
  pcall(vim.keymap.del, "n", "gcc")
  pcall(vim.keymap.del, "v", "gc")

  -- Go to operations
  create_keymap("n", "gx", function()
    local file = vim.fn.expand "<cfile>"
    local line_text = vim.api.nvim_get_current_line()
    local lnum, col = line_text:match ".+:(%d+):(%d+)"
    if file then
      if vim.fn.winnr "$" > 1 then
        vim.cmd "wincmd p"
      end
      vim.cmd("edit " .. file)
      if lnum then
        vim.cmd(lnum)
      end
      if col then
        vim.cmd("normal! " .. col .. "|")
      end
    end
  end, { silent = true, desc = "open file under cursor" })

  create_keymap("n", "gF", function()
    local spectre = require "plugins.nvim-spectre"
    spectre.extra.open_search_replace()
  end, { desc = "spectre search/replace" })

  -- Control keys
  create_keymap("n", "<C-n>", function()
    local nvim_tree = require "plugins.nvim-tree"
    nvim_tree.extra.toggle()
  end, { desc = "nvim-tree toggle" })
  create_keymap("n", "<C-p>", function()
    _trouble.extra.open_lsp_document_symbols()
  end, { desc = "trouble symbols" })

  create_keymap("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
  create_keymap("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
  create_keymap("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
  create_keymap("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

  create_keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "save file" })
  create_keymap("n", "<C-c>", "<cmd>%y+<CR>", { desc = "copy whole file" })

  -- Terminal escape
  create_keymap("t", "<C-[>", "<C-\\><C-N>", { desc = "terminal escape" })

  -- Diagnostic navigation
  create_keymap("n", "[e", vim.diagnostic.goto_prev, { desc = "prev diagnostic" })
  create_keymap("n", "]e", vim.diagnostic.goto_next, { desc = "next diagnostic" })

  -- Git hunk navigation (gitsigns only)
  create_keymap("n", "[c", function()
    local gitsigns = require "plugins.gitsigns"
    gitsigns.extra.prev_hunk()
  end, { desc = "prev git hunk" })
  create_keymap("n", "]c", function()
    local gitsigns = require "plugins.gitsigns"
    gitsigns.extra.next_hunk()
  end, { desc = "next git hunk" })

  -- Tab navigation in trouble
  create_keymap("n", "<Tab>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft == "trouble" then
        local trouble = require "trouble"
        trouble.next()
        trouble.jump()
        return
      end
    end
  end, { noremap = true, silent = true, desc = "next item in trouble" })

  create_keymap("n", "<S-Tab>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft == "trouble" then
        local trouble = require "trouble"
        trouble.prev()
        trouble.jump()
        return
      end
    end
  end, { noremap = true, silent = true, desc = "prev item in trouble" })
end

M.insert = function()
  create_keymap("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
  create_keymap("i", "<C-e>", "<End>", { desc = "move end of line" })
  create_keymap("i", "<C-h>", "<Left>", { desc = "move left" })
  create_keymap("i", "<C-l>", "<Right>", { desc = "move right" })
  create_keymap("i", "<C-j>", "<Down>", { desc = "move down" })
  create_keymap("i", "<C-k>", "<Up>", { desc = "move up" })
  create_keymap("i", ";q", "<ESC>", { desc = "exit insert mode" })
end

M.visual = function()
  create_keymap("v", "p", '"0p', { noremap = true, desc = "paste from register 0" })
end

M.navigation = function()
  local func = dofile(vim.fn.stdpath "config" .. "/lua/func.lua")

  create_keymap({ "n", "v" }, "<C-9>", function()
    local pos = func.getLineHeadIndex().p0
    vim.fn.cursor(0, pos)
  end, { desc = "go to line start" })

  create_keymap({ "n", "v" }, "<C-m>", function()
    local line = vim.fn.getline "."
    vim.fn.cursor(0, math.floor((string.len(line)) / 2))
  end, { desc = "go to line middle" })

  create_keymap({ "n", "v" }, "<C-0>", function()
    local line = vim.fn.getline "."
    vim.fn.cursor(0, string.len(line))
  end, { desc = "go to line end" })
end

M.search = function()
  create_keymap("n", "/", "/\\V", { noremap = true, desc = "search very magic" })
  create_keymap("n", "?", "?\\V", { noremap = true, desc = "search backward very magic" })
  create_keymap("n", "<Esc>", "<cmd>noh<CR>", { desc = "clear highlights" })
end

M.terminal = function()
  create_keymap("t", "<C-s>", function()
    require("scripts.term_list").showSelection()
  end, { desc = "terminal script selection" })
end

-- Initialize all keymaps
M.default()

return M
