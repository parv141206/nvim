-----------------------------------------------------------
-- Comment.nvim: Easy code commenting
-----------------------------------------------------------
return {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
        require("Comment").setup({})
    end,
}
