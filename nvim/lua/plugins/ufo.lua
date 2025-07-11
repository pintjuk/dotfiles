return {
	'kevinhwang91/nvim-ufo',
	dependencies =  {'kevinhwang91/promise-async'},
	config = function ()
		vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
		vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)


		vim.o.foldcolumn = '1' -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		require('ufo').setup({
			open_fold_hl_timeout = 150,
			close_fold_kinds_for_ft = {
				default = {'imports', 'comment'},
				json = {'array'},
				c = {'comment', 'region'},
				go = {'comment', 'imports'},
			},
			preview = {
				win_config = {
					border = {'', '─', '', '', '', '─', '', ''},
					winhighlight = 'Normal:Folded',
					winblend = 0
				},
				mappings = {
					scrollU = '<C-u>',
					scrollD = '<C-d>',
					jumpTop = '[',
					jumpBot = ']'
				}
			},
			provider_selector = function(bufnr, filetype, buftype)
				return {'treesitter', 'indent'}
			end
		})

		-- Custom folding for Go imports and error checks
		vim.api.nvim_create_autocmd("FileType", {
		  pattern = "go",
		  callback = function()
			-- Set foldmethod to expr to use tree-sitter for folding
			vim.wo.foldmethod = 'expr'
			vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

			-- Custom fold pattern for Go imports and error checks
			vim.api.nvim_exec([[
			  augroup go_folding
				autocmd!
				autocmd FileType go syntax match goImports /import\s*(\([^\)]+\))\s*/ 
				autocmd FileType go syntax match goErrFolding /if\s+err\s*!=\s*nil/
			  augroup END
			]], false)
		  end,
		})
	end
}
