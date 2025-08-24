
return {  
-- core plugins
  require("plugins.mason"),
  require("plugins.mini-icons"),
  require("plugins.nvim-tree"),
  require("plugins.nvim-lsp"),
  -- Completion & snippets
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-path" },
  { "hrsh7th/cmp-buffer" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Syntax highlighting
  { "nvim-treesitter/nvim-treesitter",config = function()
	  require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vim",
    "typescript",
    "javascript",
    "python",
    "html",
    "cpp",
    "java",
    "css",
    "json"
  },
  highlight = { enable = true },
})
end, build = ":TSUpdate" },

  -- Useful extras
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim" },
}
