return {
	"mfussenegger/nvim-lint",
	event = "BufWritePost", -- lint nur beim Speichern
	config = function()
		local lint = require("lint")

		-- Linter pro Filetype
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			python = { "ruff" },
			terraform = { "tflint" },
			yaml = { "yamllint" },
			sh = { "shellcheck" },
		}

		-- Autocmd: lint beim Speichern
		vim.api.nvim_create_autocmd("BufWritePost", {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
