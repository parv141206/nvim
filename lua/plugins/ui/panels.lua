-- Right side panels using edgy.nvim for proper layout management

return {
    -- Edgy manages window layouts properly
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        opts = {
            right = {
                { ft = "Outline", size = { width = 35 } },
                { ft = "fugitive", size = { height = 15 } },
                { ft = "trouble", size = { height = 10 } },
            },
            animate = { enabled = false },
        },
    },
    
    -- Outline plugin
    {
        "hedyhli/outline.nvim",
        lazy = false,
        opts = {
            outline_window = {
                position = "right",
                width = 35,
                focus_on_open = false,
            },
        },
    },
    
    -- Trouble for diagnostics
    {
        "folke/trouble.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            focus = false,
            auto_close = false,
            win = {
                position = "right",
                size = { height = 10 },
            },
        },
    },
    
    -- Setup keybinds and auto-open
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
        config = function()
            vim.keymap.set("n", "<leader>uo", "<cmd>Outline<CR>", { desc = "Toggle Outline" })
            vim.keymap.set("n", "<leader>ud", "<cmd>Trouble diagnostics toggle<CR>", { desc = "Toggle Diagnostics" })
            vim.keymap.set("n", "<leader>ug", "<cmd>Git<CR>", { desc = "Git Status" })
            
            -- Open panels on startup
            vim.api.nvim_create_autocmd("VimEnter", {
                once = true,
                callback = function()
                    vim.defer_fn(function()
                        local main_win = vim.api.nvim_get_current_win()
                        pcall(function() vim.cmd("OutlineOpen") end)
                        vim.defer_fn(function()
                            pcall(function() vim.cmd("Trouble diagnostics open") end)
                            vim.defer_fn(function()
                                pcall(function() vim.cmd("Git") end)
                                vim.defer_fn(function()
                                    pcall(function() vim.api.nvim_set_current_win(main_win) end)
                                end, 50)
                            end, 50)
                        end, 50)
                    end, 300)
                end,
            })
        end,
    },
}
