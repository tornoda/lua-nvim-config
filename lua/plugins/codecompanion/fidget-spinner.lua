-- Fidget spinner integration for CodeCompanion (v19+).
-- Bridges User CodeCompanionRequest* autocmds to fidget.progress handles
-- so chat / inline / cmd requests show a progress indicator.
--
-- v19 note: event payload uses `data.interaction` (was `data.strategy` in v18).
local progress = require("fidget.progress")

local M = {
  handles = {},
}

---Build a display title from the adapter (model formatted_name preferred).
---@param adapter table
---@return string
function M:llm_role_title(adapter)
  local model = ""
  if adapter and adapter.model then
    model = adapter.model.formatted_name or adapter.model.name or ""
  end
  local name = (adapter and (adapter.formatted_name or adapter.name)) or "LLM"
  if model ~= "" then
    return name .. " (" .. model .. ")"
  end
  return name
end

function M:init()
  local group = vim.api.nvim_create_augroup("CodeCompanionFidgetHooks", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestStarted",
    group = group,
    callback = function(request)
      local data = request.data or {}
      local id = data.id
      if not id then return end

      M.handles[id] = progress.handle.create({
        title = " Requesting assistance (" .. (data.interaction or "unknown") .. ")",
        message = "In progress...",
        lsp_client = { name = M:llm_role_title(data.adapter) },
      })
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = "CodeCompanionRequestFinished",
    group = group,
    callback = function(request)
      local data = request.data or {}
      local id = data.id
      if not id then return end

      local handle = M.handles[id]
      M.handles[id] = nil
      if not handle then return end

      if data.status == "success" then
        handle.message = "Completed"
      elseif data.status == "error" then
        handle.message = " Error"
      else
        handle.message = "󰜺 Cancelled"
      end
      handle:finish()
    end,
  })
end

return M
