return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			indicator = {
				style = "underline",
			},
			separator_style = "slant",
		},
		highlights = {
			buffer_selected = {
				italic = false,
			},
		},
	},
	config = function(_, opts)
		local bufferline = require("bufferline")
		bufferline.setup(opts)
	end,
}
