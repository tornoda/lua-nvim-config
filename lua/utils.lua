local M = {}

M.table_has = function(table, ele)
  local has = false
  for i = 0, #table do
    if table[i] == ele then
      has = true
    end
  end
  return has
end

M.get_split_args = function (args_str)
  return vim.fn.split(args_str, " ")
end

return M
