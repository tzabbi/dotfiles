-- tofu-ls lsp setup
vim.lsp.config["tofu_ls"] = {
  -- Base filetypes
  filetypes = { "terraform", "terraform-vars" },
}

vim.lsp.enable({
  "gopls",
  "lua_ls",
  "ruby_lsp",
  "tofu_ls",
})
