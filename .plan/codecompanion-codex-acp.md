# CodeCompanion Codex ACP Design

## Goal

Use Codex through Agent Client Protocol in CodeCompanion, matching the existing Avante Codex ACP launch path.

## Research Findings

- CodeCompanion v19 has a built-in ACP adapter named `codex`.
- The built-in adapter defaults to the `codex-acp` executable.
- This machine does not currently have `codex-acp` on `PATH`.
- `npx` is available, and the existing Avante config starts Codex ACP with `npx -y @zed-industries/codex-acp`.
- CodeCompanion ACP adapters are supported for chat interactions, not inline/cmd interactions.

## Chosen Approach

Extend CodeCompanion's built-in `codex` ACP adapter and override its default command to:

```lua
{ "npx", "-y", "@zed-industries/codex-acp" }
```

Set CodeCompanion chat's default adapter to `codex`.

## Scope

- Edit only `lua/plugins/codecompanion.lua`.
- Add an `adapters.acp.codex` override using `require("codecompanion.adapters").extend("codex", ...)`.
- Set `interactions.chat.adapter = "codex"`.
- Disable `codecompanion-history.nvim` LLM title generation for ACP chats.
- Set a local static chat title from the first real user prompt when a chat is submitted and no title exists.
- Keep existing chat roles, history extension, display settings, keymaps, and fidget integration unchanged.
- Do not change Avante config.

## Validation

- Run Lua formatting if a formatter is available or keep the edit style consistent manually.
- Run a Neovim headless startup check for the config if feasible.
- Verify the configured history option has `auto_generate_title = false` and the local title hook is installed.
- Optionally run `:checkhealth codecompanion` manually inside Neovim after startup, because full plugin health may depend on runtime UI/plugin loading.

## Risks

- First Codex ACP launch may download via `npx`, so it can be slower and network-dependent.
- Codex authentication still depends on the ACP package's supported auth path, commonly OpenAI API key or ChatGPT/Codex auth.
- First-prompt static titles are intentionally simple and may need manual rename for long or generic prompts.
