return {
  {
    "echasnovski/mini.map",
    version = false,
    config = function()
      local minimap = require("mini.map")
      -- Custom integration for cursor-word highlights
      vim.keymap.set("n", "<leader>m", "<Cmd>lua MiniMap.toggle()<CR>", { desc = "Toggle MiniMap" })
      for _, key in ipairs({ "n", "N", "*", "#" }) do
        local rhs = key .. "<Cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<CR>"
        vim.keymap.set("n", key, rhs)
      end
      minimap.setup({
        symbols = {
          scroll_line = "➤",
          scroll_view = "│",
        },
        integrations = {
          minimap.gen_integration.builtin_search(), -- Keep search highlights
          minimap.gen_integration.diagnostic(), -- Keep diagnostics
        },
        window = {
          width = 10,
          winblend = 25,
        },
      })
      minimap.open()
    end,
  },
}
