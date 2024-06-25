local set = vim.keymap.set

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })



-- Remap for dealing with word wrap
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- copy file path into clipboard
set('n', 'cp',
	function()
		print("copied path to clipboard")
		vim.fn.setreg('+', vim.fn.expand('%'))
		vim.fn.setreg('', vim.fn.expand('%'))
	end,
	{ desc = '[C]opy [P]ath' })


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = '*',
})

-- Diagnostic keymaps
set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })


set('n', "<leader><leader>x",  "<cmd> source %<CR>", { desc = 'source current file' })

-- windows 

set("n", "<C-j>", "<cmd> TmuxNavigateDown<CR>")
set("n", "<C-k>", "<cmd> TmuxNavigateUp<CR>")
set("n", "<C-l>", "<cmd> TmuxNavigateRight<CR>")
set("n", "<C-h>", "<cmd> TmuxNavigateLeft<CR>")
set("n", "<C-\\>", "<cmd> TmuxNavigatePrevious<CR>")

-- set("n", "<M-,>", "<C-w>5<")
-- set("n", "<M-.>", "<C-w>5>")
-- set("n", "<M-,>", "<c-w>5<")
-- set("n", "<M-.>", "<c-w>5>")



