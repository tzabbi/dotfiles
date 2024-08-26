return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    -- configure treesitter
    treesitter.setup({ -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = { enable = true },
      -- ensure these language parsers are installed
      ensure_installed = {
        "awk",
        "bash",
        "comment",
        "css",
        "diff",
        "dockerfile",
        "git_config",
        "gitignore",
        "go",
        "gomod",
        "gosum",
        "gpg",
        "groovy",
        "hcl",
        "html",
        "javascript",
        "jq",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rego",
        "ruby",
        "rust",
        "sql",
        "typescript",
        "vim",
        "xml",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
