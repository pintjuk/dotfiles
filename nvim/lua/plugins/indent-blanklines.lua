return {
		-- Add indentation guides even on blank lines
		'lukas-reineke/indent-blankline.nvim',
		-- Enable `lukas-reineke/indent-blankline.nvim`
		-- See `:help indent_blankline.txt`
		main = "ibl",
		opts = {
			indent = { char = '┊', },
			-- show_trailing_blankline_indent = false,
		},
	}
