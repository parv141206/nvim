-- Git commands in Neovim. Super handy.
return {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    config = function()
        vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "Git status" })
        vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "Git diff" })
        vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "Git commit" })
        vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "Git blame" })
        vim.keymap.set("n", "<leader>gl", ":Git log<CR>", { desc = "Git log" })
        vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "Git push" })
        vim.keymap.set("n", "<leader>gu", ":Git pull<CR>", { desc = "Git pull" })
    end,
}
