local M = {}

M.setColor = function()
  local themeName = dofile("lua/chadrc.lua").ui.theme

  if string.find(themeName, "light") ~= nil then
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#d7eed8", fg = nil })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#ffbebe" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#a6daa9", fg = nil })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#def1df", fg = nil })
  else
    vim.api.nvim_set_hl(0, "DiffChange", { link = "DiffAdd" })
    -- vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#295337", fg = nil })
    -- vim.api.nvim_set_hl(0, "DiffDelete", { bg = "brown", fg = "brown" })
    -- vim.api.nvim_set_hl(0, "DiffText", { bg = "#157d38", fg = nil })
    -- vim.api.nvim_set_hl(0, "DiffChange", { bg = "#295337" })

    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#002716", fg = nil })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#001F12" })
  end

  --  require("gitsigns").refresh()
  -- print(
  --   ("A new %s was opened on tab page %d!")
end

return M
