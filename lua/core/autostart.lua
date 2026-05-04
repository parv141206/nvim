local M = {}

local function find_main_file(cwd)
	local root = vim.fn.fnamemodify(cwd, ":p")
	local candidates = {
		-- Rust / Go / C-family / Python / Lua
		"main.rs",
		"main.go",
		"main.c",
		"main.cpp",
		"main.py",
		"app.py",
		"main.lua",
		"init.lua",
		-- JS / TS / React / Node
		"index.ts",
		"index.js",
		"main.ts",
		"main.js",
		"App.tsx",
		"App.jsx",
		-- Java
		"Main.java",
		"Application.java",
	}

	local function rel_depth(abs)
		local rel = vim.fn.fnamemodify(abs, ":.")
		if rel:sub(1, 1) == "/" then
			local root_no_slash = root:gsub("/+$", "")
			rel = rel:gsub("^" .. vim.pesc(root_no_slash .. "/"), "")
		end
		local _, count = rel:gsub("/", "")
		return count
	end

	for _, name in ipairs(candidates) do
		local matches = vim.fs.find({ name }, {
			path = root,
			upward = false,
			type = "file",
			limit = math.huge,
		})
		if type(matches) == "table" and #matches > 0 then
			table.sort(matches, function(a, b)
				local da = rel_depth(a)
				local db = rel_depth(b)
				if da == db then
					return a < b
				end
				return da < db
			end)

			for _, abs in ipairs(matches) do
				if rel_depth(abs) <= 2 and vim.fn.filereadable(abs) == 1 then
					return abs
				end
			end
		end
	end

	return nil
end

function M.setup()
	vim.api.nvim_create_autocmd("VimEnter", {
		once = true,
		callback = function()
			vim.defer_fn(function()
				-- Only run for: nvim <directory>
				if vim.fn.argc() ~= 1 then
					return
				end

				local arg = vim.fn.argv(0)
				if vim.fn.isdirectory(arg) ~= 1 then
					return
				end

				local root = vim.fn.fnamemodify(arg, ":p")
				local entry = find_main_file(root)
				if entry then
					vim.cmd("edit " .. vim.fn.fnameescape(entry))
				end
			end, 150)
		end,
	})
end

return M
