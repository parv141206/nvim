-- Language servers, autocomplete, snippets
-- Handles Java, Python, TypeScript, C/C++, etc.
return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },

            -- Completion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "saadparwaiz1/cmp_luasnip" },
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },

            { "ray-x/lsp_signature.nvim" },
        },

        config = function()
            local lsp_zero = require("lsp-zero")
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            local function common_on_attach(_, bufnr)
                lsp_zero.default_keymaps({ buffer = bufnr })
                require("lsp_signature").on_attach({}, bufnr)
            end

            local function dirname(path)
                return (vim.fs and vim.fs.dirname(path)) or vim.fn.fnamemodify(path, ":h")
            end

            local function setup_server(name, config)
                if vim.lsp and vim.lsp.config and vim.lsp.enable then
                    vim.lsp.config(name, config)
                    vim.lsp.enable(name)
                    return
                end

                -- Fallback for older Neovim versions
                require("lspconfig")[name].setup(config)
            end

            --------------------------------------------------
            -- bash-language-server (manual, single-file friendly)
            --------------------------------------------------
            setup_server("bashls", {
                filetypes = { "sh", "bash" },
                root_dir = function(fname)
                    -- Single-file support
                    return dirname(fname)
                end,
                capabilities = capabilities,
                on_attach = common_on_attach,
            })

            --------------------------------------------------
            -- Common LSP servers
            --------------------------------------------------
            local servers = {
                "ts_ls",
                "eslint",
                "tailwindcss",
                "pyright",
                "emmet_ls",
            }

            for _, server in ipairs(servers) do
                setup_server(server, {
                    capabilities = capabilities,
                    on_attach = common_on_attach,
                })
            end

            --------------------------------------------------
            -- clangd (manual, single-file friendly)
            --------------------------------------------------
            setup_server("clangd", {
                cmd = { "clangd", "--background-index" },
                filetypes = { "c", "cpp" },
                root_dir = function(fname)
                    -- THIS is what makes single-file work
                    return dirname(fname)
                end,
                init_options = {
                    fallbackFlags = {
                        "-std=c11",
                        "-Wall",
                        "-Wextra",
                    },
                },
                capabilities = capabilities,
                on_attach = common_on_attach,
            })

            --------------------------------------------------
            -- Completion
            --------------------------------------------------
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                preselect = cmp.PreselectMode.Item,
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-c>"] = cmp.mapping.abort(),
                }),
                window = {
                    completion = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder,CursorLine:PmenuSel,Search:None",
                        scrollbar = true,
                        col_offset = -3,
                        side_padding = 0,
                        max_width = 50,
                        max_height = 15,
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "rounded",
                        winhighlight = "Normal:Pmenu,FloatBorder:PmenuBorder",
                        max_width = 60,
                        max_height = 15,
                    }),
                },
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, vim_item)
                        local kind_icons = {
                            Text = "󰉿",
                            Method = "󰊕",
                            Function = "󰊕",
                            Constructor = "󰒓",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "󰏗",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "󰕘",
                            Keyword = "󰌋",
                            Snippet = "󰅴",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "󰕘",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "󰉁",
                            Operator = "󰆕",
                            TypeParameter = "󰊄",
                        }
                        
                        local item = vim_item
                        item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "?", vim_item.kind or "")
                        
                        -- Add source info with better spacing
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[Snippet]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                        })[entry.source.name] or "[Unknown]"
                        
                        return item
                    end,
                },
                sources = {
                    { name = "nvim_lsp", priority = 100 },
                    { name = "luasnip", priority = 90 },
                    { name = "buffer", priority = 80 },
                    { name = "path", priority = 70 },
                },
            })

            -- 🔑 Connect nvim-cmp with autopairs
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done()
            )
        end,
    },
}
