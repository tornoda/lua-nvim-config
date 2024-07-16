local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
  callback = function()
    local cur_type = vim.bo.filetype
    local filetypes = { 'typescript', 'typescriptreact', 'react', 'css', 'sass', 'scss' }

    local has_filetype = false
    for i = 0, #filetypes do
      if filetypes[i] == cur_type then
        has_filetype = true
      end
    end

    if has_filetype then
      vim.opt_local.foldmethod = 'indent'
    end
  end
})

-- autocmd("User NvChadThemeReload", {
--   callback = function()
--     setDiffColors()
--   end,
-- })


autocmd('BufWinEnter', {
  pattern = "quickfix",
  callback =
  -- https://github.com/folke/trouble.nvim/issues/70
      function()
        local buftype = "quickfix"
        if vim.fn.getloclist(0, { filewinid = 1 }).filewinid ~= 0 then
          buftype = "loclist"
        end

        local ok, trouble = pcall(require, "trouble")
        -- local ok, telescope_builtin = pcall(require, "telescope.builtin")
        if ok then
          vim.defer_fn(function()
            vim.cmd("cclose")
            -- telescope_builtin.quickfix()

            trouble.open(buftype)
            trouble.focus()
          end, 0)
        else
          local set = vim.opt_local
          set.colorcolumn = ""
          set.number = false
          set.relativenumber = false
          set.signcolumn = "no"
        end
      end
})

-- NvimTree
-- autocmd('BufEnter', {
--   pattern = "NvimTree",
--   callback = function()
--     print('h')
--     vim.api.nvim_create_user_command('Search_under_dir', function()
--       print('hello')
--     end, {})
--   end
-- })
