local function set_mapping()
  local map = vim.keymap.set
  map("n", "<leader>th", function()
    require("nvchad.themes").open()
  end, { desc = "Nvchad themes" })
end
return {
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },
  {
    "nvchad/base46",
    lazy = false,
    build = function()
      require("base46").load_all_highlights()
    end,
    config = function()
      set_mapping()
    end,
  },
  "nvchad/volt",
}
