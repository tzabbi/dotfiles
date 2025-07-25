-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local opt = vim.opt
opt.grepprg = "rg --vimgrep --hidden"

vim.diagnostic.config({ virtual_lines = true })

vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.relativenumber = false

vim.opt.winborder = "rounded"
