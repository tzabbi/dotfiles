vim.lsp.config("tofu_ls", {
	filetypes = { "terraform", "terraform-vars" },
})

vim.lsp.config("gopls", {
	settings = {
		gopls = {
			gofumpt = true,
			codelenses = {
				gc_details = false,
				generate = true,
				regenerate_cgo = true,
				run_govulncheck = true,
				test = true,
				tidy = true,
				upgrade_dependency = true,
				vendor = true,
			},
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
			analyses = {
				nilness = true,
				unusedparams = true,
				unusedwrite = true,
				useany = true,
			},
			usePlaceholders = true,
			completeUnimported = true,
			staticcheck = true,
			directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
			semanticTokens = true,
		},
	},
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
				enable = false,
			},
			validate = true,
			schemas = {
				[require("kubernetes").yamlls_schema()] = "*.yaml",
				require("schemastore").yaml.schemas(),
			},
			schemaStore = {
				-- Must disable built-in schemaStore support to use
				-- schemas from SchemaStore.nvim plugin
				enable = false,
				-- Avoid TypeError: Cannot read properties of undefined (reading 'length')
				url = "",
			},
			-- ignore tags
			customTags = {
        		"!reference",
			},
		},
	},
})

vim.lsp.enable({
	"bashls",
	"biome",
	"dockerls",
	"docker_compose_language_service",
	-- "eslint",
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
