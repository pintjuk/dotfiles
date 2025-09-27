vim.env.PATH = vim.env.PATH .. ':/opt/homebrew/bin'
-- Function to format current buffer with buf format
local function format_buf()
	local filepath = vim.fn.expand("%:p")
	local view = vim.fn.winsaveview()

	vim.fn.jobstart({ "buf", "format", filepath }, {
		stdout_buffered = true,
		on_stdout = function(_, data)
			if not data then return end

			local lines = vim.tbl_filter(function(line)
				return line ~= ""
			end, data)

			vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
			vim.fn.winrestview(view)
		end,
		on_stderr = function(_, err)
			if err and #err > 0 then
				vim.notify("buf format stderr:\n" .. table.concat(err, "\n"), vim.log.levels.ERROR)
			end
		end,
		on_exit = function(_, code)
			if code ~= 0 then
				vim.notify("buf format exited with code " .. code, vim.log.levels.WARN)
			end
		end
	})
end

-- Register :Format command and auto-format on save
vim.api.nvim_buf_create_user_command(0, "Format", format_buf, {
	desc = "Format proto file using buf format",
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   buffer = 0,
--   callback = format_buf,
-- })
