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

local function is_selected_theme(name)
    return THEME_NAME == name or vim.startswith(THEME_NAME, name .. "-")
end

local function apply_selected_theme(base_name)
    if not is_selected_theme(base_name) then
        return
    end

    local target = THEME_NAME
    local ok = pcall(vim.cmd.colorscheme, target)
    if not ok then
        pcall(vim.cmd.colorscheme, base_name)
    end
end

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

-- Universal transparency: runs after every colorscheme, clears bg on key groups.
-- This forces transparency even on themes that don't natively support it.
vim.api.nvim_create_autocmd("ColorScheme", {
    group = "ThemeOverrides",
    pattern = "*",
    callback = function()
        local theme_cfg = require("core.theme")

        local function clear_bg(groups)
            for _, group in ipairs(groups) do
                local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
                if ok and type(hl) == "table" then
                    hl.bg = nil
                    hl.ctermbg = nil
                    pcall(vim.api.nvim_set_hl, 0, group, hl)
                end
            end
        end

        if theme_cfg.transparent_bg then
            clear_bg({
                "Normal", "NormalNC", "NormalFloat", "NormalDark",
                "SignColumn", "LineNr", "CursorLineNr",
                "EndOfBuffer",
                "WinSeparator", "VertSplit",
                "FloatBorder",
                "MsgArea",
            })
        end

        if theme_cfg.transparent_ui then
            clear_bg({
                "StatusLine", "StatusLineNC",
                "TabLine", "TabLineFill", "TabLineSel",
                "BufferLine", "BufferLineBackground", "BufferLineFill",
                "BufferLineTab", "BufferLineTabSelected", "BufferLineTabClose",
                "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeEndOfBuffer",
                "NeoTreeStatusLine", "NeoTreeStatusLineNC",
                "OutlineNormal",
                "Pmenu", "PmenuSbar", "PmenuThumb",
            })
        end
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
            apply_selected_theme("ayu")
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
            apply_selected_theme("cyberdream")
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
            apply_selected_theme("nightfox")
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
            apply_selected_theme("kanagawa")
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
            apply_selected_theme("tokyonight")
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
            apply_selected_theme("gruvbox")
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
            apply_selected_theme("catppuccin")
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
            apply_selected_theme("night-owl")
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
                    transparency = TRANSPARENT_BG,
                },
            })
            vim.o.background = "dark"
            apply_selected_theme("rose-pine")
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
            apply_selected_theme("everforest")
        end,
    },

    -- One Dark Pro theme
    {
        "olimorris/onedarkpro.nvim",
        name = "onedark_pro",
        config = function()
            require("onedarkpro").setup({
                options = {
                    transparency = TRANSPARENT_BG,
                },
            })
            apply_selected_theme("onedark")
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
            apply_selected_theme("nord")
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
            apply_selected_theme("moonfly")
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
            apply_selected_theme("vague")
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
            apply_selected_theme("tokyodark")
        end,
    },
}
