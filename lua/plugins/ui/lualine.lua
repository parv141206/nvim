-- The bar at the bottom that shows stuff
return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local theme_config = require("core.theme")
        require("lualine").setup({
            		options = {
			theme = "auto",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = { "alpha", "dashboard" },
			always_divide_middle = true,
			globalstatus = true,
		},
        })
    end,
}
