return {
	
	-- copilot
	{'github/copilot.vim',
		config = function()
			vim.g.copilot_no_tab_map = true
			vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
		end
	},
	-- Git related plugins
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',

	-- Useful plugin to show you pending keybinds.
	{ 'folke/which-key.nvim', opts = {} },
	-- "gc" to comment visual regions/lines
	-- {
	-- 	'numToStr/Comment.nvim',
	-- 	opts = {
	-- 		mappings = false,
	-- 	}
	-- },
	{
		'projekt0n/github-nvim-theme',
		priority = 1000,
		config = function ()	
			vim.cmd.colorscheme 'github_light'
		end
	},
	-- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
	--       These are some example plugins that I've included in the kickstart repository.
	--       Uncomment any of the lines below to enable them.
	-- require 'kickstart.plugins.autoformat',
	-- require 'kickstart.plugins.debug',

	-- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
	--    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
	--    up-to-date with whatever is in the kickstart repo.
	--    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
	--
	--    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
	-- { import = 'custom.plugins' }
	-- DAP settings
	-- golang
	-- "mfussenegger/nvim-dap",
	-- "leoluz/nvim-dap-go",
	-- {
	-- 	"rcarriga/nvim-dap-ui",
	-- 	requires = { "mfussenegger/nvim-dap" },
	-- }
}
