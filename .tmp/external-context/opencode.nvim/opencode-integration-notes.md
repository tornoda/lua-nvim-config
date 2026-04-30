---
source: official docs
library: opencode.nvim
package: opencode.nvim
topic: integration notes for avante/opencode
fetched: 2026-04-12T00:00:00Z
official_docs: https://github.com/nickjvandyke/opencode.nvim/blob/main/README.md
---

## Relevant points

- `opencode.nvim` connects to an `opencode` process or starts one itself.
- It requires the `opencode` server to run with `--port`.
- It exposes prompts, commands, events, edits, and an experimental in-process LSP.
- The docs do **not** mention avante.nvim or ACP bridging.

## Minimal setup

```lua
{
  "nickjvandyke/opencode.nvim",
  version = "*",
  dependencies = {
    { "folke/snacks.nvim", optional = true },
  },
  config = function()
    vim.g.opencode_opts = {}
  end,
}
```

## Integration takeaway

- No official avante↔OpenCode adapter is documented.
- The only documented path that might fit OpenCode is if it provides an OpenAI-compatible endpoint or a CLI compatible with an ACP provider wrapper.
