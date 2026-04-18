# Neovim 0.12 Modern Configuration

This configuration is optimized for **Neovim 0.12+**, leveraging the latest native features to reduce reliance on third-party plugin managers and complex LSP wrappers.

## Core Features (0.12 Native)

- **Native Plugin Management (`vim.pack`)**: 
  - Plugins are managed directly by Neovim's built-in Lua API.
  - Automatically handles installation and lockfile generation (`nvim-pack-lock.json`).
- **Native LSP Management (`vim.lsp.config`)**: 
  - Server configurations are defined using the new `vim.lsp.config` API.
  - Automatic attaching using `vim.lsp.enable`.
- **Native Auto-completion**: 
  - Enabled via `vim.o.autocomplete = true`.
  - Provides a non-blocking, modern completion experience without `nvim-cmp`.
- **Native Incremental Selection**: 
  - Uses `v_an` and `v_in` (default mappings) for LSP-aware selection.
- **Enhanced Defaults**: 
  - Includes default mappings for common LSP actions: `gra` (actions), `grn` (rename), `grr` (references), etc.

## Plugins Included

- **[Snacks.nvim](https://github.com/folke/snacks.nvim)**: A collection of high-quality tools for:
  - **Picker**: Ultra-fast fuzzy finder.
  - **Explorer**: Built-in file management.
  - **Notifier**: Modern notification system.
  - **Dashboard**: Minimalist and fast startup screen.
  - **Bigfile / Indent / Scroll / Zen**: Core UI improvements.
- **Tokyo Night Moon**: High-contrast, easy-on-the-eyes colorscheme.
- **Tree-sitter**: Advanced syntax highlighting and code analysis.

## Development Stack

- **Vue 3**: Configured with `volar` 2.x in hybrid mode.
- **TypeScript**: Configured with `vtsls` for superior performance and features (inlay hints, workspace symbols).

## Usage

1. **Install Neovim 0.12**.
2. **Clone this repository** into `~/.config/nvim`.
3. **Launch Neovim**: It will automatically prompt to install missing plugins.
4. **Language Servers**: Ensure `vtsls` and `@vue/language-server` are installed on your system (via npm).
