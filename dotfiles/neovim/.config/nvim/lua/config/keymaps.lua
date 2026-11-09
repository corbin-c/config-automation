-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>fN", ":e %:p:h/")
vim.keymap.del("n", "<S-h>")
vim.keymap.del("n", "<S-l>")
vim.keymap.del("n", "<leader>bd")
vim.keymap.set("n", "<C-PageUp>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<C-PageDown>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<C-w>", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>gf", function()
  Snacks.picker.git_log_file()
end, { desc = "Git Current File History" })
vim.keymap.set("n", "<leader>ga", function()
  -- Start the interactive :e command
  vim.cmd('!git add "%:p"')
  -- Use an autocommand to paste content after the new buffer is created
end, { desc = "Add file" })

vim.keymap.set("n", "<leader>fD", function()
  vim.api.nvim_feedkeys(':!rm "%:p"', "n", false)
end, { desc = "Delete file" })

vim.keymap.set("n", "<leader>gC", function()
  vim.api.nvim_feedkeys(':!git commit "%:p" -m ', "n", false)
end, { desc = "Commit file" })

vim.keymap.set("n", "<leader>fC", function()
  -- Store current buffer content
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- Start the interactive :e command
  vim.api.nvim_feedkeys(":e %:p:h/", "n", false)
  -- Use an autocommand to paste content after the new buffer is created
  vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("CopyContent", { clear = true }),
    once = true, -- Run only once
    callback = function()
      vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
      vim.cmd("w") -- Save the new file
    end,
  })
end, { desc = "New file with current content" })
