return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  main = "neo-tree",
  opts = {
    window = {
      position = "right",
      mappings = {
        ["l"] = "open",
        ["h"] = "close_node",
      },
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
  keys = {
    {
      "<leader>e",
      function() vim.cmd("Neotree filesystem reveal right") end,
      desc = "Open Neo-tree",
    },
  },
  lazy = false, -- neo-tree will lazily load itself
}
