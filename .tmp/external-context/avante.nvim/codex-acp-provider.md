---
source: Context7 API
library: Avante.nvim
package: avante.nvim
topic: codex acp provider
fetched: 2026-04-12T00:00:00Z
official_docs: https://github.com/yetone/avante.nvim/blob/main/README.md
---

## Relevant docs

### Provider name

- Use `provider = "codex"`.

### `acp_providers.codex` schema

```lua
acp_providers = {
  ["codex"] = {
    command = "codex-acp",
    env = {
      NODE_NO_WARNINGS = "1",
      OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
    },
  },
}
```

### Notes

- Avante’s documented Codex ACP entry only shows `command` and `env`; no `args` are required in the README example.
- `NODE_NO_WARNINGS=1` is included in the docs.

### Likely failure modes

- `provider` not set to `"codex"`.
- `codex-acp` not installed or not on `PATH`.
- Missing `OPENAI_API_KEY` if the adapter cannot use pre-existing Codex auth.
- Using a different provider key than `codex` in `acp_providers`.
