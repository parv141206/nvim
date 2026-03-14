-----------------------------------------------------------
-- Persistent Editor Settings Manager
--
-- Commands:
--   :EditorSettings      - Open interactive settings picker
--   :EditorSettingsReset - Reset managed settings to defaults
-----------------------------------------------------------

local M = {}

local config_dir = vim.fn.stdpath("config") .. "/lua/core"
local settings_file = config_dir .. "/.editor_settings"

-- Curated set of commonly tweaked editor settings
local SETTINGS = {
    { key = "number", label = "Line numbers", type = "bool", default = true },
    { key = "relativenumber", label = "Relative numbers", type = "bool", default = true },
    { key = "cursorline", label = "Highlight cursor line", type = "bool", default = false },
    { key = "wrap", label = "Line wrap", type = "bool", default = false },
    { key = "linebreak", label = "Wrap at word boundary", type = "bool", default = false },
    { key = "list", label = "Show invisible chars", type = "bool", default = false },
    { key = "spell", label = "Spell check", type = "bool", default = false },
    { key = "hlsearch", label = "Search highlight", type = "bool", default = true },
    { key = "incsearch", label = "Incremental search", type = "bool", default = true },
    { key = "ignorecase", label = "Ignore case search", type = "bool", default = true },
    { key = "smartcase", label = "Smart case search", type = "bool", default = true },
    { key = "expandtab", label = "Use spaces for tabs", type = "bool", default = true },
    { key = "autoindent", label = "Auto indent", type = "bool", default = true },
    { key = "smartindent", label = "Smart indent", type = "bool", default = false },
    { key = "termguicolors", label = "True color", type = "bool", default = true },
    { key = "showmode", label = "Show mode", type = "bool", default = false },
    { key = "splitbelow", label = "Horizontal split below", type = "bool", default = true },
    { key = "splitright", label = "Vertical split right", type = "bool", default = true },
    { key = "swapfile", label = "Swapfile", type = "bool", default = false },
    { key = "undofile", label = "Persistent undo", type = "bool", default = true },

    { key = "tabstop", label = "Tab width", type = "number", min = 1, max = 16, default = 2 },
    { key = "shiftwidth", label = "Indent width", type = "number", min = 1, max = 16, default = 2 },
    { key = "softtabstop", label = "Soft tab width", type = "number", min = -1, max = 16, default = 2 },
    { key = "scrolloff", label = "Scrolloff", type = "number", min = 0, max = 20, default = 8 },
    { key = "sidescrolloff", label = "Sidescrolloff", type = "number", min = 0, max = 20, default = 8 },
    { key = "timeoutlen", label = "Key timeout (ms)", type = "number", min = 100, max = 2000, default = 300 },
    { key = "updatetime", label = "Update time (ms)", type = "number", min = 50, max = 2000, default = 250 },
    { key = "pumheight", label = "Popup menu height", type = "number", min = 5, max = 30, default = 10 },
    { key = "conceallevel", label = "Conceal level", type = "number", min = 0, max = 3, default = 0 },
    { key = "textwidth", label = "Text width", type = "number", min = 0, max = 200, default = 0 },
    { key = "cmdheight", label = "Command line height", type = "number", min = 0, max = 5, default = 1 },
    { key = "linespace", label = "Line height (GUI)", type = "number", min = 0, max = 20, default = 0 },

    {
        key = "signcolumn",
        label = "Sign column",
        type = "enum",
        values = { "auto", "yes", "no", "number" },
        default = "yes",
    },
    {
        key = "background",
        label = "Background",
        type = "enum",
        values = { "dark", "light" },
        default = "dark",
    },
    {
        key = "mouse",
        label = "Mouse mode",
        type = "enum",
        values = { "a", "nvi", "nv", "" },
        default = "a",
    },
    {
        key = "clipboard",
        label = "Clipboard",
        type = "enum",
        values = { "unnamedplus", "unnamed", "" },
        default = "unnamedplus",
    },
}

local SETTINGS_BY_KEY = {}
for _, item in ipairs(SETTINGS) do
    SETTINGS_BY_KEY[item.key] = item
end

local function default_settings()
    local defaults = {}
    for _, item in ipairs(SETTINGS) do
        defaults[item.key] = item.default
    end
    return defaults
end

local function to_value_string(v)
    if type(v) == "boolean" then
        return v and "ON" or "OFF"
    end
    if v == "" then
        return "(empty)"
    end
    return tostring(v)
end

local function save_settings(settings)
    pcall(function()
        vim.fn.writefile({ vim.json.encode(settings) }, settings_file)
    end)
end

local function load_settings()
    local defaults = default_settings()

    local ok, content = pcall(function()
        return vim.fn.readfile(settings_file)
    end)

    if not ok or #content == 0 then
        return defaults
    end

    local decode_ok, decoded = pcall(vim.json.decode, table.concat(content, "\n"))
    if not decode_ok or type(decoded) ~= "table" then
        return defaults
    end

    for key, value in pairs(decoded) do
        if SETTINGS_BY_KEY[key] ~= nil then
            defaults[key] = value
        end
    end

    return defaults
end

local function supports_linespace()
    return vim.g.neovide
        or vim.g.GuiLoaded
        or vim.g.goneovim
        or vim.fn.has("gui_running") == 1
end

local function apply_setting(key, value, silent)
    if key == "linespace" and not supports_linespace() then
        if not silent then
            vim.notify(
                "Line height (linespace) works only in GUI Neovim clients (Neovide/nvim-qt/Goneovim). Terminal Neovim ignores it.",
                vim.log.levels.WARN
            )
        end
        return false
    end

    local ok, err = pcall(function()
        vim.opt[key] = value
    end)

    if not ok and not silent then
        vim.notify(string.format("Failed to apply %s: %s", key, tostring(err)), vim.log.levels.WARN)
    end

    return ok
end

local function apply_settings(settings)
    for _, item in ipairs(SETTINGS) do
        local value = settings[item.key]
        apply_setting(item.key, value, true)
    end
end

local function set_and_persist(settings, key, value)
    settings[key] = value
    apply_setting(key, value, false)
    save_settings(settings)
end

local function has_telescope()
    return pcall(require, "telescope.pickers")
end

local function ui_select(prompt, choices, on_choice)
    if has_telescope() then
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")

        pickers.new({}, {
            prompt_title = prompt,
            finder = finders.new_table({ results = choices }),
            sorter = conf.generic_sorter({}),
            previewer = false,
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    local selection = action_state.get_selected_entry()
                    actions.close(prompt_bufnr)
                    if selection then
                        on_choice(selection.value)
                    end
                end)
                return true
            end,
        }):find()
        return
    end

    vim.ui.select(choices, { prompt = prompt }, on_choice)
end

local function open_number_input(item, current, on_value)
    vim.ui.input({
        prompt = string.format("%s [%s-%s]: ", item.label, item.min, item.max),
        default = tostring(current),
    }, function(input)
        if not input or input == "" then
            return
        end

        local numeric = tonumber(input)
        if not numeric then
            vim.notify("Invalid number", vim.log.levels.WARN)
            return
        end

        numeric = math.floor(numeric)
        if numeric < item.min or numeric > item.max then
            vim.notify(string.format("Value must be between %d and %d", item.min, item.max), vim.log.levels.WARN)
            return
        end

        on_value(numeric)
    end)
end

local function open_settings_picker(settings)
    local entries = {}
    for _, item in ipairs(SETTINGS) do
        local value = settings[item.key]
        table.insert(entries, string.format("%s  %s", item.label, to_value_string(value)))
    end

    ui_select("Editor Settings", entries, function(selected)
        if not selected then
            return
        end

        local idx
        for i, entry in ipairs(entries) do
            if entry == selected then
                idx = i
                break
            end
        end
        if not idx then
            return
        end

        local item = SETTINGS[idx]
        local current = settings[item.key]

        if item.type == "bool" then
            set_and_persist(settings, item.key, not current)
            vim.notify(string.format("%s: %s", item.label, to_value_string(not current)))
            vim.schedule(function()
                open_settings_picker(settings)
            end)
            return
        end

        if item.type == "enum" then
            ui_select(item.label, item.values, function(choice)
                if choice ~= nil then
                    set_and_persist(settings, item.key, choice)
                    vim.notify(string.format("%s: %s", item.label, to_value_string(choice)))
                end
                vim.schedule(function()
                    open_settings_picker(settings)
                end)
            end)
            return
        end

        if item.type == "number" then
            open_number_input(item, current, function(value)
                set_and_persist(settings, item.key, value)
                vim.notify(string.format("%s: %s", item.label, to_value_string(value)))
                vim.schedule(function()
                    open_settings_picker(settings)
                end)
            end)
        end
    end)
end

function M.setup()
    M.settings = load_settings()
    apply_settings(M.settings)

    vim.api.nvim_create_user_command("EditorSettings", function()
        open_settings_picker(M.settings)
    end, {})

    vim.api.nvim_create_user_command("EditorSettingsReset", function()
        M.settings = default_settings()
        apply_settings(M.settings)
        save_settings(M.settings)
        vim.notify("Editor settings reset to defaults")
    end, {})
end

return M
