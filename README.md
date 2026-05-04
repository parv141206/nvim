# Neovim Config

Personal Lua-based Neovim setup with LSP, Telescope, Neo-tree, Treesitter, Git tools, themes, and persistent editor settings.

## Features

- `lazy.nvim` plugin management
- LSP setup (including Java single-file support via `jdtls`)
- Telescope-powered workflows
- Neo-tree file explorer
- Treesitter highlighting and text objects
- Git integrations (`gitsigns`, `fugitive`)
- REST API testing inside Neovim (`kulala.nvim`)
- Theme selector with persistence
- Editor settings UI with persistence (`:EditorSettings`)
- Toggleable persistent floating terminal (`Alt+i`)
- VSCode-like diagnostics (inline text + delayed hover popup)

## Project Structure

```text
init.lua
lua/
    core/
        options.lua
        keymaps.lua
        theme.lua
        editor_settings.lua
        terminal.lua
    plugins/
        editor/
        integrations/
        lsp/
        tools/
        ui/
```

## Keymaps (important)

- Window focus: `Ctrl+h/j/k/l`
- Window focus (alt): `Alt+h/l/up/down`
- Resize splits: `Ctrl+Shift+Arrow`
- Move current line: `Alt+j/k`
- Insert at end of line: `I`
- New line below from insert mode: `Ctrl+Enter`
- Toggle floating terminal: `Alt+i`
- Exit terminal mode: `Esc Esc`
- Open editor settings UI: `<leader>ue`
- Run current HTTP request: `xr` (inside `.http` / `.rest` files)

## Diagnostics Behavior

- Inline diagnostic messages show near end-of-line (subtle, low-opacity style)
- Hover popup opens only after 5 seconds of no cursor movement
- Signs (`E/W/I/H`) and underlines remain enabled

## REST Client Usage (`kulala.nvim`)

1. Create a file like `api.http`.
2. Write requests, for example:

```http
GET https://jsonplaceholder.typicode.com/todos/1

###

POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json

{
    "title": "foo",
    "body": "bar",
    "userId": 1
}
```

3. Put cursor inside a request and use kulala actions (default mappings/commands).

Tip: run `:help kulala` for exact mappings and commands in your installed version.
