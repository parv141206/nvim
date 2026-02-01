-----------------------------------------------------------
-- Java LSP: Simple single-file configuration for jdtls
-- No build system required - perfect for college practicals
-----------------------------------------------------------
return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
    },
    config = function()
        local jdtls = require("jdtls")
        local mason_registry = require("mason-registry")

        -- Try to get jdtls install path from Mason
        local jdtls_path
        local ok, jdtls_pkg = pcall(mason_registry.get_package, "jdtls")
        if ok and jdtls_pkg:is_installed() then
            jdtls_path = jdtls_pkg.install_path
        else
            -- Fallback: look for jdtls in common locations
            local home = os.getenv("HOME")
            local fallback_paths = {
                home .. "/.local/share/nvim/mason/packages/jdtls",
                home .. "/.mason/packages/jdtls",
                "/usr/local/opt/jdtls",
                "/opt/jdtls",
            }
            
            for _, path in ipairs(fallback_paths) do
                if vim.fn.isdirectory(path) == 1 then
                    jdtls_path = path
                    break
                end
            end
        end

        if not jdtls_path then
            -- Silently fail - don't crash when opening Java files
            return
        end

        -- Find the launcher jar
        local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
        if launcher_jar == "" then
            -- No launcher jar found, silently return
            return
        end

        -- Determine OS for config folder
        local os_config = "config_linux"
        if vim.fn.has("mac") == 1 then
            os_config = "config_mac"
        elseif vim.fn.has("win32") == 1 then
            os_config = "config_win"
        end

        -- Data directory for jdtls workspace (per project/file)
        local data_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

        local config = {
            cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ALL",
                "-Xmx1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", launcher_jar,
                "-configuration", jdtls_path .. "/" .. os_config,
                "-data", data_dir,
            },

            -- THIS is what makes single-file work (no project/build system needed)
            root_dir = vim.fn.getcwd(),

            settings = {
                java = {
                    -- Disable project import prompts
                    import = { enabled = false },
                    maven = { downloadSources = false },
                    eclipse = { downloadSources = false },

                    -- Simple compiler settings
                    configuration = {
                        updateBuildConfiguration = "disabled",
                    },

                    -- Format settings
                    format = {
                        enabled = true,
                        settings = {
                            profile = "GoogleStyle",
                        },
                    },
                },
            },

            -- Disable features that require build systems
            init_options = {
                bundles = {},
            },
        }

        -- Setup autocmd to start jdtls for Java files
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                jdtls.start_or_attach(config)
            end,
        })
    end,
}
