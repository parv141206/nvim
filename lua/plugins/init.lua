-- Main plugin loader for Lazy.nvim
-- This file is the entry point for all plugins

return {
    -- UI Plugins
    require("plugins.ui.themes"),
    require("plugins.ui.lualine"),
    require("plugins.ui.bufferline"),
    require("plugins.ui.indent-blankline"),
    require("plugins.ui.which-key"),

    -- Editor Plugins
    require("plugins.editor.telescope"),
    require("plugins.editor.neo-tree"),
    require("plugins.editor.treesitter"),

    -- LSP Plugins
    require("plugins.lsp.lsp-zero"),
    require("plugins.lsp.mason"),
    require("plugins.lsp.jdtls"),

    -- Tools
    require("plugins.tools.conform"),
    require("plugins.tools.comment"),
    require("plugins.tools.fugitive"),
    require("plugins.tools.gitsigns"),
    require("plugins.tools.autopair"),

    -- Integrations
    require("plugins.integrations.copilot"),
    require("plugins.integrations.copilot-chat"),
}
