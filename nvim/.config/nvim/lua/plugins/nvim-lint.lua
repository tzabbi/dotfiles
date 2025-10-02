return {
	{
		"mfussenegger/nvim-lint",
		-- no version available
		event = "BufReadPost",
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				markdown = { "markdownlint-cli2" },
				dockerfile = { "hadolint" },
			}

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = vim.api.nvim_create_augroup("Linter", { clear = true }),
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
