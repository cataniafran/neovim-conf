-- lua/plugins/init.lua
-- Native plugin management using `vim.pack` (Neovim 0.12)

-- Define the plugins we want
local plugins = {
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/tokyonight.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/echasnovski/mini.icons", -- Added for icon support
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  "https://github.com/neovim/nvim-lspconfig",
}

-- 1. Register plugins with native pack manager
vim.pack.add(plugins)

-- 2. Setup Icons
require("mini.icons").setup()

-- 3. Configure Which-key
local wk = require("which-key")
wk.setup({
  preset = "modern", -- modern 0.12 look
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
})

-- Register groups for which-key
wk.add({
  -- Leader groups
  { "<leader>f", group = "find" },
  { "<leader>s", group = "search" },
  { "<leader>l", group = "lsp" },
  { "<leader>b", group = "buffer" },
  { "<leader>u", group = "ui/toggles" },
  { "<leader>g", group = "git" },

  -- Non-leader prefixes
  { "g", group = "goto/lsp" },
  { "gr", group = "lsp actions (0.12 native)" },
  { "z", group = "folds/spell/zen" },
  { "[", group = "prev" },
  { "]", group = "next" },
})

-- 3. Configure Snacks.nvim with sane defaults
require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = {
    enabled = true,
    timeout = 3000,
  },
  picker = {
    enabled = true,
    layout = { preset = "telescope" },
    ui_select = true, -- Use Snacks.picker for vim.ui.select
  },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  zen = { enabled = true },
})

-- Set Snacks as the default UI handler for input
vim.ui.input = function(...)
  return require("snacks").input(...)
end

-- 4. Set Colorscheme
vim.cmd.colorscheme("tokyonight-moon")

-- 5. Setup Treesitter
require("nvim-treesitter").setup({
  ensure_installed = { 
    "lua", "typescript", "javascript", "vue", "html", "css",
    "c", "rust", "zig", "ruby", "go" 
  },
  highlight = { enable = true },
})

-- 6. Extra Snacks keymaps (AstroNvim Aligned)
local map = vim.keymap.set
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Toggle Scratch Buffer" })
map("n", "<leader>uz", function() Snacks.zen() end, { desc = "Toggle Zen Mode" })
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find Buffers" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files" })
map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Find Git Files" })
map("n", "<leader>fo", function() Snacks.picker.recent() end, { desc = "Recent Files" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Search Projects" })
map("n", "<leader>sl", function() Snacks.picker.lines() end, { desc = "Search Lines" })
map("n", "<leader>fw", function() Snacks.picker.grep() end, { desc = "Live Grep" })
map("n", "<leader>uD", function() Snacks.notifier.hide() end, { desc = "Dismiss Notifications" })
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle File Explorer" })
