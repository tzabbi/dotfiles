-- tofu-ls lsp setup
vim.lsp.config["tofu_ls"] = {
  cmd = { "tofu-ls", "serve" },
  -- Base filetypes
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
}

vim.lsp.enable({
  "lua_ls",
  "tofu_ls",
})
