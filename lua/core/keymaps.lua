-- All the keybinds that make life easier
local map = vim.keymap.set

---------- QUIT ALL AT ONCE ----------
-- Override :q to close everything in one go
vim.api.nvim_create_user_command("Q", "qa!", {})
vim.cmd("cabbrev q <c-u>Q<CR>")

---------- WINDOW NAVIGATION ----------
map("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

---------- COMMENT TOGGLING ----------
-- Toggle comment on current line or selection
map("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Comment line" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = "Comment selection" })
