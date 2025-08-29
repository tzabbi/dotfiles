return {
	"akinsho/bufferline.nvim",
	version = "4.*",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			always_show_bufferline = true,
			indicator = {
				style = "icon",
				icon = "▍",
			},
			separator_style = "thick",
		},
		highlights = {
			buffer_selected = {
				italic = false,
				underline = true,
				sp = "#ff0000",
			},
		},
	},
	config = function(_, opts)
		local bufferline = require("bufferline")
		bufferline.setup(opts)
	end,
}
