-- tofu-ls lsp setup
vim.lsp.config["tofuls"] = {
  cmd = { "tofu-ls", "serve" },
  -- Base filetypes
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
}

vim.lsp.enable("tofuls")
