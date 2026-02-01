-- GitHub Copilot for code suggestions
-- Run :Copilot auth to login
return {
    {
        "github/copilot.vim",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            vim.keymap.set("n", "<leader>cop", ":Copilot toggle<CR>", { desc = "Toggle Copilot" })
        end,
    },
}
