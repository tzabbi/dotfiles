return {
	"diogo464/kubernetes.nvim",
	opts = {
		-- this can help with autocomplete. it sets the `additionalProperties` field on type definitions to false if it is not already present.
		schema_strict = true,
		-- true:  generate the schema every time the plugin starts
		-- false: only generate the schema if the files don't already exists. run `:KubernetesGenerateSchema` manually to generate the schema if needed.
		schema_generate_always = true,
		-- Patch yaml-language-server's validation.js file.
		patch = true,
		-- root path of the yamlls language server. by default it is assumed you are using mason but if not this option allows changing that path.
		-- yamlls_root = function()
		-- 	local handle = io.popen("brew --prefix yaml-language-server")
		-- 	if not handle then
		-- 		return nil
		-- 	end
		-- 	local prefix = handle:read("*a"):gsub("%s+$", "")
		-- 	handle:close()
		-- 	return prefix .. "/libexec/lib/node_modules/yaml-language-server/"
		-- end,
		yamlls_root = function()
			return vim.fs.joinpath(vim.fn.stdpath("data"), "/mason/packages/yaml-language-server/")
		end,
	},
}
