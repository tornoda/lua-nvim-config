-- 定义你的候选项
local options = {
  "git add . && git commit -m ''",
  "git add . && git commit -m 'chore: version change' \n",
  "git checkout -b",
  "git open \n",
  "git rebase --continue \n",
  "npm publish \n",
  "npm publish --tag beta \n",
}

local M = {}

-- 使用 vim.ui.select 创建选择框
M.showSelection = function()
  vim.ui.select(options, { prompt = "Pick a scripts:" }, function(choice)
    if choice then
      -- 将内容写入终端（当前 buffer 必须是 terminal）
      local bufnr = vim.api.nvim_get_current_buf()
      -- 获取 term channel
      local chan_id = vim.b.terminal_job_id
      if chan_id then
        vim.api.nvim_chan_send(chan_id, choice)
      else
        print "当前 buffer 不是一个终端"
      end
    end
  end)
end

return M
