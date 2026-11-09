return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      scad_format_custom = {
        command = "openscad-format",
        args = { "-i", "$FILENAME", "-o", "$FILENAME" },
        stdin = false, -- scad-format doesn't support stdin
      },
    },
    formatters_by_ft = {
      openscad = { "scad_format_custom" },
    },
  },
}
