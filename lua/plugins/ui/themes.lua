-----------------------------------------------------------
-- Themes: Colorschemes with dynamic switching
--
-- Commands:
--   :ThemeSelect   - Pick theme from list
--   :ToggleTransparent - Toggle background transparency
--   :ToggleTransparentUI - Toggle UI transparency
-----------------------------------------------------------

local theme_config = require("core.theme")
local THEME_NAME = theme_config.theme
local TRANSPARENT_BG = theme_config.transparent_bg
local TRANSPARENT_UI = theme_config.transparent_ui

-- Create theme selection command
local function setup_theme_commands()
    local themes = {
        "ayu",
        "cyberdream",
        "nightfox",
        "kanagawa",
        "tokyonight",
        "gruvbox",
        "catppuccin",
        "night-owl",
        "rose-pine",
        "everforest",
        "onedark",
        "nord",
        "moonfly",
        "vague",
        "tokyodark",
    }

    vim.api.nvim_create_user_command("ThemeSelect", function()
        local ok_builtin, builtin = pcall(require, "telescope.builtin")

        if ok_builtin then
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            builtin.colorscheme({
                colors = themes,
                enable_preview = true,
                prompt_title = "Select Theme (Live Preview)",
                attach_mappings = function(prompt_bufnr, _)
                    actions.select_default:replace(function()
                        local selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)

                        if selection and selection.value then
                            theme_config.set_theme(selection.value)
                        end
                    end)

                    return true
                end,
            })
            return
        end

        -- Fallback when Telescope is unavailable
        vim.ui.select(themes, {
            prompt = "Select Theme: ",
        }, function(choice)
            if choice then
                theme_config.set_theme(choice)
            end
        end)
    end, {})

    vim.api.nvim_create_user_command("ToggleTransparent", function()
        theme_config.toggle_transparent_bg()
    end, {})

    vim.api.nvim_create_user_command("ToggleTransparentUI", function()
        theme_config.toggle_transparent_ui()
    end, {})
end

-- Custom highlight overrides per colorscheme
vim.api.nvim_create_augroup("ThemeOverrides", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
    group = "ThemeOverrides",
    pattern = "tokyonight*",
    callback = function()
        vim.cmd("highlight VertSplit guifg=#3b4261")
        vim.cmd("highlight EndOfBuffer guifg=#3b4261")
    end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
    group = "ThemeOverrides",
    pattern = "nightfox",
    callback = function()
        local colors = require("nightfox.palette").load("nightfox")
        vim.api.nvim_set_hl(0, "VertSplit", { fg = colors.comment })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { fg = colors.comment })
    end,
})

return {
    -- Ayu theme
    {
        "Shatur/neovim-ayu",
        name = "ayu",
        config = function()
            require("ayu").setup({
                mirage = false,
                terminal = true,
            })
            if THEME_NAME == "ayu" then
                vim.cmd.colorscheme("ayu")
            end
        end,
    },

    -- Cyberdream theme
    {
        "scottmckendry/cyberdream.nvim",
        name = "cyberdream",
        priority = 1000,
        config = function()
            require("cyberdream").setup({
                transparent = TRANSPARENT_BG,
            })
            if THEME_NAME == "cyberdream" then
                vim.cmd.colorscheme("cyberdream")
            end
        end,
    },

    -- Nightfox theme
    {
        "EdenEast/nightfox.nvim",
        name = "nightfox",
        priority = 1000,
        config = function()
            require("nightfox").setup({
                options = {
                    transparent = TRANSPARENT_BG,
                    styles = { comments = "italic", keywords = "italic" },
                },
            })
            if THEME_NAME == "nightfox" then
                vim.cmd.colorscheme("nightfox")
            end
            setup_theme_commands()
        end,
    },

    -- Kanagawa theme
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        config = function()
            require("kanagawa").setup({
                transparent = TRANSPARENT_BG,
                background = { light = "lotus", dark = "wave" },
                theme = "wave",
            })
            if THEME_NAME == "kanagawa" then
                vim.cmd.colorscheme("kanagawa")
            end
        end,
    },

    -- Tokyonight theme
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        config = function()
            require("tokyonight").setup({
                transparent = TRANSPARENT_BG,
                style = "moon",
            })
            if THEME_NAME == "tokyonight" then
                vim.cmd.colorscheme("tokyonight")
            end
        end,
    },

    -- Gruvbox theme
    {
        "morhetz/gruvbox",
        name = "gruvbox",
        config = function()
            if TRANSPARENT_BG then
                vim.g.gruvbox_transparent_bg = 1
            end
            if THEME_NAME == "gruvbox" then
                vim.cmd.colorscheme("gruvbox")
            end
        end,
    },

    -- Catppuccin theme
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                transparent_background = TRANSPARENT_BG,
                integrations = {
                    telescope = true,
                    treesitter = true,
                    nvimtree = true,
                    indent_blankline = true,
                    lsp_saga = true,
                },
            })
            if THEME_NAME == "catppuccin" then
                vim.cmd.colorscheme("catppuccin")
            end
        end,
    },

    -- Night Owl theme
    {
        "haishanh/night-owl.vim",
        name = "night-owl",
        config = function()
            if TRANSPARENT_BG then
                vim.g.night_owl_transparent_background = 1
            end
            if THEME_NAME == "night-owl" then
                vim.cmd.colorscheme("night-owl")
            end
        end,
    },

    -- Rose Pine theme
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require("rose-pine").setup({
                dark_variant = "main",
                styles = {
                    italic = true,
                },
            })
            vim.o.background = "dark"
            if TRANSPARENT_BG then
                vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
                vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            end
            if THEME_NAME == "rose-pine" then
                vim.cmd.colorscheme("rose-pine")
            end
        end,
    },

    -- Everforest theme
    {
        "neanias/everforest-nvim",
        name = "everforest",
        config = function()
            require("everforest").setup({
                transparent = TRANSPARENT_BG,
                style = "dark",
                background = "hard",
            })
            if THEME_NAME == "everforest" then
                vim.cmd.colorscheme("everforest")
            end
        end,
    },

    -- One Dark Pro theme
    {
        "olimorris/onedarkpro.nvim",
        name = "onedark_pro",
        config = function()
            require("onedarkpro").setup({
                colors = {},
                highlights = {},
                filetypes = {},
            })
            if THEME_NAME == "onedark_pro" or THEME_NAME == "onedark" then
                vim.cmd.colorscheme("onedark")
            end
        end,
    },

    -- Nord theme
    {
        "shaunsingh/nord.nvim",
        name = "nord",
        config = function()
            vim.g.nord_cursor_line_number_background = 1
            if TRANSPARENT_BG then
                vim.g.nord_disable_background = true
            end
            if THEME_NAME == "nord" then
                vim.cmd.colorscheme("nord")
            end
        end,
    },

    -- Moonfly theme
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        config = function()
            if TRANSPARENT_BG then
                vim.g.moonflyTransparent = 1
            end
            if THEME_NAME == "moonfly" then
                vim.cmd.colorscheme("moonfly")
            end
        end,
    },

    -- Vague theme
    {
        "vague-theme/vague.nvim",
        name = "vague",
        config = function()
            require("vague").setup({
                transparent = TRANSPARENT_BG,
            })
            if THEME_NAME == "vague" then
                vim.cmd.colorscheme("vague")
            end
        end,
    },

    -- Tokyodark theme
    {
        "tiagovla/tokyodark.nvim",
        name = "tokyodark",
        config = function()
            require("tokyodark").setup({
                transparent_background = TRANSPARENT_BG,
            })
            if THEME_NAME == "tokyodark" then
                vim.cmd.colorscheme("tokyodark")
            end
        end,
    },
}
