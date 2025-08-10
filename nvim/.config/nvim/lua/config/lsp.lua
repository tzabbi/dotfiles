-- tofu-ls lsp setup
vim.lsp.config["tofu_ls"] = {
	-- Base filetypes
	filetypes = { "terraform", "terraform-vars" },
}

vim.lsp.enable({
	"bashls",
	"dockerls",
	"gitlab_ci_ls",
	"helm_ls",
	"jsonls",
	"jsonnet_ls",
	"lua_ls",
	"ruby_lsp",
	"sqlls",
	"tofu_ls",
	"tsserver",
	"yamlls",
})
