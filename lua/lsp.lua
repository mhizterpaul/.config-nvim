-- ~/.config/nvim/lua/lsp.lua
local lspconfig = require("lspconfig")

-- Use system-installed clangd
lspconfig.clangd.setup {
  cmd = { "/usr/bin/clangd" },
  capabilities = require("cmp_nvim_lsp").default_capabilities(), -- if using nvim-cmp
}

-- nvim-cmp (completion)
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
      else fallback() end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then luasnip.jump(-1)
      else fallback() end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "path" }, { name = "buffer" },
  },
})

-- Capabilities shared by all servers
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Helper: default on_attach (keymaps per buffer)
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end
  map("n", "gd", vim.lsp.buf.definition)
  map("n", "gr", vim.lsp.buf.references)
  map("n", "K",  vim.lsp.buf.hover)
  map("n", "<leader>rn", vim.lsp.buf.rename)
  map("n", "<leader>ca", vim.lsp.buf.code_action)
end

-- === Servers ===
-- TypeScript/JavaScript (incl. React/React Native via tsx/jsx)
-- NOTE: Modern lspconfig uses "ts_ls" (formerly "tsserver").
lspconfig.ts_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  -- filetypes cover React/RN too:
  filetypes = {
    "javascript","javascriptreact","javascript.jsx",
    "typescript","typescriptreact","typescript.tsx"
  },
})

-- Tailwind CSS
lspconfig.tailwindcss.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  -- Works in TSX/JSX/HTML/CSS; adjust if you use unusual filetypes
  filetypes = {
    "html","css","javascriptreact","typescriptreact","tsx","jsx"
  },
  -- You can add experimental configless v4 detection as it matures.
})

-- CSS / HTML / JSON
lspconfig.cssls.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.html.setup({ capabilities = capabilities, on_attach = on_attach })
lspconfig.jsonls.setup({ capabilities = capabilities, on_attach = on_attach })

-- Emmet (handy for React/Tailwind authoring)
lspconfig.emmet_ls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
  filetypes = {
    "html","css","sass","scss","less",
    "javascriptreact","typescriptreact","javascript","typescript"
  },
})

-- Python
lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })

-- C/C++
lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })

-- Java (basic; for full power consider per-project jdtls launcher)
lspconfig.jdtls.setup({ capabilities = capabilities, on_attach = on_attach })
