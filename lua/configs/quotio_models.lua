-- Quotio Local proxy model list with Anthropic API pricing (input/output per 1M tokens).
-- Single source of truth used by codecompanion.lua and any future callers.
local M = {}

M.models = {
  { id = "claude/claude-sonnet-4-6",         name = "Claude Sonnet 4.6 ($3/$15 per 1M)" },
  { id = "claude/claude-opus-4-8",            name = "Claude Opus 4.8 ($5/$25 per 1M)" },
  { id = "claude/claude-opus-4-7",            name = "Claude Opus 4.7 ($5/$25 per 1M)" },
  { id = "claude/claude-haiku-4-5-20251001",  name = "Claude Haiku 4.5 ($1/$5 per 1M)" },
  { id = "claude/claude-sonnet-4-5-20250929", name = "Claude Sonnet 4.5 ($3/$15 per 1M)" },
  { id = "claude/claude-opus-4-6",            name = "Claude Opus 4.6 ($5/$25 per 1M)" },
  { id = "claude/claude-opus-4-5-20251101",   name = "Claude Opus 4.5 ($5/$25 per 1M)" },
  { id = "claude/claude-opus-4-1-20250805",   name = "Claude Opus 4.1 ($5/$25 per 1M)" },
}

-- Flat list of model IDs — use as `choices` in codecompanion enum schemas.
M.ids = vim.tbl_map(function(m) return m.id end, M.models)

return M
