-- ~/.config/nvim/lua/plugins/nvim-tree.lua

return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- for file icons
  },
  config = function()
    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "left",
      },
      filters = {
        dotfiles = false,
      },
      git = {
        enable = true,
      },
    })

    -- Keybinding to toggle tree
    vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })
  end,
}
