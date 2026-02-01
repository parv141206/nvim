# My Neovim Config

A lightweight, highly customizable Neovim setup for college practicals, general coding, and not spending 3 hours configuring things (too late for that).

## What's Inside

```
init.lua                    Main entry point
lazy-lock.json             Keep things reproducible
lua/
├── core/
│   ├── keymaps.lua        All your keybinds
│   ├── options.lua        Editor settings
│   └── theme.lua          Theme management
└── plugins/
    ├── ui/                Colors, statusline, tabs
    ├── editor/            File explorer, search, code understanding
    ├── lsp/               Language servers & autocomplete
    ├── tools/             Formatting, git, comments
    └── integrations/      GitHub Copilot stuff
```

## Getting Started

1. Have Neovim 0.9+ installed (obviously)
2. Clone to `~/.config/nvim`
3. Open Neovim and wait for plugins to install
4. Done. Seriously.

For Copilot stuff:
- Run `:Copilot auth` to login
- Use `Leader+COP` to toggle it on/off

## Switching Themes

Don't like the current theme? Run `:ThemeSelect` to pick from 12 different themes.

Transparent backgrounds not your thing? Use:
- `:ToggleTransparent` - Toggle background transparency
- `:ToggleTransparentUI` - Toggle UI transparency

Your choice gets saved automatically.

### Available Themes

nightfox, kanagawa, tokyonight, gruvbox, catppuccin, night-owl, rose-pine, everforest, onedarkpro, nord, moonfly, tokyodark

## Keyboard Shortcuts

**Window Navigation**
- `Ctrl+H/J/K/L` - Move between windows (vim style)

**Files & Search**
- `Leader+E` - File explorer
- `Leader+FF` - Find files
- `Leader+FG` - Grep text

**Editing**
- `Leader+/` - Toggle comment
- `Leader+P` - Format code

**Git (via Fugitive + Gitsigns)**
- `Leader+GS` - Status
- `Leader+GD` - Diff
- `Leader+GB` - Blame
- `Leader+GC` - Commit

**Copilot**
- `Leader+COP` - Toggle Copilot
- `Leader+CCH` - Chat
- `Leader+CCE` - Explain code
- `Leader+CCR` - Review code

**Buffers**
- `Shift+H/L` - Previous/next buffer

## Adding More Stuff

Want to add a plugin? Just create a new file in the appropriate folder under `lua/plugins/` and it'll auto-load.

The config is pretty self-explanatory if you poke around a bit.

## Notes

- Single-file Java support for college practicals
- Tab completion in the completion menu (press Tab to move through suggestions)
- Everything just works™

