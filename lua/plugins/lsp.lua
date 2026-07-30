-- lua/plugins/lsp.lua
-- Native LSP management (Neovim 0.12)

-- 1. Helper for common capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Dynamically resolve @vue/typescript-plugin location for VTSLS
local function get_vue_typescript_plugin_path()
  -- 1. Check local project node_modules
  local local_plugin = vim.fn.getcwd() .. "/node_modules/@vue/typescript-plugin"
  if vim.uv.fs_stat(local_plugin) then
    return local_plugin
  end

  -- 2. Check pnpm global installation
  local pnpm_root = vim.fn.system("pnpm root -g"):gsub("\n", "")
  if vim.v.shell_error == 0 and pnpm_root ~= "" then
    local matches = vim.fn.glob(pnpm_root .. "/*/node_modules/@vue/typescript-plugin", false, true)
    if #matches > 0 and vim.uv.fs_stat(matches[1]) then
      return matches[1]
    end
  end

  -- 3. Check npm global installation
  local npm_root = vim.fn.system("npm root -g"):gsub("\n", "")
  if vim.v.shell_error == 0 and npm_root ~= "" then
    local npm_plugin = npm_root .. "/@vue/typescript-plugin"
    if vim.uv.fs_stat(npm_plugin) then
      return npm_plugin
    end
  end

  -- 4. Check bun global installation
  local bun_plugin = vim.fn.expand("~/.bun/install/global/node_modules/@vue/typescript-plugin")
  if vim.uv.fs_stat(bun_plugin) then
    return bun_plugin
  end

  return ""
end

local vue_typescript_plugin_location = get_vue_typescript_plugin_path()

vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
  filetypes = { "lua" },
})

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
      -- Volar 2.x Hybrid Mode Support
      tsserver = {
        globalPlugins = (vue_typescript_plugin_location ~= "") and {
          {
            name = "@vue/typescript-plugin",
            location = vue_typescript_plugin_location,
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        } or {},
      },
    },
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
})

-- 3. Configure Vue Language Server (vue_ls)
-- This replaces the deprecated 'volar' configuration name
vim.lsp.config("vue_ls", {
  cmd = { "vue-language-server", "--stdio" },
  settings = {
    vue = {
      hybridMode = true, -- Modern Volar 2.x/3.x feature
    },
  },
  filetypes = { "vue" },
})

-- 4. Configure Additional Languages (C, Rust, Zig, Ruby, Go)
vim.lsp.config("clangd", { filetypes = { "c", "cpp", "objc", "objcpp" } })
vim.lsp.config("rust_analyzer", {
  filetypes = { "rust" },
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        command = "clippy",
      },
    },
  },
})
vim.lsp.config("zls", { filetypes = { "zig" } })
vim.lsp.config("ruby_lsp", { filetypes = { "ruby" } })
vim.lsp.config("gopls", {
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = { unusedparams = true },
    },
  },
})

-- 5. Configure Oxc tools (oxlint, oxfmt)
-- They will only start if their specific configuration files are present in the root
local oxc_filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "astro" }

vim.lsp.config("oxlint", {
  cmd = { "oxlint", "--lsp" },
  filetypes = oxc_filetypes,
  root_markers = { ".oxlintrc.json", ".oxlintrc.jsonc", "oxlint.json", "oxlint.config.ts" },
  workspace_required = true, -- Refuses to start if a root marker isn't found
})

vim.lsp.config("oxfmt", {
  cmd = { "oxfmt", "--lsp" },
  filetypes = oxc_filetypes,
  root_markers = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.json", "oxfmt.config.ts" },
  workspace_required = true,
})

-- 6. Automatically enable servers for current and future buffers
vim.lsp.enable("vtsls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("zls")
vim.lsp.enable("ruby_lsp")
vim.lsp.enable("gopls")
vim.lsp.enable("oxlint")
vim.lsp.enable("oxfmt")

-- Enable native completion for LSP
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
  end,
})

-- 6. Diagnostic styling
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- Native support for diagnostic icons
  },
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
})
