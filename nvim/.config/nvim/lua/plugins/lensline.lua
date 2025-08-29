return {
	"oribarilan/lensline.nvim",
	version = "1.*",
	event = "LspAttach",
	config = function()
		require("lensline").setup()
	end,
}
