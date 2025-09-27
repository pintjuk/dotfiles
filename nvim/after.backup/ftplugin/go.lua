print("loading go ftplugins")

vim.go.foldmethod = "indent"
vim.go.foldlevelstart = 0

vim.keymap.set("n", "<leader>td", function()
	require("dap-go").debug_test()
end, {
	buffer = 0,
	desc = '[T]est [D]ebug',
})
