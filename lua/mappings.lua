require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<leader>i", "<cmd> set ignorecase!<CR>")
map("n", "<leader>1", "1gt")
map("n", "<leader>2", "2gt")
map("n", "<leader>3", "3gt")
map("n", "<leader>4", "4gt")
map("n", "<leader>5", "5gt")
map("n", "<leader>6", "6gt")

map("n", "<leader>q", "<cmd>:q<CR>")
map("n", "<space>", "viw")

-----------lsp-------------
map("n", "<leader>a", function()
  vim.lsp.buf.code_action()
end)
map("n", "[e", function()
  vim.diagnostic.goto_prev()
end)
map("n", "]e", function()
  vim.diagnostic.goto_next()
end)
map("n", "<leader>fm", function()
  vim.lsp.buf.format()
end)
map("n", "<leader>fe", function()
  vim.diagnostic.open_float()
end)

-----------telescope-------
map("n", "<leader>b", "<cmd>Telescope buffers<CR>")
map("n", "gr", "<cmd>Telescope lsp_references<CR>")
map("n", "<leader><leader>", "<cmd>Telescope builtin<CR>")
map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")

-- vim.api.nvim_create_autocmd('LspAttach', {
--   callback = function(args)
--     vim.keymap.del('n', 'gd', { buffer = args.buf })
--     map("n", "gd", "<cmd>Telescope lsp_definitions<CR>")
--   end,
-- })

-----------gitsigns-------
map("n", "[c", "<cmd>Gitsigns prev_hunk<CR>")
map("n", "]c", "<cmd>Gitsigns next_hunk<CR>")
