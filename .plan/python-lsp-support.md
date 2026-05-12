# Python LSP Support

## Goal

Add Python language server support to the existing Neovim LSP setup with minimal configuration changes.

## Selected Approach

Use `basedpyright` as the Python LSP server.

## Scope

- Add `basedpyright` to the existing `servers` list in `lua/plugins/nvim-lspconfig.lua`.
- Reuse the current shared LSP `capabilities`, `on_attach`, and `on_init` setup.
- Install the Mason package for `basedpyright`.
- Verify the Neovim config loads in headless mode.

## Non-Goals

- Do not add Ruff linting or formatting yet.
- Do not change completion mappings or global LSP keymaps.
- Do not modify unrelated plugin configuration.

## Verification

- Run a headless Neovim startup check after editing.
- Confirm Mason can install or already has `basedpyright` available.
