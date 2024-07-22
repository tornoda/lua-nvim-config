local api = vim.api

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

M.get_split_args = function(args_str)
  return vim.fn.split(args_str, " ")
end

M.get_buffers = function(options)
  local buffers = {}
  local len = 0
  local options_listed = options.listed
  local vim_fn = vim.fn
  local buflisted = vim_fn.buflisted

  for buffer = 1, vim_fn.bufnr "$" do
    if not options_listed or buflisted(buffer) ~= 1 then
      len = len + 1
      buffers[len] = buffer
    end
  end

  return buffers
end

M.log = function(value)
  print(vim.inspect(value))
end

M.get_current_word = function()
  local mode = vim.fn.mode()

  if mode == "n" then
    return vim.fn.expand "<cword>"
  end

  if mode == "v" then
    -- local saved_reg = vim.fn.getreg "v"
    vim.cmd [[noautocmd sil norm! "vy]]
    -- set to register v
    local sele = vim.fn.getreg "v"
    -- vim.fn.setreg("v", saved_reg)
    return sele
  end

  return ""
end

return M
