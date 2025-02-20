return {
  "neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false, -- hide filtered items on open
        hide_dotfiles = false,
        never_show = { ".git" },
      },
    },
  },
}
