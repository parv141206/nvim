---
-- Neovim Configuration - Organized with Lazy.nvim
-- Structure Overview
---

-- File Structure:
-- ├── init.lua (Main config entry point)
-- ├── lazy-lock.json (Locked plugin versions)
-- └── lua/
-- ├── core/
-- │ ├── keymaps.lua (Global keybindings)
-- │ └── options.lua (Editor options)
-- └── plugins/
-- ├── init.lua (Main plugin loader)
-- ├── ui/ (UI & Visual plugins)
-- │ ├── themes.lua (Colorschemes)
-- │ ├── lualine.lua (Statusline)
-- │ ├── bufferline.lua (Buffer tabs)
-- │ ├── indent-blankline.lua (Indent guides)
-- │ └── which-key.lua (Keymap hints)
-- ├── editor/ (Editor functionality)
-- │ ├── telescope.lua (Fuzzy finder)
-- │ ├── neo-tree.lua (File explorer)
-- │ └── treesitter.lua (Syntax & code understanding)
-- ├── lsp/ (Language servers & completion)
-- │ ├── lsp-zero.lua (LSP config & completion)
-- │ └── mason.lua (Package manager)
-- ├── tools/ (Development tools)
-- │ ├── conform.lua (Formatting)
-- │ ├── comment.lua (Code commenting)
-- │ ├── fugitive.lua (Git integration)
-- │ └── gitsigns.lua (Git diff/blame)
-- └── integrations/ (Third-party integrations)
-- ├── copilot.lua (GitHub Copilot AI)
-- └── copilot-chat.lua (Copilot Chat interface)

---

## -- Quick Keybinding Reference

-- WINDOW NAVIGATION
-- Ctrl+H - Focus left window
-- Ctrl+J - Focus lower window
-- Ctrl+K - Focus upper window
-- Ctrl+L - Focus right window

-- COMMENT TOGGLING
-- Leader+/ - Toggle comment on current line (any language)
-- Leader+/ - Toggle comment on selection (visual mode)

-- FILE EXPLORER
-- Leader+E - Toggle Neo-tree file explorer

-- FIND/SEARCH
-- Leader+FF - Find files
-- Leader+FG - Grep text
-- Leader+UT - Change colorscheme

-- FORMATTING
-- Leader+P - Format file or selection

-- GIT OPERATIONS
-- Leader+GS - Git status
-- Leader+GD - Git diff
-- Leader+GC - Git commit
-- Leader+GB - Git blame
-- Leader+GL - Git log
-- Leader+GP - Git push
-- Leader+GU - Git pull

-- GIT SIGNS
-- Leader+GHB - Blame line
-- Leader+GHD - Diff this
-- Leader+GHH - Preview hunk

-- COPILOT
-- Leader+COP - Toggle Copilot
-- Leader+CCH - Copilot Chat Open
-- Leader+CCE - Copilot explain code
-- Leader+CCR - Copilot review code
-- Leader+CCF - Copilot fix code

-- BUFFER NAVIGATION
-- Shift+H - Previous buffer
-- Shift+L - Next buffer

---

## -- Setup Instructions

-- 1. Ensure Neovim (v0.9.0+) is installed
-- 2. Clone this config to ~/.config/nvim
-- 3. Open Neovim - plugins will auto-install
-- 4. Wait for lazy.nvim to finish syncing
-- 5. Configure GitHub Copilot:
-- - Run `:Copilot auth` to authenticate
-- - Use Leader+COP to toggle Copilot
-- - Use Leader+CCH for chat interface

---

## -- Changing Your Theme

-- TO CHANGE THE COLORSCHEME:
-- 1. Open: lua/core/theme.lua
-- 2. Edit line 16: M.theme = "nightfox"
-- 3. Choose from:
-- • "nightfox" - Sleek dark theme (default)
-- • "kanagawa" - Japanese-inspired
-- • "tokyonight" - Modern dark theme
-- • "gruvbox" - Retro groove theme
-- 4. Save and restart Neovim
--
-- The statusline will automatically adapt to your chosen theme!

---

## -- Adding New Plugins

-- UI Plugins: Add to lua/plugins/ui/_.lua
-- Editor Plugins: Add to lua/plugins/editor/_.lua
-- LSP Plugins: Add to lua/plugins/lsp/_.lua
-- Tools: Add to lua/plugins/tools/_.lua
-- Integrations: Add to lua/plugins/integrations/\*.lua

-- Then update lua/plugins/init.lua to include the new file:
-- require("plugins.category.pluginname")
