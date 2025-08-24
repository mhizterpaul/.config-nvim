return {
 -- Mason
  {
    "williamboman/mason.nvim",
    config = function() require("mason").setup() end,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "js-debug-adapter")
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", "tailwindcss", "cssls", "html", "jsonls",
          "emmet_ls", "pyright", "jdtls"
        },
        automatic_installation = true,
      })
    end,
  },

}
