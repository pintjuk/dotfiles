vim.keymap.set('n', '<leader>r', function()
	local file = vim.api.nvim_buf_get_name(0)
	if file == '' then
		vim.notify('Buffer has no file name', vim.log.levels.ERROR)
		return
	end

	if vim.bo.modified then
		vim.cmd('write')
	end

	local cwd = vim.fn.fnamemodify(file, ':h')

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_open_win(buf, true, {
		relative = 'editor',
		width = width,
		height = height,
		row = math.floor((vim.o.lines - height) / 2),
		col = math.floor((vim.o.columns - width) / 2),
		style = 'minimal',
		border = 'rounded',
		title = ' zig run ' .. vim.fn.fnamemodify(file, ':t') .. ' ',
		title_pos = 'center',
	})

	vim.fn.setqflist({}, 'r', { title = 'zig run', items = {} })

	vim.fn.jobstart({ 'zig', 'run', file }, {
		cwd = cwd,
		term = true,
		on_exit = function(_, code)
			if not vim.api.nvim_buf_is_valid(buf) then return end
			local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
			local items = {}
			for _, line in ipairs(lines) do
				line = line:gsub('\27%[[0-9;?]*[A-Za-z]', '') -- strip ANSI
				local f, lnum, col, kind, msg =
					line:match('^(.-):(%d+):(%d+):%s+(%w+):%s+(.*)$')
				if f and (kind == 'error' or kind == 'note') then
					local full = f
					if vim.fn.filereadable(full) == 0 then
						local joined = cwd .. '/' .. f
						if vim.fn.filereadable(joined) == 1 then
							full = joined
						end
					end
					table.insert(items, {
						filename = full,
						lnum = tonumber(lnum),
						col = tonumber(col),
						text = msg,
						type = kind == 'error' and 'E' or 'I',
					})
				end
			end
			vim.schedule(function()
				vim.fn.setqflist({}, 'r', { title = 'zig run', items = items })
				if #items > 0 then
					vim.notify(string.format('zig run: %d quickfix entr%s',
						#items, #items == 1 and 'y' or 'ies'), vim.log.levels.WARN)
				elseif code ~= 0 then
					vim.notify('zig run exited with code ' .. code, vim.log.levels.WARN)
				end
			end)
		end,
	})

	vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = buf, nowait = true })
end, { buffer = 0, desc = 'Zig: run current file' })
