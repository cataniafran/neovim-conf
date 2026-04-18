-- lua/plugins/lsp.lua
-- Native LSP management (Neovim 0.12)

-- 1. Helper for common capabilities (e.g., from nvim-cmp replacement)
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- 2. Configure VTSLS (Modern TypeScript Server)
vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      tsdk = "node_modules/typescript/lib", -- or global path
      inlayHints = {
        parameterNames = { enabled = "all" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
      },
    },
    vtsls = {
      tstypescript = {
        globalTsdk = "node_modules/typescript/lib",
      },
      -- Enable Vue support in vtsls (Hybrid mode)
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
})

-- 3. Configure Volar (Vue 3 Language Server)
vim.lsp.config("volar", {
  settings = {
    vue = {
      hybridMode = true, -- Modern Volar 2.x feature
    },
  },
  -- Only attach to vue files (vtsls handles the logic for Vue files)
  filetypes = { "vue" },
})

-- 4. Automatically enable servers for current and future buffers
-- This is a new 0.12 feature that replaces `on_attach` for many common cases
vim.lsp.enable("vtsls")
vim.lsp.enable("volar")

-- 5. Diagnostic styling
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Native support for diagnostic icons
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
  },
})
