vim.lsp.config('dockerls', {
	cmd = { 'docker-ls', '--stdio' },
})

vim.lsp.config('tofu_ls', {
	filetypes = { "terraform", "terraform-vars" },
})

vim.lsp.enable({
	"bashls",
	"dockerls",
	"gitlab_ci_ls",
	"helm_ls",
	-- "jsonls",
	-- "jsonnet_ls",
	"lua_ls",
	"ruby_lsp",
	"sqlls",
	"tofu_ls",
	"ts_ls",
	"yamlls",
})
