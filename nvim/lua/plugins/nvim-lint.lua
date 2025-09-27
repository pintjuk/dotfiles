return {
	'mfussenegger/nvim-lint',
	event = { "BufReadPost", "BufWritePost", "InsertLeave" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			json = { "jsonlint" },
			yaml = { "yamllint" },
			go = { "golangcilint" },
		}
		-- set ingrid linting rules for golangci-lint
		table.insert(lint.linters.golangcilint.args, 2, "--config")
		table.insert(lint.linters.golangcilint.args, 3,
			"/Users/daniil/.pyenv/versions/3.9.16/envs/ciappenv/lib/python3.9/site-packages/ciapp/lint/.golangci.yml")



		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			pattern = { "*.go", "*.json", "*.yaml", "*.yml" },
			callback = function()
				require("lint").try_lint()
			end
		})
	end,
}
