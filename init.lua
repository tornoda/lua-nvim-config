vim.g.mapleader = ";"
if vim.g.vscode then
  require "mappings-vscode"
else
  require "neovide"

  -- bootstrap lazy and all plugins
  local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local repo = "https://github.com/folke/lazy.nvim.git"
    vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
  end

  vim.opt.rtp:prepend(lazypath)

  local lazy_config = require "configs.lazy"

  -- load plugins
  require("lazy").setup({
    -- loading lua/plugins
    { import = "plugins" },
  }, lazy_config)

  -- Load core options synchronously to avoid marking initial buffer as modified
  require "options"

  -- 异步加载非关键模块，提升启动速度
  vim.schedule(function()
    require "keymaps"  -- Load unified keymaps (includes all mappings)
  end)

  -- 延迟加载其他模块，避免阻塞启动
  vim.defer_fn(function()
    require "autocmds"
    require "cmds"
  end, 100)
end
