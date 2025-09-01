return {
  {
    "mfussenegger/nvim-lint",
    -- no version available
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        -- ... andere Dateitypen ...
        markdown = { "markdownlint" },
      }

      -- Linter automatisch bei jedem Speichern ausführen
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
