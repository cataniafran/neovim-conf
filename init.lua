-- Neovim 0.12 Configuration
-- This config leverages the latest native features:
-- - `vim.pack` for plugin management
-- - `vim.lsp.config` for LSP management
-- - `vim.o.autocomplete` for native completion

-- 1. Load basic options
require("config.options")

-- 2. Load general keybindings
require("config.keymaps")

-- 3. Load autocommands
require("config.autocmds")

-- 4. Load and manage plugins (using native `vim.pack`)
require("plugins")

-- 5. Set up LSP (using native `vim.lsp.config`)
require("plugins.lsp")
