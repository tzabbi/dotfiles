return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("tokyonight").setup({
			styles = {
				comments = { italic = false }, -- Disable italics in comments
			},
			on_highlights = function(hl)
				hl.LineNr = { fg = "#b2b8cf" }
			end,
		})
		vim.cmd.colorscheme("tokyonight-moon")
	end,
}
