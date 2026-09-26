# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal Neovim configuration (the `nvim/` subtree of a larger `~/.dotfiles` repo). No build/test pipeline — changes are validated by reloading Neovim. The working directory `~/.dotfiles/nvim` is symlinked (or pointed at) by `~/.config/nvim`.

## Reloading / validating changes

- `:Lazy sync` — install/update plugins after editing anything in `lua/plugins/`.
- `:Lazy reload <plugin>` — reload a single plugin spec without restarting.
- `<leader><leader>x` (custom) — `:source %` the current file.
- `:checkhealth` — sanity check after structural changes.
- For a full validation, restart Neovim — lazy.nvim's plugin loading and `after/ftplugin/*.lua` only run on startup / `FileType` events.

## Architecture

### Entry point and plugin loading
`init.lua` bootstraps lazy.nvim into `stdpath('data')/lazy/lazy.nvim` (auto-clones on first run), then calls `require("lazy").setup("plugins")`. This imports **every** `lua/plugins/*.lua` file as a plugin spec — there is no central manifest. Adding a new plugin means dropping a new file in that directory that `return`s a spec table; no other registration is needed. `lua/plugins/init.lua` is intentionally near-empty (lazy.nvim does the discovery).

### LSP setup is split across three layers
This is the most important thing to understand before touching LSP-related files:

1. **`lua/plugins/mason.lua`** — uses `mason-lspconfig` to *install* server binaries (`gopls`, `lua_ls`, `ts_ls`, `cssls`, `eslint`, `jsonls`, `html`). The `servers` table here only controls what gets installed; it does NOT configure clients.
2. **`lua/lsp/shared.lua`** — exports `M.capabilities` (from `cmp_nvim_lsp`) and `M.on_attach` (defines all `gd`/`gr`/`K`/`<leader>rn`/`<leader>ca`/`<leader>f`/etc. keymaps). Every LSP client config should plug these in.
3. **`after/ftplugin/<lang>.lua`** — actually configures and starts the client per filetype using `vim.lsp.config(...)` + `vim.lsp.enable(...)`. Java is the exception: it uses `nvim-jdtls`'s `jdtls.start_or_attach(config)` directly (do not enable a `jdtls` server via `vim.lsp.enable`).

Consequence: if an LSP keymap is missing, fix `lua/lsp/shared.lua`. If a server isn't starting, check the matching `after/ftplugin/<lang>.lua`. If it's not installed, check `mason.lua`.

### Per-project overrides
`nvim-config-local` (see `lua/plugins/nvim-config-local.lua`) loads `.nvim.lua` / `.nvimrc` / `.exrc` from the cwd on startup. First load requires `:ConfigLocalTrust`. Use this for project-specific settings — don't hardcode project paths into this repo.

### Java specifics (`after/ftplugin/java.lua`)
- Hardcoded to `/opt/homebrew/opt/openjdk@21/bin/java` to *run* JDTLS, with `JavaSE-21` / `JavaSE-17` runtimes also pinned to Homebrew paths.
- JDTLS launcher jar and `config_mac` are discovered under `stdpath('data')/mason/packages/jdtls/`.
- Lombok agent loaded via `mason_path/.../jdtls/lombok.jar`.
- Debug bundle hardcoded to `~/.local/share/nvim/eclipse-debug/org.eclipse.jdt.debug.jar`.
- DAP `Attach to Rasputin` config attaches to `localhost:5005` — keep this name unless updating the project it targets.

### Linting
`lua/plugins/nvim-lint.lua` runs `golangcilint`/`jsonlint`/`yamllint` on `BufReadPost`/`BufWritePost`/`InsertLeave`. Note the **hardcoded golangci-lint config path** at `/Users/daniil/.pyenv/.../ciapp/lint/.golangci.yml` — this is Ingrid-specific and will break linting on a fresh machine.

### Filetype indentation
`init.lua` sets `tabstop=softtabstop=shiftwidth=4` globally with tabs (no `expandtab`). `after/ftplugin/java.lua` overrides to **spaces** (`expandtab=true`). Match the surrounding file's convention when editing.

## Conventions and gotchas

- **Leader is `<Space>`** (both `mapleader` and `maplocalleader`). Insert-mode `<Space>` is unmapped explicitly in `after/plugin/keymaps.lua`.
- **Folds** use `nvim-treesitter#foldexpr()` with `foldlevelstart=99` (all open). Don't switch this to `syntax` casually — many plugin configs assume treesitter folding.
- **Backup directories** `lua.backup/`, `after.backup/`, and `*.backup` files are old configs kept for reference. Do not edit them and do not let them be picked up as new plugins (they aren't — `lazy.nvim` only reads `lua/plugins/`).
- **Duplicate plugin files exist** (`which-key.lua` and `whichkey.lua` both register `folke/which-key.nvim`). lazy.nvim dedupes by repo URL, so this is harmless but worth knowing if you're consolidating.
- **`<C-h/j/k/l>` are bound to `TmuxNavigate*`** (see `after/plugin/keymaps.lua`) — do not rebind to window-movement.
- Spellcheck is **on globally** (`vim.o.spell = true`); custom dictionary lives in `spell/en.utf-8.add`.

## When adding a new language

1. Add the server to the `servers` table in `lua/plugins/mason.lua` (this only installs it).
2. Add treesitter parser to `ensure_installed` in `lua/plugins/treesitter.lua`.
3. Create `after/ftplugin/<lang>.lua` that requires `lsp.shared`, calls `vim.lsp.config(...)` with `capabilities = shared.capabilities, on_attach = shared.on_attach`, then `vim.lsp.enable(...)`.
4. If linting is needed, extend `linters_by_ft` in `lua/plugins/nvim-lint.lua`.
