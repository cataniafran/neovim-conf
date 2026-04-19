-- lua/plugins/lsp.lua
-- Native LSP management (Neovim 0.12)

-- 1. Helper for common capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Dynamically resolve global node_modules for plugins (e.g., Volar/VTSLS)
local function get_global_node_modules()
  local npm_root = vim.fn.system("npm root -g"):gsub("\n", "")
  return npm_root
end

local global_node_modules = get_global_node_modules()

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
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            location = global_node_modules .. "/@vue/typescript-plugin",
            languages = { "vue" },
            configNamespace = "typescript",
            enableForWorkspaceTypeScriptVersions = true,
          },
        },
      },
    },
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
})

-- 3. Configure Vue Language Server (vue_ls)
-- This replaces the deprecated 'volar' configuration name
vim.lsp.config("vue_ls", {
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

-- 5. Automatically enable servers for current and future buffers
vim.lsp.enable("vtsls")
vim.lsp.enable("vue_ls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("clangd")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("zls")
vim.lsp.enable("ruby_lsp")
vim.lsp.enable("gopls")

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
    source = "always",
  },
})
