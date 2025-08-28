local python = require("vim.provider.python")
return {
	-- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		notify_on_error = false,
		format_on_save = {
			-- These options will be passed to conform.format()
			timeout_ms = 500,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			ansible = { "ansible-lint" },
			docker = { "dockerfmt" },
			go = { "goimports", "gofumpt" },
			hcl = { "hcl" },
			javascript = { "prettier" },
			json = { "jq" },
			lua = { "stylua" },
			markddown = { "prettier", "markdown-toc" },
			php = { "php_cs_fixer" },
			python = { "ruff" },
			sh = { "shfmt" },
			sqlfluff = { "sqlfluff" },
			terraform = { "tofu_fmt" },
			tofu = { "tofu_fmt" }, -- this is a function from conform directly

			yaml = { "yamlfmt" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
			-- configure formatter options
		formatters = {
			stylua = {
				extra_args = { "--indent-width", "2", "--indent-type", "Spaces" },
			},
		},
	},
}
