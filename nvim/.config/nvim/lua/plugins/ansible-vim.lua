return {
	{
		"pearofducks/ansible-vim",
		version = "4.*",
		config = function()
			require("ansible").setup()
		end,
	},
}
