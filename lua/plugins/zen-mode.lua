return {
  "folke/zen-mode.nvim",
  cmd = { "ZenMode" },
  opts = {
    window = {
      width = 150,
      options = {
        number = true,
        relativenumber = false,
        wrap = true,
        linebreak = true,
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      twilight = { enabled = false },
      gitsigns = { enabled = false },
      tmux = { enabled = false },
      kitty = { enabled = false },
    },
  },
}
