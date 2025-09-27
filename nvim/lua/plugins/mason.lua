return {
	'williamboman/mason.nvim',
	'williamboman/mason-lspconfig.nvim',
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

		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})
	end,
}
