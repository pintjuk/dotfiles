return {
	'f-person/auto-dark-mode.nvim',
	config = {
		update_interval = 1000,
		set_dark_mode = function()
			vim.api.nvim_set_option("background", "dark")
			vim.cmd("colorscheme habamax")
			require('lualine').setup {
				options = { theme = "habamax" },
			}
		end,
		set_light_mode = function()
			vim.api.nvim_set_option("background", "light")
			vim.cmd("colorscheme github_light")
			require('lualine').setup {
				options = { theme = "github_light" },
			}
		end,
	},
}
