-----------------------------------------------------------
-- Theme Configuration with Dynamic Switching
-----------------------------------------------------------
--
-- Available themes:
-- • "nightfox"    - Dark, sleek theme
-- • "kanagawa"    - Japanese-inspired theme
-- • "tokyonight"  - Modern dark theme
-- • "gruvbox"     - Retro groove theme
-- • "catppuccin"  - Pastel theme with flavours
-- • "night-owl"   - Night Owl theme
--
-- Usage:
--   :ThemeSelect   - Open theme selector
--   :ToggleTransparent - Toggle background transparency
--   :ToggleTransparentUI - Toggle UI transparency
--

local M = {}

-- Config file location
local config_dir = vim.fn.stdpath("config") .. "/lua/core"
local theme_file = config_dir .. "/.theme_config"

-- Default theme
local DEFAULT_THEME = "gruvbox"
local DEFAULT_TRANSPARENT_BG = true
local DEFAULT_TRANSPARENT_UI = true

-- Load saved theme
local function load_theme_config()
    local ok, content = pcall(function()
        return vim.fn.readfile(theme_file)
    end)
    
    if ok and #content > 0 then
        local line = content[1]
        local theme, trans_bg, trans_ui = line:match("(.+):(.+):(.+)")
        if theme then
            return {
                theme = theme,
                transparent_bg = trans_bg == "true",
                transparent_ui = trans_ui == "true",
            }
        end
    end
    
    return {
        theme = DEFAULT_THEME,
        transparent_bg = DEFAULT_TRANSPARENT_BG,
        transparent_ui = DEFAULT_TRANSPARENT_UI,
    }
end

-- Save theme config
local function save_theme_config(theme, trans_bg, trans_ui)
    pcall(function()
        vim.fn.writefile({
            string.format("%s:%s:%s", theme, trans_bg, trans_ui)
        }, theme_file)
    end)
end

M.config = load_theme_config()
M.theme = M.config.theme
M.transparent_bg = M.config.transparent_bg
M.transparent_ui = M.config.transparent_ui

-- Update and save theme
function M.set_theme(theme_name)
    M.theme = theme_name
    M.config.theme = theme_name
    save_theme_config(M.theme, M.transparent_bg, M.transparent_ui)
    vim.cmd.colorscheme(theme_name)
end

-- Toggle transparency
function M.toggle_transparent_bg()
    M.transparent_bg = not M.transparent_bg
    M.config.transparent_bg = M.transparent_bg
    save_theme_config(M.theme, M.transparent_bg, M.transparent_ui)
    vim.notify("Transparent BG: " .. (M.transparent_bg and "ON" or "OFF"))
    -- Reload colorscheme
    vim.cmd.colorscheme(M.theme)
end

function M.toggle_transparent_ui()
    M.transparent_ui = not M.transparent_ui
    M.config.transparent_ui = M.transparent_ui
    save_theme_config(M.theme, M.transparent_bg, M.transparent_ui)
    vim.notify("Transparent UI: " .. (M.transparent_ui and "ON" or "OFF"))
    -- Reload colorscheme
    vim.cmd.colorscheme(M.theme)
end

return M
