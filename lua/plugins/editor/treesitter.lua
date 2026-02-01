-----------------------------------------------------------
-- Treesitter: Syntax highlighting and code understanding
-----------------------------------------------------------
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("nvim-treesitter.configs").setup({
            ensure_installed = {
                "javascript", "typescript", "tsx", "html", "css",
                "json", "jsonc", "yaml", "markdown", "markdown_inline",
                "python", "lua", "bash", "c", "cpp",
                "regex", "gitignore", "gitcommit",
            },
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm",
                },
            },
        })
    end,
}
