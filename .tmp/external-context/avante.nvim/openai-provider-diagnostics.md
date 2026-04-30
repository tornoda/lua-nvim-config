---
source: Context7 API
library: Avante.nvim
package: avante.nvim
topic: openai provider diagnostics
fetched: 2026-04-12T00:00:00Z
official_docs: https://github.com/yetone/avante.nvim/blob/main/README.md
---

## Most relevant findings

### Core setup
```lua
require("avante").setup({
  provider = "openai",
  mode = "agentic", -- or "legacy"
  providers = {
    openai = {
      endpoint = "https://api.openai.com/v1",
      model = "gpt-4o",
      timeout = 30000,
      extra_request_body = {
        temperature = 0.7,
        max_tokens = 2048,
      },
    },
  },
})
```

### Supported provider types
- Built-ins: `claude`, `openai`, `azure`, `gemini`, `vertex`, `cohere`, `copilot`, `bedrock`, `ollama`, `custom`
- ACP providers: `gemini-cli`, `claude-code`, `goose`, `codex`, `kimi-cli`

### Required keys / env vars
- OpenAI: `OPENAI_API_KEY` (legacy/global)
- Recommended scoped key: `AVANTE_OPENAI_API_KEY`
- OpenAI-compatible custom providers: set `api_key_name`, plus `endpoint` and `model`

Example custom provider:
```lua
providers = {
  openrouter = {
    __inherited_from = "openai",
    endpoint = "https://openrouter.ai/api/v1",
    api_key_name = "OPENROUTER_API_KEY",
    model = "deepseek/deepseek-r1",
  },
}
```

### Multiple providers
```lua
providers = {
  openai = { endpoint = "https://api.openai.com/v1", model = "gpt-4o" },
  ollama = { endpoint = "http://127.0.0.1:11434", model = "llama3.1" },
  groq = {
    __inherited_from = "openai",
    api_key_name = "GROQ_API_KEY",
    endpoint = "https://api.groq.com/openai/v1/",
    model = "llama-3.3-70b-versatile",
    disable_tools = true,
  },
}
```

Switch at runtime:
```lua
require("avante.api").switch_provider("openai")
```

### Migration note
- Provider definitions and request-body options should live under `opts.providers`.
- `extra_request_body` is the current place for per-provider generation settings.
- Older config snippets may still use global API-key env vars, but scoped `AVANTE_*` vars are recommended.

### Likely failure modes when `provider = "openai"`
- Missing `OPENAI_API_KEY` / `AVANTE_OPENAI_API_KEY` → auth/runtime failure.
- Wrong provider name or missing `providers.openai` entry → startup/config error.
- Using an OpenAI-compatible endpoint without `endpoint` or `model` → invalid provider config.
- Using ACP providers like `codex`/`claude-code` without the CLI/package installed → startup/runtime failure.
- Keeping old provider layout after migration → config ignored or partially applied.

### Practical diagnosis checklist
1. Confirm `provider = "openai"` matches a `providers.openai` entry.
2. Confirm the matching API key env var is exported in the shell that launches Neovim.
3. If using a compatible proxy, set `endpoint`, `model`, and `api_key_name` explicitly.
4. If switching between providers, verify the target is declared in `providers` or `acp_providers`.
