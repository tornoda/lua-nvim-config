return {
  "aznhe21/actions-preview.nvim",
  enabled = false,
  config = function()
    vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
  end,
}
