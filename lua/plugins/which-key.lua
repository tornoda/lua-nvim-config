local opts = {
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20,
    },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  spec = {
    { "gc", group = "Comments" },
    { "gb", group = "Comments" },
  },
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      { "<Space>", "SPC" },
      { "<CR>", "RET" },
      { "<Tab>", "TAB" },
    },
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "left",
  },
  triggers = {
    { "<leader>", mode = { "n", "v" } },
    { "ys", mode = "n" },
    { "yS", mode = "n" },
    { "yss", mode = "n" },
    { "ySs", mode = "n" },
    { "ySS", mode = "n" },
    { "S", mode = "v" },
    { "gS", mode = "v" },
  },
  show_help = true,
}

-- Key groups are now registered in keymaps.lua
-- This ensures better integration between keymap definitions and which-key groups
-- The register_which_key_groups() function in keymaps.lua handles all group registration

return {
  enabled = true,
  "folke/which-key.nvim",
  lazy = false,
  opts = opts,
  config = function(_, config_opts)
    local ok, wk = pcall(require, "which-key")
    if not ok then
      return
    end
    wk.setup(config_opts)
  end,
  -- Export functions for keymaps.lua
  extra = {
    show_all = function()
      vim.cmd "WhichKey"
    end,
    query_lookup = function()
      vim.cmd("WhichKey " .. vim.fn.input "WhichKey: ")
    end,
  },
}
