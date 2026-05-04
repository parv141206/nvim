-- REST client for .http files (no LuaRocks dependency chain)
return {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    config = function()
        require("kulala").setup()

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "http", "rest" },
            callback = function(ev)
                vim.keymap.set({ "n", "v" }, "xr", function()
                    require("kulala").run()
                end, {
                    buffer = ev.buf,
                    desc = "Kulala: Run current request",
                })
            end,
        })
    end,
}
