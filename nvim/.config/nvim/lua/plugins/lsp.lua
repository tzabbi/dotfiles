local lspconfig = require("lspconfig")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Useful for debugging formatter issues
      format_notify = true,
      inlay_hints = { enabled = true },
      servers = {
        bashls = {
          filetypes = { "sh", "zsh" },
        },
        dockerls = {},
        gitlab_ci_ls = {},
        helm_ls = {},
        jsonls = {},
        jsonnet_ls = {},
        lua_ls = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
        sqlls = {},
        tsserver = {},
        yamlls = {},
      },
    },
  },
}
