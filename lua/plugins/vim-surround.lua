return {
  "tpope/vim-surround",
  event = "BufEnter", -- 在lazy.vim下这个必需加上
  config = function()
    vim.g.surround_115 = "**\r**" -- 115 is the ASCII code for 's'
    vim.g.surround_47 = "/* \r */" -- 47 is /
  end,
}
