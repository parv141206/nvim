-----------------------------------------------------------
-- Bufferline: Tab-like buffer management
-----------------------------------------------------------
return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("bufferline").setup({})
        vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
    end,
}
