return {
	{
		"williamboman/mason.nvim",
		version = "*",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"docker-compose-language-service",
					"dockerfile-language-server",
					"eslint_d",
					"js-debug-adapter",
					"json-lsp",
					"jsonnet-language-server",
					"markdownlint-cli2",
					"omnisharp",
					"phpactor",
					"phpcs",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
}
