-- lazy.nvim
-- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
return {
	"folke/noice.nvim",
	version = "4.*",
	event = "VeryLazy",
	opts = {
		lsp = {
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
		},
		views = {
			cmdline_popup = {
				position = {
					row = 5,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
			},
		},
		presets = {
			bottom_search = true,
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					find = "failed to execute 'kubectl get --raw /openapi/v2'",
				},
				opts = { skip = true }, -- skips display notification
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
	config = function(_, opts)
		require("noice").setup(opts)
	end,
}
