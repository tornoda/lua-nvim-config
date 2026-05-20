return {
  "akinsho/toggleterm.nvim",
  version = "*",
  lazy = false,
  opts = {
    size = function(term)
      if term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.2)
      end

      return math.floor(vim.o.lines * 0.3)
    end,
    open_mapping = nil,
    direction = "horizontal",
    shade_terminals = false,
    float_opts = {
      border = "single",
      width = function()
        return math.floor(vim.o.columns * 0.5)
      end,
      height = function()
        return math.floor(vim.o.lines * 0.4)
      end,
    },
  },
}
