return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  opts = {
    window = {
      position = "right",
    },
    filesystem = {
      filtered_items = {
        visible = false, -- hide filtered items on open
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { ".git" },
      },
    },
  },
  lazy = false, -- neo-tree will lazily load itself
  config = function()
    vim.keymap.set('n','<leader>e', ':Neotree filesystem reveal right<CR>', {})
  end
}
