require "nvchad.mappings"
local telescope_builtin = require "telescope.builtin"
local utils = require "utils"

local map = vim.keymap.set
local del_map = vim.keymap.del

local M = {}

M.default = function()
  -- map("n", ";", ":", { desc = "CMD enter command mode" })
  map({ "n", "v", "i" }, "<leader>q", "<cmd>bd!<CR>")
  map("i", "jk", "<ESC>")
  -- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
  map("n", "<leader>i", "<cmd> set ignorecase!<CR>")
  map("n", "<leader>1", "1gt")
  map("n", "<leader>2", "2gt")
  map("n", "<leader>3", "3gt")
  map("n", "<leader>4", "4gt")
  map("n", "<leader>5", "5gt")
  map("n", "<leader>6", "6gt")
  map("v", "p", '"0p', { noremap = true })
  map("n", "<leader>q", "<cmd>:q<CR>")
  map("n", "<space>", "viw")

  map("n", "<leader>cc", function()
    local curWord = vim.fn.expand "<cword>"
    -- local path = vim.fn.expand('<cfile>')
    local line = vim.fn.line "."
    local str = "console.log('" .. curWord .. "', " .. curWord .. ")"
    vim.fn.append(line, str)
  end)
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
    telescope_builtin.live_grep {
      prompt_title = "Grep Search (regex:on case_sensitive:on)",
      default_text = cur_word,
    }
  end)
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
  map("n", "<leader>fm", vim.lsp.buf.format)
  map("n", "<leader>fe", vim.diagnostic.open_float)
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
