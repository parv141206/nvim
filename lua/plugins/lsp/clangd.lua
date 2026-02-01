local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

lspconfig.clangd.setup({
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--fallback-style=LLVM",
    },

    filetypes = { "c", "cpp" },

    root_dir = function(fname)
        -- Treat every file as its own project
        return util.path.dirname(fname)
    end,

    init_options = {
        fallbackFlags = {
            "-std=c11",
            "-Wall",
            "-Wextra",
            "-Wpedantic",
        },
    },
})

