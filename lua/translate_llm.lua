-- LLM-backed translation through the local Quotio (OpenAI-compatible) endpoint.
-- Normal mode translates the current line; visual mode translates the selection.
-- Direction is auto-detected: Chinese -> English, otherwise -> Simplified Chinese.
local M = {}

local URL = "http://127.0.0.1:8081/v1/chat/completions"
local TOKEN = "quotio-local-EB898030-86CA-4C25-A5E9-FD138FD83C92"
local MODEL = "claude/claude-haiku-4-5-20251001"

-- Heuristic: any CJK ideograph (UTF-8 lead byte E4..E9) means the source is Chinese.
local function is_chinese(text)
  return text:find "[\228-\233][\128-\191][\128-\191]" ~= nil
end

local function get_source_text()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    local ok, sel = pcall(require("utils").get_visual_selection)
    if ok and sel and sel ~= "" then
      return sel
    end
  end
  return vim.api.nvim_get_current_line()
end

local function show_float(lines)
  vim.lsp.util.open_floating_preview(lines, "markdown", {
    border = "single",
    focusable = true,
    focus = false,
    wrap = true,
    max_width = 80,
  })
end

function M.translate()
  local text = vim.trim(get_source_text() or "")
  if text == "" then
    vim.notify("Translate: nothing to translate", vim.log.levels.WARN)
    return
  end

  local target = is_chinese(text) and "English" or "Simplified Chinese"
  -- The local Quotio proxy is backed by the Claude Code agent, which injects its
  -- own system prompt and ignores a custom `system` role. Carry the instruction
  -- inside the user message instead so it is reliably followed.
  local prompt = "Translate the following text into "
    .. target
    .. ". Output ONLY the translated text, with no quotes, no explanations and no extra commentary:\n\n"
    .. text
  local body = vim.json.encode {
    model = MODEL,
    -- Strict determinism is required for this config.
    temperature = 0,
    messages = {
      { role = "user", content = prompt },
    },
  }

  vim.notify("Translating…", vim.log.levels.INFO)

  vim.system({
    "curl", "-s", "--max-time", "30", URL,
    "-H", "Content-Type: application/json",
    "-H", "Authorization: Bearer " .. TOKEN,
    "-d", body,
  }, { text = true }, function(res)
    vim.schedule(function()
      if res.code ~= 0 then
        vim.notify("Translate failed: curl exit " .. res.code .. "\n" .. (res.stderr or ""), vim.log.levels.ERROR)
        return
      end

      local ok, decoded = pcall(vim.json.decode, res.stdout)
      if not ok or type(decoded) ~= "table" then
        vim.notify("Translate failed: invalid response\n" .. (res.stdout or ""), vim.log.levels.ERROR)
        return
      end

      if decoded.error then
        local msg = type(decoded.error) == "table" and decoded.error.message or tostring(decoded.error)
        vim.notify("Translate API error: " .. msg, vim.log.levels.ERROR)
        return
      end

      local content = decoded.choices
        and decoded.choices[1]
        and decoded.choices[1].message
        and decoded.choices[1].message.content
      if not content or content == "" then
        vim.notify("Translate: empty result", vim.log.levels.WARN)
        return
      end

      show_float(vim.split(vim.trim(content), "\n", { trimempty = false }))
    end)
  end)
end

return M
