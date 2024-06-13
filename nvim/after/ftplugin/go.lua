print("loading go ftplugins")


vim.keymap.set("n", "<leader>td", function()
	require("dap-go").debug_test()
end, {
	buffer = 0,
	desc = '[T]est [D]ebug',
})
