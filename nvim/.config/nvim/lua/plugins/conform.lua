return {
	-- Autoformat
	"stevearc/conform.nvim",
	version = "9.*",
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
			markdown = { "mdformat" },
			php = { "php_cs_fixer" },
			python = { "ruff" },
			sh = { "shfmt" },
			sql = { "sqlfluff" },
			sqlfluff = { "sqlfluff" },
			terraform = { "tofu_fmt" },
			tofu = { "tofu_fmt" }, -- this is a function from conform directly
			yaml = { "prettier" },
			-- Conform can also run multiple formatters sequentially
			-- python = { "isort", "black" },
			--
			-- You can use 'stop_after_first' to run the first available formatter from the list
			-- javascript = { "prettierd", "prettier", stop_after_first = true },
		},
		-- configure formatter options
		formatters = {
			mdformat = {
				command = "mdformat",
				-- stdin = true sorgt dafür, dass conform den Buffer direkt an mdformat übergibt
				stdin = true,
				-- Plugins wie mdformat-tables oder mdformat-frontmatter werden
				-- automatisch erkannt, wenn sie per pip installiert sind
				args = { "-" },
			},
			stylua = {
				extra_args = { "--indent-width", "2", "--indent-type", "Spaces" },
			},
			sqlfluff = {
				command = "sqlfluff",
				args = { "fix", "--disable_progress_bar", "--config-path", "/dev/null", "-" },
				stdin = true,
			},
			prettier = {
				command = "prettier",
				args = { "--stdin-filepath", "%" }, -- wichtig, damit Prettier den Filetype erkennt
				stdin = true,
			},
		},
	},
}
