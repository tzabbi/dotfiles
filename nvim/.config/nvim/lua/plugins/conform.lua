-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    formatter_by_ft = {
      yaml = { "yamlfmt" },
    },
  },
}
