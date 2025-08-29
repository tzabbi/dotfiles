return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	-- no version available
	config = function()
		require("lualine").setup({
			options = {
				globalstatus = true,
			},
		})
	end,
}
