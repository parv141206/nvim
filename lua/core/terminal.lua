local M = {}

local term_buf = nil
local term_win = nil
local term_job_id = nil

function M.toggle()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.api.nvim_win_hide(term_win)
		term_win = nil -- Mark as hidden
	elseif term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		-- It exists but is hidden, so unhide it
		local height = math.floor(vim.o.lines * 0.25)
		local width = vim.o.columns
		local top = vim.o.lines - height
		local left = 0

		term_win = vim.api.nvim_open_win(term_buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = top,
			col = left,
			style = "minimal",
			border = "rounded",
			noautocmd = true,
		})
		vim.api.nvim_set_option_value("winhl", "Normal:Normal,NormalFloat:Normal", { win = term_win })
	else
		-- It doesn't exist, create it for the first time
		local height = math.floor(vim.o.lines * 0.25)
		local width = vim.o.columns
		local top = vim.o.lines - height
		local left = 0

		term_buf = vim.api.nvim_create_buf(false, true)
		term_win = vim.api.nvim_open_win(term_buf, true, {
			relative = "editor",
			width = width,
			height = height,
			row = top,
			col = left,
			style = "minimal",
			border = "rounded",
			noautocmd = true,
		})

		term_job_id = vim.fn.termopen(vim.o.shell, {
			on_exit = function()
				-- When the shell process inside the terminal exits, clean up everything.
				if term_win and vim.api.nvim_win_is_valid(term_win) then
					vim.api.nvim_win_close(term_win, true)
				end
				term_buf = nil
				term_win = nil
				term_job_id = nil
			end,
		})

		vim.api.nvim_set_option_value("winhl", "Normal:Normal,NormalFloat:Normal", { win = term_win })
		vim.cmd("startinsert")
	end
end

return M
