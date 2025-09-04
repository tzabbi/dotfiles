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
			-- markdown = { "markdown_tables" },
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
			markdown_tables = {
				command = "prettier",
				args = { "--parser", "markdown" },
				stdin = true,
				range_args = function(ctx)
					local lines = vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)
					local ranges = {}

					local start = nil
					for i, l in ipairs(lines) do
						if l:match("^|") then
							start = start or (i - 1) -- nvim is 0-based
						elseif start then
							table.insert(ranges, { start, 0, i - 1, 999 })
							start = nil
						end
					end
					if start then
						table.insert(ranges, { start, 0, #lines - 1, 999 })
					end

					-- conform only accepts a range → we will initially only take the first table
					if #ranges > 0 then
						return ranges[1]
					end
				end,
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
				stdin = true,
			},
		},
	},
}
