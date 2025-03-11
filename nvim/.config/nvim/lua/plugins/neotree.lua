return {
  "neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = false, -- hide filtered items on open
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { ".git" },
      },
    },
  },
}
