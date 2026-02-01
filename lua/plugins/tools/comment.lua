-- Toggle comments with Leader+/
return {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
        require("Comment").setup({})
    end,
}
