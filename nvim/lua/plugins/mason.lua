return {
	{
		'williamboman/mason.nvim',
		config = function()
			require("mason").setup()
		end,
	},
	{
		'williamboman/mason-lspconfig.nvim',
		dependencies = { 'williamboman/mason.nvim' },
		config = function()
		local servers = {
			gopls = {},
			html = { filetypes = { 'html', 'twig', 'hbs' } },
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
			ts_ls = {},
			cssls = {},
			eslint = {},
			jsonls = {},
		}

			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})
		end,
	},
	{
		'jay-babu/mason-nvim-dap.nvim',
		dependencies = { 'williamboman/mason.nvim' },
		config = function()
			require("mason-nvim-dap").setup({
				ensure_installed = { "java-debug-adapter" }
			})
		end,
	},
}
