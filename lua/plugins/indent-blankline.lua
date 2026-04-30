local function jump_to_scope()
  local ok, scope = pcall(require, "ibl.scope")
  if not ok then
    vim.notify("ibl.scope module not available", vim.log.levels.WARN)
    return
  end

  local config = { scope = {} }
  config.scope.exclude = { language = {}, node_type = {} }
  config.scope.include = { node_type = {} }

  local node = scope.get(vim.api.nvim_get_current_buf(), config)
  if not node then
    return
  end

  local start_row, _, end_row = node:range()
  if start_row == end_row then
    return
  end

  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_cursor(win, { start_row + 1, 0 })
  vim.api.nvim_feedkeys("_", "n", true)
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    indent = {
      char = " ",
      tab_char = " ",
    },
    scope = {
      enabled = false,
      show_start = false,
      show_end = false,
      highlight = "IblScope",
    },
  },
  extra = {
    jump_to_scope = jump_to_scope,
  },
}