return {
	"oribarilan/lensline.nvim",
	version = "2.*",
	event = "LspAttach",
	config = function()
		require("lensline").setup()
	end,
}
