local function apply_markdown_highlights()
  local highlights = {
    ["@markup.heading.1.markdown"] = { fg = "#7fdbca", bold = true },
    ["@markup.heading.2.markdown"] = { fg = "#9fd4ff", bold = true },
    ["@markup.heading.3.markdown"] = { fg = "#9fd54d", bold = true },
    ["@markup.heading.4.markdown"] = { fg = "#ecc48d", bold = true },
    ["@markup.heading.5.markdown"] = { fg = "#FD98B9", bold = true },
    ["@markup.heading.6.markdown"] = { fg = "#acafb9", italic = true },
    RenderMarkdownH1Bg = { fg = "#7fdbca", bold = true, reverse = true },
    RenderMarkdownH2Bg = { fg = "#9fd4ff", bold = true, reverse = true },
    RenderMarkdownH3Bg = { fg = "#9fd54d", bold = true, reverse = true },
    RenderMarkdownH4Bg = { fg = "#ecc48d", bold = true, reverse = true },
    RenderMarkdownH5Bg = { fg = "#FD98B9", bold = true, reverse = true },
    RenderMarkdownH6Bg = { fg = "#acafb9", italic = true, reverse = true },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("themes").apply_saved "tokyonight-moon"
      apply_markdown_highlights()

      vim.api.nvim_create_user_command("Themes", function()
        require("themes").picker()
      end, { desc = "Open local theme picker" })

      vim.api.nvim_create_user_command("ThemePicker", function()
        require("themes").picker()
      end, { desc = "Open local theme picker" })

      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("LocalMarkdownHighlights", { clear = true }),
        callback = apply_markdown_highlights,
      })
    end,
  },
  { "catppuccin/nvim", name = "catppuccin", lazy = true },
  { "rebelot/kanagawa.nvim", lazy = true },
  { "rose-pine/neovim", name = "rose-pine", lazy = true },
  { "EdenEast/nightfox.nvim", lazy = true },
  { "Mofiqul/dracula.nvim", lazy = true },
  { "olimorris/onedarkpro.nvim", lazy = true },
}
