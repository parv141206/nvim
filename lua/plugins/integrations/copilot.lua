-----------------------------------------------------------
-- GitHub Copilot: AI code suggestions
-----------------------------------------------------------
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
