return {
  "3rd/diagram.nvim",
  dependencies = {
    {
      "3rd/image.nvim",
      opts = {
        backend = "kitty",
        kitty_method = "normal",
        processor = "magick_cli",
      },
    },
  },
  cond = function()
    return vim.fn.executable("mmdc") == 1
  end,
  ft = { "markdown", "norg" },
  config = function()
    require("diagram").setup({
      integrations = {
        require("diagram.integrations.markdown"),
      },
      renderer_options = {
        mermaid = {
          background = nil,
          theme = nil,
          scale = 1,
        },
      },
    })
  end,
}
