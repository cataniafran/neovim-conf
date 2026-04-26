-- lua/config/options.lua
-- Neovim 0.12 native options and defaults
-- Inspired by modern best practices (tduyng.com)

local opt = vim.opt

-- Performance & Stability
opt.updatetime = 300          -- Faster completion and UI response
opt.timeoutlen = 300          -- Faster key sequence response
opt.synmaxcol = 300           -- Don't highlight long lines

-- Add go/bin and pnpm/bin to path
local go_bin = vim.fn.expand("$HOME/go/bin")
if vim.fn.isdirectory(go_bin) == 1 then
  vim.fn.setenv("PATH", go_bin .. ":" .. vim.fn.getenv("PATH"))
end

local pnpm_bin = vim.fn.expand("$HOME/Library/pnpm")
if vim.fn.isdirectory(pnpm_bin) == 1 then
  vim.fn.setenv("PATH", pnpm_bin .. ":" .. vim.fn.getenv("PATH"))
end

-- Go filetype detection
vim.filetype.add({
  extension = {
    gowork = "gowork",
    gotmpl = "gotmpl",
  },
})

-- General behavior
opt.number = true             -- Show line numbers
opt.relativenumber = true     -- Relative line numbers
opt.mouse = "a"               -- Enable mouse in all modes
opt.undofile = true           -- Persistent undo
opt.swapfile = false          -- Disable swap files
opt.backup = false            -- Disable backup files
opt.scrolloff = 10            -- Keep 10 lines of context when scrolling
opt.termguicolors = true      -- True color support
opt.laststatus = 3            -- Global statusline

-- SSH-Aware Clipboard
if not vim.env.SSH_TTY then
  opt.clipboard = "unnamedplus" -- Use system clipboard only when local
end

-- Smart Search
opt.ignorecase = true         -- Case-insensitive searching...
opt.smartcase = true          -- ...unless \C or capital in search
opt.hlsearch = false          -- Don't highlight all matches permanently

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Neovim 0.12 Native Features
vim.o.autocomplete = true      -- Enable built-in completion
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Aesthetics
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.fillchars = { fold = " ", foldopen = "", foldclose = "" }

-- Use `vim.loader` (enabled by default in 0.12)
if vim.loader then
  vim.loader.enable()
end

-- Disable unused providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0 -- Enabled only if specifically needed
vim.g.loaded_node_provider = 0 -- Using native binaries instead
vim.g.loaded_python3_provider = 0 -- Using native binaries instead
