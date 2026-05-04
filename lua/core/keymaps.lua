-- All the keybinds that make life easier
local keymap = vim.keymap

---------- QUIT ALL AT ONCE ----------
-- Override :q to close everything in one go
-- vim.api.nvim_create_user_command("Q", "qa!", {})
-- vim.cmd("cabbrev q <c-u>Q<CR>")

---------- WINDOW NAVIGATION ----------
keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Focus left window" })
keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Focus right window" })
keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Focus lower window" })
keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Focus upper window" })

---------- COMMENT TOGGLING ----------
-- Toggle comment on current line or selection
keymap.set("n", "<leader>/", function()
    require("Comment.api").toggle.linewise.current()
end, { desc = "Comment line" })
keymap.set("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = "Comment selection" })

---------- TERMINAL ----------
-- Press Esc twice quickly to leave terminal-insert mode
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })


---------- USER SETTINGS ----------
keymap.set("n", "<leader>ue", "<cmd>EditorSettings<CR>", { desc = "Editor settings" })

-- new keymaps
-- Move line up and down
keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })

-- Move between panes
keymap.set("n", "<A-h>", "<C-w>h", { desc = "Move to left pane" })
keymap.set("n", "<A-l>", "<C-w>l", { desc = "Move to right pane" })
keymap.set("n", "<A-Up>", "<C-w>k", { desc = "Move to upper pane" })
keymap.set("n", "<A-Down>", "<C-w>j", { desc = "Move to lower pane" })

-- Resize panes
keymap.set("n", "<C-S-Up>", ":resize -2<CR>", { desc = "Decrease window height" })
keymap.set("n", "<C-S-Down>", ":resize +2<CR>", { desc = "Increase window height" })
keymap.set("n", "<C-S-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
keymap.set("n", "<C-S-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Insert mode shortcuts
keymap.set("i", "<C-CR>", "<Esc>o", { desc = "New line below" })

-- Normal mode shortcuts
keymap.set("n", "I", "A", { desc = "Insert at end of line" })

-- Toggle terminal
keymap.set({ "n", "t" }, "<A-i>", function()
    require("core.terminal").toggle()
end, { desc = "Toggle terminal" })
