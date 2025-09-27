return {
	'pwntester/octo.nvim',
	requires = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope.nvim',
		-- OR 'ibhagwan/fzf-lua',
		-- OR 'folke/snacks.nvim',
		'nvim-tree/nvim-web-devicons',
	},
	config = function()
		require "octo".setup({
			default_merge_method = "squash"
		})



		vim.api.nvim_create_autocmd("BufRead", {
			pattern = "octo://*",
			callback = function()
				local bufname = vim.api.nvim_buf_get_name(0)
				if bufname:match("pull_request/new") then
					vim.api.nvim_buf_set_lines(0, 0, -1, false, {
						"🚀 Default PR Title",
						"",
						"## Summary",
						"Describe the purpose of this PR.",
						"",
						"## Changes",
						"- List changes here.",
						"",
						"## Testing",
						"Explain how to test this PR."
					})
				end
			end
		})
	end
}
