local api = vim.api
local fn = vim.fn

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

M.get_color = function(group, attr)
  return fn.synIDattr(fn.synIDtrans(fn.hlID(group)), attr)
end

M.harmonySetup = function(setup)
  if vim.g.vscode then
    -- VSCode extension
  else
    -- ordinary Neovim
    setup()
  end
end

M.isVsCode = function()
  return vim.g.vscode
end

-- Get selected text in visual mode
M.get_visual_selection = function()
  -- Yank to temporary register
  vim.cmd [[noautocmd sil norm! "vy]]
  local text = vim.fn.getreg "v"
  return text
end

-- Generate coordinates string for line selection (path:startLine:endLine)
M.get_selection_coordinates = function()
  local mode = vim.fn.mode()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Get relative path to workspace
  local cwd = vim.fn.getcwd()
  local rel_path = filepath
  if filepath:sub(1, #cwd) == cwd then
    rel_path = filepath:sub(#cwd + 2) -- +2 to skip the trailing slash
  end

  local start_line, end_line

  if mode == "v" or mode == "V" or mode == "\22" then -- visual modes
    -- Get visual selection range
    local start_pos = vim.fn.getpos("v")
    local end_pos = vim.fn.getpos(".")
    start_line = math.min(start_pos[2], end_pos[2])
    end_line = math.max(start_pos[2], end_pos[2])
  else
    -- Normal mode: use current line as both start and end
    local cursor = vim.api.nvim_win_get_cursor(0)
    start_line = cursor[1]
    end_line = cursor[1]
  end

  return string.format("%s:%d:%d", rel_path, start_line, end_line)
end

return M
