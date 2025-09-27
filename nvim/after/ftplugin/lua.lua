local shared = require("lsp.shared")

require('neodev').setup()

vim.lsp.config("lua_ls", {
  capabilities = shared.capabilities,
  on_attach = shared.on_attach,
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
		},
	},
})

vim.lsp.enable("lua_ls")
