-- The bar at the bottom that shows stuff
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local theme_config = require("core.theme")
        require("lualine").setup({
            options = { theme = theme_config.theme },
        })
    end,
}
