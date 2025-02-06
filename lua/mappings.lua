local utils = require "utils"
local func = dofile(vim.fn.stdpath "config" .. "/lua/func.lua")

local map = vim.keymap.set

-- map("n", "<leader>x", function()
--   require("nvchad.tabufline").close_buffer()
-- end, { desc = "buffer close" })

map("n", "<leader>cc", function()
  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }
  local node = require("ibl.scope").get(vim.api.nvim_get_current_buf(), config)

  if node then
    local start_row, _, end_row, _ = node:range()
    if start_row ~= end_row then
      vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), { start_row + 1, 0 })
      vim.api.nvim_feedkeys("_", "n", true)
    end
  end
end, { desc = "blankline jump to current context" })

local M = {}

M.default = function()
  -- -- map("n", ";", ":", { desc = "CMD enter command mode" })
  -- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
  -- Comment
  map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
  map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

  -- 0 line
  map({ "n", "v" }, "<C-9>", function()
    local pos = func.getLineHeadIndex().p0
    vim.fn.cursor(0, pos)
  end, { desc = "0 line" })
  -- 25% line
  -- map({ "n", "v" }, "<C-j>", function()
  --   local line = vim.fn.getline "."
  --   vim.fn.cursor(0, math.floor((string.len(line)) / 4))
  -- end, { desc = "25% line" })
  -- 50% line
  map({ "n", "v" }, "<C-m>", function()
    local line = vim.fn.getline "."
    vim.fn.cursor(0, math.floor((string.len(line)) / 2))
  end, { desc = "50% line" })
  -- 75% line
  -- map({ "n", "v" }, "<C-k>", function()
  --   local line = vim.fn.getline "."
  --   vim.fn.cursor(0, math.floor((3 * string.len(line)) / 4))
  -- end, { desc = "75% line" })
  -- 100% line
  map({ "n", "v" }, "<C-0>", function()
    local line = vim.fn.getline "."
    vim.fn.cursor(0, string.len(line))
  end, { desc = "100% line" })

  map({ "n", "v" }, "<leader>q", "<cmd>q<CR>")
  map("i", ";q", "<ESC>")
  map({ "n", "i", "v" }, "<leader>w", "<cmd> w <cr>")
  map("n", "<leader>1", "1gt")
  map("n", "<leader>2", "2gt")
  map("n", "<leader>3", "3gt")
  map("n", "<leader>4", "4gt")
  map("n", "<leader>5", "5gt")
  map("n", "<leader>6", "6gt")
  map("v", "p", '"0p', { noremap = true })
  -- TODO del this
  -- map("n", "<space>", "viw")

  map("n", "<leader>cc", function()
    local curWord = vim.fn.expand "<cword>"
    -- local path = vim.fn.expand('<cfile>')
    local line = vim.fn.line "."
    local str = "console.log(`" .. curWord .. "`, " .. curWord .. ")"
    vim.fn.append(line, str)
  end)
  map({ "n", "v" }, "<leader>*", function()
    local curWord = utils.get_current_word()
    local cmd_str = "match IncSearch /\\<" .. curWord .. "\\>/"
    vim.api.nvim_command(cmd_str)
  end)

  map("i", "<C-b>", "<ESC>^i", { desc = "move beginning of line" })
  map("i", "<C-e>", "<End>", { desc = "move end of line" })
  map("i", "<C-h>", "<Left>", { desc = "move left" })
  map("i", "<C-l>", "<Right>", { desc = "move right" })
  map("i", "<C-j>", "<Down>", { desc = "move down" })
  map("i", "<C-k>", "<Up>", { desc = "move up" })

  map("n", "<Esc>", "<cmd>noh<CR>", { desc = "general clear highlights" })

  map("n", "<C-h>", "<C-w>h", { desc = "switch window left" })
  map("n", "<C-l>", "<C-w>l", { desc = "switch window right" })
  map("n", "<C-j>", "<C-w>j", { desc = "switch window down" })
  map("n", "<C-k>", "<C-w>k", { desc = "switch window up" })

  map("n", "<C-s>", "<cmd>w<CR>", { desc = "file save" })
  map("n", "<C-c>", "<cmd>%y+<CR>", { desc = "file copy whole" })

  map("n", "<leader>n", "<cmd>set nu!<CR>", { desc = "toggle line number" })
  map("n", "<leader>rn", "<cmd>set rnu!<CR>", { desc = "toggle relative number" })
  map("n", "<leader>ch", "<cmd>NvCheatsheet<CR>", { desc = "toggle nvcheatsheet" })

  map("n", "<tab>", function()
    require("nvchad.tabufline").next()
  end, { desc = "buffer goto next" })

  map("n", "<S-tab>", function()
    require("nvchad.tabufline").prev()
  end, { desc = "buffer goto prev" })
end

M.terminal = function()
  -- terminal
  map("t", "<C-[>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

  -- new terminals
  map("n", "<leader>h", function()
    require("nvchad.term").new { pos = "sp" }
  end, { desc = "terminal new horizontal term" })

  map("n", "<leader>v", function()
    require("nvchad.term").new { pos = "vsp" }
  end, { desc = "terminal new vertical window" })

  -- toggleable
  map({ "n", "t" }, "<A-v>", function()
    require("nvchad.term").toggle { pos = "vsp", id = "vtoggleTerm" }
  end, { desc = "terminal toggleable vertical term" })

  map({ "n", "t" }, "<A-h>", function()
    require("nvchad.term").toggle { pos = "sp", id = "htoggleTerm" }
  end, { desc = "terminal new horizontal term" })

  map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm" }
  end, { desc = "terminal toggle floating term" })
end

M.default()
M.terminal()

return M
