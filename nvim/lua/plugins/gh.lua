return {
	{
		"ldelossa/gh.nvim",
		dependencies = { "ldelossa/litee.nvim" },
		config = function()
			require("litee.lib").setup()
			require("litee.gh").setup({
				-- optional, but lets you view PRs in a vertical/horizontal layout
				jump_mode = "invoking", -- or "invoking"
			})
		end,
	}
}
