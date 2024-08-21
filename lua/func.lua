local M = {}

-- vim.ui.select({ "tabs", "spaces" }, {
--   prompt = "Select tabs or spaces:",
--   format_item = function(item)
--     return "I'd like to choose " .. item
--   end,
-- }, function(choice)
--   if choice == "spaces" then
--     vim.o.expandtab = true
--   else
--     vim.o.expandtab = false
--   end
-- end)

-- Make it better to use. see: https://github.com/sindrets/diffview.nvim/issues/241
M.setColor = function()
  local themeName = dofile("lua/chadrc.lua").ui.theme

  if string.find(themeName, "light") ~= nil then
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#d7eed8", fg = nil })
    vim.api.nvim_set_hl(0, "DiffDelete", { fg = "#ffbebe" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#a6daa9", fg = nil })
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#def1df", fg = nil })
  else
    vim.api.nvim_set_hl(0, "DiffChange", { link = "DiffAdd" })
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3b643b", fg = nil })
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = nil, fg = "#c7ae95" })
    vim.api.nvim_set_hl(0, "DiffText", { bg = "#457947", fg = nil })
  end

  --  require("gitsigns").refresh()
  -- print(
  --   ("A new %s was opened on tab page %d!")
end

M.getLineHeadIndex = function()
  local first = 1

  local line = vim.fn.getline "."
  local len = string.len(line)

  for i = 1, len do
    local cur = string.sub(line, i, i)
    print("i" .. i .. cur)
    if cur == " " then
      first = first + 1
    else
      break
    end
  end

  return {
    p0 = first,
  }
end

M.getLineHeadIndex()

return M
