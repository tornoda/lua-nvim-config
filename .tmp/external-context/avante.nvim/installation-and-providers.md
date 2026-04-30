---
source: Context7 API + official docs
library: avante.nvim
package: avante.nvim
topic: installation, dependencies, build, ACP, providers
fetched: 2026-04-12T00:00:00Z
official_docs: https://github.com/yetone/avante.nvim/blob/main/README.md
---

## Neovim / version constraints

- Requires Neovim `0.10.1+`.
- In `lazy.nvim`, do **not** set `version = "*"`; the docs say `version = false`.

## lazy.nvim install

```lua
{
  "yetone/avante.nvim",
  build = vim.fn.has("win32") ~= 0
    and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  version = false,
  opts = {
    instructions_file = "avante.md",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- or mini.icons
    "stevearc/dressing.nvim",      -- optional input UI
    "folke/snacks.nvim",           -- optional input UI
    "hrsh7th/nvim-cmp",            -- optional completions
    "nvim-telescope/telescope.nvim", -- optional file selector
    "ibhagwan/fzf-lua",            -- optional file selector
    { "HakonHarnes/img-clip.nvim", event = "VeryLazy" },
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "Avante" } },
  },
}
```

## Build / dependency notes

- Default install uses prebuilt binaries (via `curl` + `tar`), if available.
- Building from source requires `cargo`.
- Docs show `make BUILD_FROM_SOURCE=true` for source builds.
- On Windows the build command is `Build.ps1 -BuildFromSource false`.

## ACP support

Avante supports ACP providers via `acp_providers`:

```lua
require("avante").setup({
  provider = "claude-code",
  acp_providers = {
    ["claude-code"] = {
      command = "npx",
      args = { "@zed-industries/claude-code-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_API_KEY"),
      },
    },
    ["gemini-cli"] = {
      command = "gemini",
      args = { "--experimental-acp" },
      env = {
        NODE_NO_WARNINGS = "1",
        GEMINI_API_KEY = os.getenv("GEMINI_API_KEY"),
      },
    },
    ["goose"] = { command = "goose", args = { "acp" } },
    ["codex"] = {
      command = "codex-acp",
      env = {
        NODE_NO_WARNINGS = "1",
        OPENAI_API_KEY = os.getenv("OPENAI_API_KEY"),
      },
    },
  },
})
```

## Custom providers / OpenAI-compatible endpoints

Use `providers.<name>` and inherit from `openai` for OpenAI-compatible APIs:

```lua
require("avante").setup({
  provider = "openrouter",
  providers = {
    openrouter = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      api_key_name = "OPENROUTER_API_KEY",
      model = "deepseek/deepseek-r1",
    },
  },
})
```

Custom-provider contract:

- `endpoint` (full URL)
- `model`
- `api_key_name`
- optional `parse_curl_args`, `parse_response`, `parse_stream_data`

## Minimal working setup

```lua
require("avante").setup({
  provider = "openrouter",
  mode = "agentic",
  instructions_file = "avante.md",
  providers = {
    openrouter = {
      __inherited_from = "openai",
      endpoint = "https://openrouter.ai/api/v1",
      api_key_name = "OPENROUTER_API_KEY",
      model = "deepseek/deepseek-r1",
    },
  },
})
```

## What’s uncertain for OpenCode

- The avante docs do **not** document a direct OpenCode integration.
- If OpenCode exposes an OpenAI-compatible HTTP API, the documented `openai`-inherited custom provider pattern is the cleanest fit.
- If OpenCode only exposes its own CLI/TUI/server, avante does not document a native adapter.
