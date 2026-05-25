-- lua/config/keymaps.lua
-- General and native LSP mappings aligned with AstroNvim standards

local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 1. Window Management (AstroNvim standard)
-- Movement: Ctrl + h/j/k/l
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resizing: Ctrl + Up/Down/Left/Right
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Splits (AstroNvim uses \ and | for splits)
map("n", "\\", "<cmd>split<cr>", { desc = "Horizontal split" })
map("n", "|", "<cmd>vsplit<cr>", { desc = "Vertical split" })

-- 2. Buffer Management (AstroNvim standard)
-- Switching: ]b (Next), [b (Previous)
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprev<cr>", { desc = "Previous buffer" })

-- New/Closing (AstroNvim uses <leader>c for close)
map("n", "<leader>bn", "<cmd>enew<cr>", { desc = "New buffer" })
map("n", "<leader>c", "<cmd>bdelete<cr>", { desc = "Close current buffer" })
map("n", "<leader>bc", "<cmd>%bd|e#|bd#<cr>", { desc = "Close all except current" })
map("n", "<leader>bC", "<cmd>%bd<cr>", { desc = "Close all buffers" })

-- 3. LSP/Diagnostics (AstroNvim <leader>l prefix)
map("n", "<leader>la", vim.lsp.buf.code_action, { desc = "LSP Code Action" })
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "LSP Rename" })
map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, { desc = "LSP Format" })
map("n", "<leader>lR", vim.lsp.buf.references, { desc = "LSP References" })
map("n", "<leader>ld", vim.diagnostic.open_float, { desc = "LSP Line Diagnostics" })
map("n", "<leader>lD", function() Snacks.picker.diagnostics() end, { desc = "Search Diagnostics" })

-- Standard LSP navigation
map("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gy", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Next error" })
map("n", "[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, { desc = "Prev error" })

-- 4. General UI / File Operations
-- Force Write (AstroNvim uses Ctrl+s)
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Force write" })

-- Explorer (Aligned with AstroNvim <leader>e)
map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Toggle File Explorer" })

-- Git / LazyGit
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Toggle LazyGit" })

-- Native Commenting
map("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment" })
map("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })

-- Accept completion with Enter (Enter to Commit flow)
map("i", "<CR>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-y>"
  end
  return "<CR>"
end, { expr = true, replace_keycodes = true, desc = "Accept completion" })

-- Super-Tab / Shift-Tab (AstroNvim Style)
map("i", "<Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-n>"
  elseif vim.snippet.active({ direction = 1 }) then
    return "<cmd>lua vim.snippet.jump(1)<cr>"
  else
    return "<Tab>"
  end
end, { expr = true, replace_keycodes = true, desc = "Next completion/Snippet jump" })

map("i", "<S-Tab>", function()
  if vim.fn.pumvisible() ~= 0 then
    return "<C-p>"
  elseif vim.snippet.active({ direction = -1 }) then
    return "<cmd>lua vim.snippet.jump(-1)<cr>"
  else
    return "<S-Tab>"
  end
end, { expr = true, replace_keycodes = true, desc = "Prev completion/Snippet jump" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- VSCode-style Line Movement (Kept from previous polish as they are standard in many configs)
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move block up" })
