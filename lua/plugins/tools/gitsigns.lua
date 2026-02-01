-----------------------------------------------------------
-- Gitsigns: Git diff and blame in gutter
-----------------------------------------------------------
return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "│" },
                topdelete = { text = "│" },
                changedelete = { text = "│" },
            },
            current_line_blame = true,
            current_line_blame_opts = { delay = 100 },
        })

        vim.keymap.set("n", "<leader>ghb", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
        vim.keymap.set("n", "<leader>ghd", ":Gitsigns diffthis<CR>", { desc = "Diff this" })
        vim.keymap.set("n", "<leader>ghh", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
    end,
}
