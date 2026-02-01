-----------------------------------------------------------
-- Mason: Package manager for LSP, formatters, linters
-----------------------------------------------------------
return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "prettierd", "eslint_d", "stylua", "shfmt", "black",
            "jdtls",                -- Java LSP for single-file development
            "bash-language-server", -- Bash LSP
        },
    },
}
