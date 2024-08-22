local func = require "func"
local autocmd = vim.api.nvim_create_autocmd
local utils = require "utils"

autocmd({ "FileType", "BufWinEnter" }, {
  callback = function()
    local cur_type = vim.bo.filetype
    local filetypes = { "typescript", "typescriptreact", "react", "css", "sass", "scss", "lua" }

    local has_filetype = false
    for i = 0, #filetypes do
      if filetypes[i] == cur_type then
        has_filetype = true
      end
    end

    if has_filetype then
      vim.opt_local.foldmethod = "indent"
    end
  end,
})

vim.api.nvim_create_autocmd("BufRead", {
  callback = function(ev)
    if vim.bo[ev.buf].buftype == "quickfix" then
      vim.schedule(function()
        vim.cmd [[cclose]]
        vim.cmd [[Trouble qflist open]]
      end)
    end
  end,
})
-- autocmd("BufWinEnter", {
--   pattern = "quickfix",
--   -- https://github.com/folke/trouble.nvim/issues/70
--   callback = function()
--     local buftype = "quickfix"
--     if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
--       buftype = "loclist"
--     end
--
--     local ok, trouble = pcall(require, "trouble")
--     -- local ok, telescope_builtin = pcall(require, "telescope.builtin")
--     if ok then
--       vim.defer_fn(function()
--         vim.cmd "cclose"
--         -- telescope_builtin.quickfix()
--
--         trouble.open(buftype)
--         trouble.focus()
--       end, 0)
--     else
--       local set = vim.opt_local
--       set.colorcolumn = ""
--       set.number = false
--       set.relativenumber = false
--       set.signcolumn = "no"
--     end
--   end,
-- })

-- autocmd({ "FileType", "BufWinEnter", "BufEnter" }, {
--   callback = function()
--     local ret = vim.bo.filetype
--     if string.find(ret, "Diffview") ~= nil then
--       func.setColor()
--     end
--   end,
-- })

-- autocmd({ "BufEnter", "BufLeave" }, {
--   callback = function()
--     local is_trouble_open = require("trouble").is_open()
--     local filetype = vim.bo.filetype
--
--     if is_trouble_open and filetype == "trouble" then
--       -- vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bold = true, reverse = true })
--       vim.api.nvim_set_hl(0, "CursorLine", { link = "DiffChange" })
--     else
--       vim.api.nvim_set_hl(0, "CursorLine", { underline = false, bold = false, reverse = false })
--     end
--   end,
-- })

autocmd("BufHidden", {
  callback = function()
    local is_trouble_open = require("trouble").is_open()
  end,
})

-- autocmd("CursorHold", {
--   callback = function()
--     local function set_underline()
--       -- vim.api.nvim_command "Gitsigns blame_line"
--       local curWord = utils.get_current_word()
--       local cmd_str = "match Underlined /\\<" .. curWord .. "\\>/"
--       vim.api.nvim_command(cmd_str)
--     end
--
--     vim.defer_fn(set_underline, 0)
--   end,
-- })
