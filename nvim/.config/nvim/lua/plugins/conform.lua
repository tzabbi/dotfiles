-- ~/.config/nvim/lua/plugins/conform.lua
return {
  "stevearc/conform.nvim",
  opts = {
    -- Definiere hier, welcher Formatter für welchen Dateityp verwendet wird.
    -- Wir überschreiben hier den Standard für YAML.
    formatters_by_ft = {
      -- ... andere Dateitypen werden von der LazyVim-Standardkonfiguration übernommen
      yaml = { "yamlfmt" },
    },
    -- Optional: Konfiguration für yamlfmt selbst, falls nötig.
    -- In der Regel ist für dein Problem keine weitere Konfiguration nötig.
  },
}
