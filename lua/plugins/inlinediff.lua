return {
  "YouSame2/inlinediff-nvim",
  cmd = "InlineDiff",
  keys = {
    {
      "<leader>ghp",
      function()
        require("inlinediff").toggle()
      end,
      desc = "Toggle inline diff",
    },
  },
  opts = {},
  config = function(_, opts)
    local inlinediff = require "inlinediff"

    inlinediff.setup(opts)

    local function apply_diff_highlights()
      local links = {
        InlineDiffAddContext = "DiffAdd",
        InlineDiffAddChange = "DiffText",
        InlineDiffDeleteContext = "DiffDelete",
        InlineDiffDeleteChange = "DiffText",
      }

      for group, target in pairs(links) do
        vim.api.nvim_set_hl(0, group, { link = target })
      end
    end

    apply_diff_highlights()

    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("InlineDiffHighlights", { clear = true }),
      callback = apply_diff_highlights,
    })
  end,
}
