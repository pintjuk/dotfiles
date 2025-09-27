vim.notify("Loaded ftplugin/json.lua", vim.log.levels.INFO)
-- Use jsonlint for syntax checking
vim.bo.errorformat = "%f: line %l, col %c, %m"

-- Set jq as the external formatter
vim.bo.formatprg = "jq ."


-- Optional: Set up formatting or extra options
vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2



