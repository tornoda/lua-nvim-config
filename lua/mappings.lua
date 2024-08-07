local telescope_builtin = require "telescope.builtin"
local utils = require "utils"

local map = vim.keymap.set
local del_map = vim.keymap.del

map("n", "<leader>fm", function()
  require("conform").format { lsp_fallback = true }
end, { desc = "format files" })

-- global lsp mappings
map("n", "<leader>ds", vim.diagnostic.setloclist, { desc = "lsp diagnostic loclist" })

-- tabufline
map("n", "<leader>b", "<cmd>enew<CR>", { desc = "buffer new" })

map("n", "<tab>", function()
  require("nvchad.tabufline").next()
end, { desc = "buffer goto next" })

map("n", "<S-tab>", function()
  require("nvchad.tabufline").prev()
end, { desc = "buffer goto prev" })

map("n", "<leader>x", function()
  require("nvchad.tabufline").close_buffer()
end, { desc = "buffer close" })

-- Comment
map("n", "<leader>/", "gcc", { desc = "comment toggle", remap = true })
map("v", "<leader>/", "gc", { desc = "comment toggle", remap = true })

-- nvimtree
map("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", { desc = "nvimtree toggle window" })
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "nvimtree focus window" })

-- telescope

-- terminal
map("t", "<C-x>", "<C-\\><C-N>", { desc = "terminal escape terminal mode" })

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

-- whichkey
map("n", "<leader>wK", "<cmd>WhichKey <CR>", { desc = "whichkey all keymaps" })

map("n", "<leader>wk", function()
  vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
end, { desc = "whichkey query lookup" })

-- blankline
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
  map("n", "<space>", "viw")

  map("n", "<leader>cc", function()
    local curWord = vim.fn.expand "<cword>"
    -- local path = vim.fn.expand('<cfile>')
    local line = vim.fn.line "."
    local str = "console.log('" .. curWord .. "', " .. curWord .. ")"
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
end

M.telescope = function()
  map("n", "<leader>b", "<cmd>Telescope buffers<CR>")
  map("n", "gr", "<cmd>Telescope lsp_references<CR>")
  map("n", "<leader><leader>", "<cmd>Telescope builtin<CR>")
  map("n", "<leader>jl", "<cmd>Telescope jumplist<CR>")
  map("n", "<leader>gs", "<cmd>Telescope git_status<CR>")
  map("n", "<leader>ic", "<cmd>Telescope lsp_incoming_calls<CR>")
  -- search the selection words
  map({ "v", "n" }, "<leader>fw", function()
    local cur_word = utils.get_current_word()
    local _ret = string.find(cur_word, "[a-zA-Z_]+")
    local hasPre = _ret == 1
    local default_text = hasPre and "\\b" .. cur_word .. "\\b" or ""

    telescope_builtin.live_grep {
      prompt_title = "Grep Search (regex:on case_sensitive:on)",
      default_text = default_text,
    }
  end)
  -- copy from nvchad
  map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "telescope find buffers" })
  map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "telescope help page" })
  map("n", "<leader>ma", "<cmd>Telescope marks<CR>", { desc = "telescope find marks" })
  map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>", { desc = "telescope find oldfiles" })
  map("n", "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "telescope find in current buffer" })
  map("n", "<leader>cm", "<cmd>Telescope git_commits<CR>", { desc = "telescope git commits" })
  map("n", "<leader>pt", "<cmd>Telescope terms<CR>", { desc = "telescope pick hidden term" })
  map("n", "<leader>th", "<cmd>Telescope themes<CR>", { desc = "telescope nvchad themes" })
  map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "telescope find files" })
  map(
    "n",
    "<leader>fa",
    "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>",
    { desc = "telescope find all files" }
  )
end

M.trouble = function()
  map({ "n", "v" }, "<leader>tc", function()
    require("trouble").close()
  end)
  map({ "n", "v" }, "<leader>tf", function()
    require("trouble").focus()
  end)
  -- keys = {--   {
  --     "<leader>xx",
  --     "<cmd>Trouble diagnostics toggle<cr>",
  --     desc = "Diagnostics (Trouble)",
  --   },
  --   {
  --     "<leader>xX",
  --     "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  --     desc = "Buffer Diagnostics (Trouble)",
  --   },
  --   {
  --     "<leader>cs",
  --     "<cmd>Trouble symbols toggle focus=false<cr>",
  --     desc = "Symbols (Trouble)",
  --   },
  --   {
  --     "<leader>cl",
  --     "<cmd>Trouble lsp toggle focus=false<cr>",
  --     desc = "LSP Definitions / references / ... (Trouble)",
  --   },
  --   {
  --     "<leader>xL",
  --     "<cmd>Trouble loclist toggle<cr>",
  --     desc = "Location List (Trouble)",
  --   },
  --   {
  --     "<leader>xQ",
  --     "<cmd>Trouble qflist toggle<cr>",
  --     desc = "Quickfix List (Trouble)",
  --   },
  -- },
end

M.lsp = function()
  map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action)
  map("n", "[e", vim.diagnostic.goto_prev)
  map("n", "]e", vim.diagnostic.goto_next)
  map("n", "<leader>fe", vim.diagnostic.open_float)

  local function setGd()
    vim.keymap.del("n", "gd", { buffer = args.buf })
    map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
  end

  -- vim.defer_fn(function()
  --   pcall(setGd)
  -- end, 0)
end

M.gitsigns = function()
  map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>")
  map("n", "]c", "<cmd>Gitsigns next_hunk<CR>")
end

------ register mapping -------
M.default()
M.lsp()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    vim.defer_fn(function()
      pcall(function()
        vim.keymap.del("n", "gd", { buffer = args.buf })
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
        -- map("n", "gd", "<cmd>Trouble lsp_definitions<CR>")
      end)
    end, 0)
  end,
})

return M
