vim.lsp.config("tofu_ls", {
	filetypes = { "terraform", "terraform-vars" },
})

vim.lsp.config("yamlls", {
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
		},
	},
	settings = {
		redhat = { telemetry = { enabled = false } },
		yaml = {
			keyOrdering = false,
			format = {
				enable = true,
			},
			validate = true,
			schemas = {
				require("schemastore").yaml.schemas(),
				kubernetes = "*.yaml",
				[require("kubernetes").yamlls_schema()] = "*.yaml",
			},
			schemaStore = {
				-- Must disable built-in schemaStore support to use
				-- schemas from SchemaStore.nvim plugin
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
		},
	},
})

vim.lsp.enable({
	"bashls",
	"biome",
	"dockerls",
	"docker_compose_language_service",
	"eslint",
	"gopls",
	"golangci_lint_ls",
	"gitlab_ci_ls",
	"helm_ls",
	"jsonls",
	"jsonnet_ls",
	"lua_ls",
	"marksman",
	"omnisharp",
	"phpactor",
	"pyright",
	"ruff",
	"ruby_lsp",
	"sqlls",
	"taplo",
	"tflint",
	"tofu_ls",
	"ts_ls",
	"yamlls",
})
