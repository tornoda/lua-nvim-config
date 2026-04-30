---
source: Context7 + official repo docs
library: opencode.nvim
package: opencode.nvim
topic: window-layout customization
fetched: 2026-04-14T00:00:00Z
official_docs: https://github.com/NickvanDyke/opencode.nvim/blob/main/README.md
---

## Setup / layout-related options

Current docs expose these top-level opts in `vim.g.opencode_opts` / `require("opencode").setup(...)`:

- `server` — controls where/how the embedded `opencode` terminal runs.
- `ask.snacks.win` — window options for the prompt UI.
- `select.snacks.layout` — picker layout options.
- `lsp.filetypes` — LSP filetypes.

Default terminal layout:

```lua
server = {
  start = function()
    require("opencode.terminal").open("opencode --port", {
      split = "right",
      width = math.floor(vim.o.columns * 0.35),
    })
  end,
  toggle = function()
    require("opencode.terminal").toggle("opencode --port", {
      split = "right",
      width = math.floor(vim.o.columns * 0.35),
    })
  end,
}
```

Default prompt-window opts:

```lua
ask = {
  snacks = {
    win = {
      relative = "cursor",
      row = -3,
      col = 0,
      bo = { filetype = "opencode_ask" },
    },
  },
}
```

## Public UI-opening APIs

- `require("opencode").toggle()` — toggles the TUI window.
- `require("opencode").ask()` — opens the ask prompt.
- `require("opencode").select()` — opens the action picker.
- `require("opencode").prompt(...)` / `command(...)` / `operator(...)` — other public entry points.

Example keymaps from the README:

```lua
vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end)
vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end)
vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end)
```

## Buffer/window naming and filetypes

- Terminal UI: created as a terminal buffer via `nvim_create_buf(...)+jobstart(term=true)`; docs do not advertise a special buffer name.
- Prompt UI: documented filetype is `opencode_ask`.
- No dedicated documented filetype/name for the main terminal UI beyond standard terminal-buffer behavior.

## Dedicated non-floating split support

Yes. The default server terminal opens as a right-side split (`split = "right"`, width-based). The plugin also passes through `snacks.terminal` / `snacks.win` window config, so split layouts are supported.

What is *not* documented: a separate opencode-specific `sidebar`/`floating`/`split` mode switch. Instead, window behavior is driven by the terminal/snacks window opts.

## Official docs

- README: https://github.com/NickvanDyke/opencode.nvim/blob/main/README.md
- Default config: https://raw.githubusercontent.com/NickvanDyke/opencode.nvim/main/lua/opencode/config.lua
- Terminal implementation: https://raw.githubusercontent.com/NickvanDyke/opencode.nvim/main/lua/opencode/terminal.lua
- snacks.nvim window docs: https://github.com/folke/snacks.nvim/blob/main/doc/snacks.nvim-win.txt
