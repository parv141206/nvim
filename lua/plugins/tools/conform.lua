-----------------------------------------------------------
-- Conform: Auto-formatting on save
-----------------------------------------------------------
return {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
            formatters_by_ft = {
                javascript = { "prettierd", "eslint_d" },
                javascriptreact = { "prettierd", "eslint_d" },
                typescript = { "prettierd", "eslint_d" },
                typescriptreact = { "prettierd", "eslint_d" },
                vue = { "prettierd", "eslint_d" },
                css = { "prettierd" },
                scss = { "prettierd" },
                less = { "prettierd" },
                html = { "prettierd" },
                json = { "prettierd" },
                yaml = { "prettierd" },
                markdown = { "prettierd" },
                graphql = { "prettierd" },
                lua = { "stylua" },
                python = { "black" },
                sh = { "shfmt" },
                go = { "gofmt" },
                rust = { "rustfmt" },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>p", function()
            conform.format({ lsp_fallback = true, async = false, timeout_ms = 500 })
        end, { desc = "Format file or range" })
    end,
}
