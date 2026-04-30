local function set_command()
  -- Create command to open NvChad theme selector
  vim.api.nvim_create_user_command("Themes", function()
    require("nvchad.themes").open()
  end, { desc = "Open NvChad theme selector" })
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
      set_command()
    end,
  },
  "nvchad/volt",
}
