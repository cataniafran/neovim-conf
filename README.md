# Neovim 0.12 Modern Configuration

This configuration is optimized for **Neovim 0.12+**, leveraging the latest native features to reduce reliance on third-party plugin managers and complex LSP wrappers.

## Core Features (0.12 Native)

- **Native Plugin Management (`vim.pack`)**: 
  - Plugins are managed directly by Neovim's built-in Lua API.
  - Automatically handles installation and lockfile generation (`nvim-pack-lock.json`).
- **Native LSP Management (`vim.lsp.config`)**: 
  - Server configurations are defined using the new `vim.lsp.config` API.
  - Automatic attaching using `vim.lsp.enable` with `autotrigger` support.
- **Native Auto-completion (`vim.o.autocomplete`)**: 
  - Enabled via `vim.o.autocomplete = true`.
  - Optimized `completeopt` (menu, menuone, noselect).
  - **AstroNvim Style Mappings**:
    - `<CR>` (Enter): Confirm completion.
    - `<Tab>` / `<S-Tab>`: Cycle completion items or jump through snippet placeholders.
- **Native Incremental Selection**: 
  - Uses `v_an` and `v_in` (default mappings) for LSP-aware selection. No extra configuration required.
- **Native Snippets**: Powered by the new `vim.snippet` API.
- **Enhanced Defaults**: 
  - Includes default mappings for common LSP actions: `gra` (actions), `grn` (rename), `grr` (references), etc.

## Plugins Included

- **[Snacks.nvim](https://github.com/folke/snacks.nvim)**: A collection of high-quality tools for:
  - **Picker**: Ultra-fast fuzzy finder (`<leader>ff`, `<leader>fw`).
  - **Explorer**: Built-in file management (`<leader>e`).
  - **Notifier**: Modern notification system.
  - **Dashboard**: Minimalist and fast startup screen.
  - **Scroll**: Smooth, snappier scrolling with `outQuint` easing.
  - **LazyGit**: Integrated git client (`<leader>gg`).
- **Tokyo Night Moon**: High-contrast colorscheme.
- **Which-key**: Modern keybinding documentation.
- **Mini.icons**: Consistent icon support across the UI.
- **Tree-sitter**: Advanced syntax highlighting for 10+ languages.

## Development Stack

- **Vue 3**: Modern **Hybrid Mode** setup using `vue_ls` and `vtsls`.
- **TypeScript**: Optimized `vtsls` server with inlay hints and Vue plugin support.
- **Multi-Language**: Built-in support for Lua, C/C++, Rust, Zig, Ruby, and Go.

---

## Installation Guide

### 1. Prerequisites
- **Neovim 0.12.0+**
- **Git**
- **NPM** (for many language servers)

### 2. Setup
```bash
git clone <repository_url> ~/.config/nvim
nvim # Plugins will install automatically on first launch
```

### 3. Required External Tools (Manual Install)
To support all features, install the following tools on your system. Using **pnpm** is recommended.

#### Essential CLI Tools
```bash
# Core requirements for Treesitter and UI
pnpm add -g tree-sitter-cli
brew install ripgrep fd # Recommended for Snacks.picker
brew install lazygit    # For <leader>gg
```

#### Language Servers & Plugins
| Language | Tool / Server | Installation Command |
| :--- | :--- | :--- |
| **Lua** | `lua-language-server` | `brew install lua-language-server` |
| **TypeScript** | `@vtsls/language-server` | `pnpm add -g @vtsls/language-server` |
| **Vue 3** | `vue-language-server` | `pnpm add -g @vue/language-server @vue/typescript-plugin` |
| **C / C++** | `clangd` | `brew install llvm` |
| **Rust** | `rust-analyzer` | `rustup component add rust-analyzer` |
| **Zig** | `zls` | `brew install zls` |
| **Ruby** | `ruby-lsp` | `gem install ruby-lsp` |
| **Go** | `gopls` | `go install golang.org/x/tools/gopls@latest` |
| **Oxc** | `oxlint` / `oxfmt` | `pnpm add -g oxlint oxfmt` |

#### Optional Snacks.nvim Extras
```bash
brew install imagemagick      # For image previews
brew install ghostscript      # For PDF previews
pnpm add -g @mermaid-js/mermaid-cli # For Mermaid diagrams
```

---

## How-to: Adding New Language Capabilities

1.  **Install the Server**: Use the table above or your system package manager.
2.  **Configure in `lua/plugins/lsp.lua`**:
    ```lua
    vim.lsp.config("your_server", { filetypes = { "your_filetype" } })
    ```
3.  **Enable the Server**: 
    Add `vim.lsp.enable("your_server")` at the bottom of `lua/plugins/lsp.lua`.
4.  **Add Tree-sitter**: 
    Add the language to the `ensure_installed` list in `lua/plugins/init.lua`.
