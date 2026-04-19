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
  - Uses `v_an` and `v_in` (default mappings) for LSP-aware selection. No extra configuration required.
- **Enhanced Defaults**: 
  - Includes default mappings for common LSP actions: `gra` (actions), `grn` (rename), `grr` (references), etc.

## Plugins Included

- **[Snacks.nvim](https://github.com/folke/snacks.nvim)**: A collection of high-quality tools for:
  - **Picker**: Ultra-fast fuzzy finder.
  - **Explorer**: Built-in file management.
  - **Notifier**: Modern notification system.
  - **Dashboard**: Minimalist and fast startup screen.
- **Tokyo Night Moon**: High-contrast, easy-on-the-eyes colorscheme.
- **Which-key**: Modern keybinding documentation.
- **Tree-sitter**: Advanced syntax highlighting and code analysis.

## Development Stack

- **Vue 3**: Configured with `volar` 2.x in hybrid mode.
- **TypeScript**: Configured with `vtsls` for superior performance and features (inlay hints, workspace symbols).

## Usage

1. **Install Neovim 0.12**.
2. **Clone this repository** into `~/.config/nvim`.
3. **Launch Neovim**: It will automatically install missing plugins.
4. **Language Servers**: Ensure `vtsls` and `@vue/language-server` are installed on your system (via npm).

---

## How-to: Adding New Language Capabilities

To add support for a new language (e.g., Python, Go, Rust), follow these steps:

### 1. Install the Language Server
Install the required language server on your system using your preferred package manager.

| Language | Server | Installation Command |
| :--- | :--- | :--- |
| **Lua** | `lua-language-server` | `brew install lua-language-server` |
| **TypeScript** | `@vtsls/language-server` | `npm install -g @vtsls/language-server` |
| **Vue** | `@vue/language-server` | `npm install -g @vue/language-server @vue/typescript-plugin` |
| **C** | `clangd` | `brew install llvm` |
| **Rust** | `rust-analyzer` | `rustup component add rust-analyzer` |
| **Zig** | `zls` | `brew install zls` |
| **Ruby** | `ruby-lsp` | `gem install ruby-lsp` |
| **Go** | `gopls` | `go install golang.org/x/tools/gopls@latest` |

### 2. Configure the Server
Open `lua/plugins/lsp.lua` and add a configuration for the new server using `vim.lsp.config`. This is where you define settings and filetypes.

```lua
-- Example for Python (Pyright)
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        typeCheckingMode = "basic",
      },
    },
  },
  filetypes = { "python" },
})
```

### 3. Enable the Server
At the bottom of `lua/plugins/lsp.lua`, enable the server so Neovim knows to start it for the matching filetypes.

```lua
vim.lsp.enable("pyright")
```

### 4. Add Tree-sitter Support
Open `lua/plugins/init.lua` and add the language to the `ensure_installed` list in the Treesitter setup.

```lua
-- lua/plugins/init.lua
require("nvim-treesitter").setup({
  ensure_installed = { 
    "lua", "typescript", "javascript", "vue", "html", "css",
    "python", -- Add your new language here
  },
  highlight = { enable = true },
})
```

### 5. Restart Neovim
Restart Neovim and run `:TSUpdate` (or it will trigger automatically if configured) to install the new Tree-sitter parser.
