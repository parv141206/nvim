-- Just some reasonable vim settings
local opt = vim.opt

-- nvim-treesitter bug: injection query predicates pass nil nodes to
-- vim.treesitter.get_node_text → get_range → node:range() → crash.
-- Must be patched at startup before any plugin triggers treesitter.
local _orig_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts_)
    if node == nil then return "" end
    return _orig_get_node_text(node, source, opts_)
end

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- Behavior
opt.clipboard = "unnamedplus"
opt.swapfile = false

-- Diagnostics UX
-- Show popup only after 5s of no cursor movement
vim.o.updatetime = 5000

vim.diagnostic.config({
	-- End-of-line diagnostic text (VSCode-like)
	virtual_text = {
		spacing = 2,
		source = "if_many",
		prefix = "",
	},
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
		focusable = false,
		header = "",
	},
})

-- Softer end-of-line colors
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { fg = "#b56a6a", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { fg = "#b39a63", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { fg = "#6a92b5", bg = "NONE", italic = true })
vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { fg = "#6aa588", bg = "NONE", italic = true })

-- Hover popup only when cursor stays still (uses updatetime = 5000)
local diag_group = vim.api.nvim_create_augroup("DiagnosticHoverPopup", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
	group = diag_group,
	callback = function()
		local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
		local diags = vim.diagnostic.get(0, { lnum = lnum })
		if #diags == 0 then
			return
		end

		vim.diagnostic.open_float(nil, {
			scope = "cursor",
			focusable = false,
			close_events = {
				"BufLeave",
				"CursorMoved",
				"InsertEnter",
				"FocusLost",
			},
		})
	end,
})

-- Load persisted editor preferences + interactive settings UI
require("core.editor_settings").setup()
