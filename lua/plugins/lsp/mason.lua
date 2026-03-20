-- Auto-install language servers and tools
return {
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup({})

        -- Skip auto-installs in headless mode (prevents abort warnings on quick exits)
        if #vim.api.nvim_list_uis() == 0 then
            return
        end

        local ensure_installed = {
            "prettierd", "eslint_d", "stylua", "shfmt", "black",
            "jdtls",                -- Java LSP for single-file development
            "java-debug-adapter",   -- Java debugging support
            "java-test",            -- Java test runner support
            "bash-language-server", -- Bash LSP
            "rust-analyzer",        -- Rust LSP
            "rustfmt",              -- Rust formatter
            "codelldb",             -- Rust debugger (DAP)
        }

        local registry = require("mason-registry")
        registry.refresh(function()
            for _, tool in ipairs(ensure_installed) do
                local ok, pkg = pcall(registry.get_package, tool)
                if ok and not pkg:is_installed() then
                    pkg:install()
                end
            end
        end)
    end,
}
