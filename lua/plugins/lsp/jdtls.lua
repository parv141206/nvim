-- Java support for college practicals
-- Works with single files, no Maven/Gradle needed
return {
    "mfussenegger/nvim-jdtls",
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
            jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
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

        if vim.fn.executable("java") == 0 then
            vim.notify("Java runtime not found in PATH (required for jdtls)", vim.log.levels.WARN)
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

        local function get_root_dir(bufname)
            -- Pure single-file mode: one root per file directory (no project import assumptions)
            return (vim.fs and vim.fs.dirname(bufname)) or vim.fn.fnamemodify(bufname, ":h")
        end

        local function path_to_workspace(root_dir)
            local project_name = vim.fn.fnamemodify(root_dir, ":p:t")
            if project_name == "" then
                project_name = "single_file"
            end
            local full = vim.fn.fnamemodify(root_dir, ":p")
            local suffix = full:gsub("[^%w_%-]", "_")
            local safe = project_name .. "_" .. suffix
            return vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. safe
        end

        local function collect_bundles()
            local bundles = {}

            local function append(pattern)
                for _, jar in ipairs(vim.split(vim.fn.glob(pattern), "\n", { trimempty = true })) do
                    table.insert(bundles, jar)
                end
            end

            local ok_debug, debug_pkg = pcall(mason_registry.get_package, "java-debug-adapter")
            if ok_debug and debug_pkg:is_installed() then
                append(vim.fn.stdpath("data") .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
            end

            local ok_test, test_pkg = pcall(mason_registry.get_package, "java-test")
            if ok_test and test_pkg:is_installed() then
                append(vim.fn.stdpath("data") .. "/mason/packages/java-test/extension/server/*.jar")
            end

            return bundles
        end

        local function make_config(bufname)
            local root_dir = get_root_dir(bufname)
            local workspace_dir = path_to_workspace(root_dir)

            local cmd = {
                "java",
                "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                "-Dosgi.bundles.defaultStartLevel=4",
                "-Declipse.product=org.eclipse.jdt.ls.core.product",
                "-Dlog.protocol=true",
                "-Dlog.level=ERROR",
                "-Xms1g",
                "--add-modules=ALL-SYSTEM",
                "--add-opens", "java.base/java.util=ALL-UNNAMED",
                "--add-opens", "java.base/java.lang=ALL-UNNAMED",
                "-jar", launcher_jar,
                "-configuration", jdtls_path .. "/" .. os_config,
                "-data", workspace_dir,
            }

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            if ok_cmp then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            return {
                cmd = cmd,
                root_dir = root_dir,
                capabilities = capabilities,
                settings = {
                    java = {
                        eclipse = { downloadSources = true },
                        maven = { downloadSources = true },
                        configuration = {
                            updateBuildConfiguration = "interactive",
                            runtimes = {},
                        },
                        references = {
                            includeDecompiledSources = true,
                        },
                        format = {
                            enabled = true,
                        },
                        implementationCodeLens = { enabled = true },
                        referencesCodeLens = { enabled = true },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all",
                            },
                        },
                    },
                },
                init_options = {
                    bundles = collect_bundles(),
                },
                on_attach = function(_, bufnr)
                    local map = vim.keymap.set
                    local opts = { buffer = bufnr, silent = true }
                    map("n", "<leader>jo", jdtls.organize_imports, vim.tbl_extend("force", opts, { desc = "Java organize imports" }))
                    map("n", "<leader>jv", jdtls.extract_variable, vim.tbl_extend("force", opts, { desc = "Java extract variable" }))
                    map("v", "<leader>jv", function()
                        jdtls.extract_variable(true)
                    end, vim.tbl_extend("force", opts, { desc = "Java extract variable" }))
                    map("n", "<leader>jc", jdtls.extract_constant, vim.tbl_extend("force", opts, { desc = "Java extract constant" }))
                    map("v", "<leader>jc", function()
                        jdtls.extract_constant(true)
                    end, vim.tbl_extend("force", opts, { desc = "Java extract constant" }))
                    map("v", "<leader>jm", function()
                        jdtls.extract_method(true)
                    end, vim.tbl_extend("force", opts, { desc = "Java extract method" }))
                end,
            }
        end

        local group = vim.api.nvim_create_augroup("JavaJdtls", { clear = true })

        local function start_for_buf(bufnr)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname == "" then
                return
            end
            if not bufname:match("%.java$") then
                return
            end
            jdtls.start_or_attach(make_config(bufname))
        end

        vim.api.nvim_create_autocmd({ "FileType" }, {
            group = group,
            pattern = "java",
            callback = function(args)
                start_for_buf(args.buf)
            end,
        })

        -- Lazy-loading on FileType can miss the original event for the first buffer.
        -- Ensure the currently open Java buffer is attached immediately.
        if vim.bo.filetype == "java" then
            start_for_buf(vim.api.nvim_get_current_buf())
        end
    end,
}
