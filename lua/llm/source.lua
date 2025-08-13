local cmp = require "cmp"
local Job = require "plenary.job"

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.complete = function(self, request, callback)
  local input = table.concat(vim.api.nvim_buf_get_lines(0, 0, request.context.cursor.line, false), "\n")

  Job:new({
    command = "curl",
    args = {
      "-s",
      "-X",
      "POST",
      "http://localhost:11434/api/generate",
      "-d",
      vim.fn.json_encode {
        model = "deepseek-coder",
        prompt = input,
        stream = false,
      },
    },
    on_exit = function(j)
      vim.schedule(function() -- ✅ 确保在主线程
        local output = table.concat(j:result(), "\n")
        local parsed = vim.fn.json_decode(output)
        -- vim.print(parsed)
        callback {
          items = {
            { label = parsed.response, insertText = parsed.response },
          },
          isIncomplete = false,
        }
      end)
    end,
  }):start()
end

source.get_position_encoding_kind = function()
  return "utf-8"
end

return source
