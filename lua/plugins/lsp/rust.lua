-- Rust support (LSP + Cargo diagnostics)
return {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    dependencies = {
        "VonHeikemen/lsp-zero.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        vim.g.rustaceanvim = {
            server = {
                on_attach = function(_, bufnr)
                    local ok_lsp_zero, lsp_zero = pcall(require, "lsp-zero")
                    if ok_lsp_zero then
                        lsp_zero.default_keymaps({ buffer = bufnr })
                    end

                    local ok_signature, lsp_signature = pcall(require, "lsp_signature")
                    if ok_signature then
                        lsp_signature.on_attach({}, bufnr)
                    end
                end,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        checkOnSave = true,
                        check = {
                            command = "clippy",
                        },
                        procMacro = {
                            enable = true,
                        },
                        inlayHints = {
                            bindingModeHints = { enable = true },
                            closureReturnTypeHints = { enable = "always" },
                            lifetimeElisionHints = {
                                enable = "skip_trivial",
                                useParameterNames = true,
                            },
                        },
                    },
                },
            },
        }
    end,
}
