-- ===========================================================================
-- NEOVIM CONFIG ORGANIZATION GUIDE
-- ===========================================================================

-- ===========================================================================
-- DIRECTORY STRUCTURE EXPLANATION
-- ===========================================================================

-- Your config is now organized into these main sections:

-- 1. CORE SETTINGS (lua/core/)
--    • options.lua    - Vim settings (tabs, numbers, colors, etc.)
--    • keymaps.lua    - Global keybindings

-- 2. PLUGINS (lua/plugins/)
--    Organized by purpose for easy navigation and maintenance:

--    UI/             - Visual appearance and interface
--                      • themes.lua        - Colorschemes
--                      • lualine.lua       - Status bar
--                      • bufferline.lua    - Tab bar
--                      • indent-blankline.lua - Indentation guides
--                      • which-key.lua     - Keymap helper popup

--    EDITOR/         - Editing and navigation tools
--                      • telescope.lua     - Fuzzy file/text search
--                      • neo-tree.lua      - File explorer sidebar
--                      • treesitter.lua    - Code syntax/highlighting

--    LSP/            - Language servers and code completion
--                      • lsp-zero.lua      - LSP setup + autocomplete
--                      • mason.lua         - Package manager

--    TOOLS/          - Development utilities
--                      • conform.lua       - Code formatting
--                      • comment.lua       - Line/block commenting
--                      • fugitive.lua      - Git commands (stage, commit, diff)
--                      • gitsigns.lua      - Git diff in margin + blame

--    INTEGRATIONS/   - Third-party service integrations
--                      • copilot.lua       - GitHub Copilot (AI suggestions)
--                      • copilot-chat.lua  - Copilot Chat (AI chat interface)

-- ===========================================================================
-- KEY FEATURES & KEYBINDINGS
-- ===========================================================================

-- WINDOW NAVIGATION
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Ctrl+H, Ctrl+J, Ctrl+K, Ctrl+L                                  │
-- │ Move focus between split windows (left, down, up, right)        │
-- └─────────────────────────────────────────────────────────────────┘

-- COMMENT TOGGLE (NEW!)
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + /  (normal mode)                                       │
-- │ Comment/uncomment current line in ANY programming language      │
-- │                                                                   │
-- │ Leader + /  (visual mode)                                       │
-- │ Comment/uncomment selected lines in ANY programming language    │
-- │                                                                   │
-- │ Works with: Python, JavaScript, C, Lua, Bash, SQL, HTML, etc.   │
-- └─────────────────────────────────────────────────────────────────┘

-- FILE EXPLORER
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + E    Open/close file explorer (Neo-tree)               │
-- └─────────────────────────────────────────────────────────────────┘

-- FUZZY FINDER
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + FF   Find files                                        │
-- │ Leader + FG   Search text in project (grep)                     │
-- │ Leader + UT   Change colorscheme                                │
-- └─────────────────────────────────────────────────────────────────┘

-- CODE FORMATTING
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + P    Format current file or selection                  │
-- │               (auto-formats on save too)                        │
-- └─────────────────────────────────────────────────────────────────┘

-- GIT COMMANDS (Fugitive)
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + GS   Git status (shows all changes)                    │
-- │ Leader + GD   Git diff (view changes in split)                  │
-- │ Leader + GC   Git commit (write commit message)                 │
-- │ Leader + GB   Git blame (show who changed each line)            │
-- │ Leader + GL   Git log (view commit history)                     │
-- │ Leader + GP   Git push (push to remote)                         │
-- │ Leader + GU   Git pull (fetch from remote)                      │
-- └─────────────────────────────────────────────────────────────────┘

-- GIT SIGNS (Gitsigns)
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + GHB  Blame current line (shows in popup)               │
-- │ Leader + GHD  Diff current file                                 │
-- │ Leader + GHH  Preview current hunk (change)                     │
-- │                                                                   │
-- │ Visual: Signs (│) appear in left margin showing changed lines   │
-- │ Hover: Shows who changed each line (blame)                      │
-- └─────────────────────────────────────────────────────────────────┘

-- GITHUB COPILOT (NEW!)
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Leader + COP    Toggle Copilot on/off                           │
-- │                                                                   │
-- │ While typing:                                                   │
-- │ Tab             Accept Copilot suggestion                       │
-- │ Ctrl+]          Dismiss suggestion                              │
-- │ Alt+]           Next suggestion                                 │
-- │ Alt+[           Previous suggestion                             │
-- └─────────────────────────────────────────────────────────────────┘

-- COPILOT CHAT (NEW!)
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Normal Mode:                                                    │
-- │ Leader + CCH    Open chat interface                             │
-- │ Leader + CCE    Explain selected code                           │
-- │ Leader + CCR    Review selected code                            │
-- │ Leader + CCF    Fix/debug selected code                         │
-- │                                                                   │
-- │ Visual Mode:                                                    │
-- │ Same keybindings work on selected text                          │
-- │ (select code first, then press keybinding)                      │
-- └─────────────────────────────────────────────────────────────────┘

-- BUFFER NAVIGATION
-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Shift + H     Go to previous buffer (left tab)                  │
-- │ Shift + L     Go to next buffer (right tab)                     │
-- └─────────────────────────────────────────────────────────────────┘

-- ===========================================================================
-- SETUP & FIRST RUN
-- ===========================================================================

-- 1. START NEOVIM
--    nvim
--
--    Lazy.nvim will automatically download and install all plugins
--    (watch the progress bar at the bottom)

-- 2. WAIT FOR PLUGINS TO INSTALL
--    All plugins listed below will be downloaded
--    This takes 1-2 minutes on first run

-- 3. SETUP GITHUB COPILOT (OPTIONAL)
--    :Copilot auth
--    Opens browser to authenticate with GitHub
--    After auth, you get:
--      • Code suggestions while typing
--      • Copilot Chat for code explanations & fixes

-- 4. TEST FEATURES
--    Try the keybindings above!
--    Comment a line: Leader + /
--    Open file explorer: Leader + E
--    Search for a file: Leader + FF

-- ===========================================================================
-- INSTALLED PLUGINS SUMMARY
-- ===========================================================================

-- UI PLUGINS (5)
-- • nightfox.nvim, kanagawa.nvim, tokyonight.nvim, gruvbox  - Themes
-- • lualine.nvim                - Statusline (bottom)
-- • bufferline.nvim             - Tab bar (open files)
-- • indent-blankline.nvim       - Indent guides
-- • which-key.nvim              - Keymap hint popup

-- EDITOR PLUGINS (3)
-- • telescope.nvim              - Fuzzy find files/text
-- • neo-tree.nvim               - File explorer sidebar
-- • nvim-treesitter             - Syntax highlighting

-- LSP & COMPLETION (8)
-- • lsp-zero.nvim               - LSP configuration
-- • nvim-lspconfig              - Language server config
-- • mason.nvim                  - Plugin/LSP installer
-- • nvim-cmp                    - Autocompletion menu
-- • LuaSnip                     - Code snippets
-- • friendly-snippets           - Pre-made snippets
-- • tailwindcss-colorizer-cmp   - Color preview
-- • lsp_signature.nvim          - Function signature help

-- TOOLS (4)
-- • conform.nvim                - Code formatter
-- • Comment.nvim                - Line/block comment toggle
-- • vim-fugitive                - Git integration
-- • gitsigns.nvim               - Git diff signs & blame

-- INTEGRATIONS (2)
-- • copilot.vim                 - GitHub Copilot AI
-- • CopilotChat.nvim            - Copilot Chat

-- UTILITIES
-- • lazy.nvim                   - Plugin manager
-- • plenary.nvim                - Lua utilities
-- • nui.nvim                    - UI components

-- ===========================================================================
-- CUSTOMIZATION
-- ===========================================================================

-- ADDING A NEW PLUGIN:

-- 1. Create file in appropriate category:
--    Example: lua/plugins/tools/my-plugin.lua

-- 2. Write plugin config:
--    return {
--      "author/plugin-name",
--      config = function()
--        -- setup here
--      end,
--    }

-- 3. Add to lua/plugins/init.lua:
--    require("plugins.tools.my-plugin"),

-- MODIFYING KEYBINDINGS:

-- 1. Edit lua/core/keymaps.lua
-- 2. Add/change vim.keymap.set() calls
-- 3. Example:
--    vim.keymap.set("n", "<leader>xx", ":MyCommand<CR>", { desc = "My command" })

-- CHANGING THEME:

-- 1. In lua/plugins/ui/themes.lua
-- 2. Uncomment desired colorscheme in config section
-- 3. Or use: Leader + UT in Neovim to pick a theme

-- ===========================================================================
-- TROUBLESHOOTING
-- ===========================================================================

-- PLUGINS NOT LOADING?
-- • Run :Lazy to see status
-- • Check :Lazy sync to update plugins
-- • Look for error messages in :messages

-- COPILOT NOT WORKING?
-- • Ensure you ran :Copilot auth
-- • Check :Copilot status
-- • Verify GitHub token is valid

-- FORMATTING NOT WORKING?
-- • Install formatters: :Mason
-- • Search and install formatters (prettier, black, etc.)
-- • See conform.lua for configured formatters

-- SLOW STARTUP?
-- • Check :Lazy for slow plugins
-- • Run :Lazy profile to find bottlenecks
-- • Consider lazy-loading plugins with event/cmd

-- ===========================================================================
-- USEFUL COMMANDS
-- ===========================================================================

-- :Lazy              - Plugin manager interface
-- :Lazy sync         - Update all plugins
-- :Lazy clean        - Remove unused plugins
-- :Mason             - Language server/formatter installer
-- :Telescope         - Fuzzy finder (manual)
-- :Neotree toggle    - Toggle file explorer
-- :CopilotChat       - Open Copilot chat
-- :ConformInfo       - Show formatter info
-- :Gitsigns blame    - Show git blame
-- :Git [command]     - Run git command

-- ===========================================================================
-- NEXT STEPS
-- ===========================================================================

-- 1. Familiarize with the keybindings above
-- 2. Customize colors/theme in lua/plugins/ui/themes.lua
-- 3. Install language servers in :Mason for your languages
-- 4. Setup Copilot for AI assistance
-- 5. Add more plugins/tools as needed
-- 6. Enjoy your organized, powerful Neovim setup!

-- ===========================================================================
