require "neovide"

vim.g.mapleader = ";"
vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  -- loading lua/plugins
  { import = "plugins" },
}, lazy_config)

-- (method 2, for non lazyloaders) to load all highlights at once
-- for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
--   dofile(vim.g.base46_cache .. v)
-- end

-- -- load theme
-- dofile(vim.g.base46_cache .. "syntax")
-- dofile(vim.g.base46_cache .. "defaults")
-- -- print("vim.g.base46_cache" .. vim.g.base46_cache)
-- dofile(vim.g.base46_cache .. "statusline")
--
--
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
end

-- require "nvchad.autocmds"

vim.schedule(function()
  require "options"
  require "mappings"
  require "autocmds"
end)
