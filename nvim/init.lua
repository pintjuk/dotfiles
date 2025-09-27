local home = os.getenv("HOME")
local config_lua = home .. "/.config/nvim/lua/?.lua;" .. home .. "/.config/nvim/lua/?/init.lua;"

if not string.find(package.path, config_lua, 1, true) then
  package.path = config_lua .. package.path
end

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.spell = true

vim.o.shell = '/bin/sh'
vim.o.shellcmdflag = '-c'

-- folds 
vim.o.foldlevelstart = 99
-- vim.o.foldmethod = "syntax"
-- vim.cmd('syntax on')

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'


-- Install package manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")


--



-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = false
-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true


--
-- -- Python
-- require("snippets")
--
-- reload files
local suffixes = { "*.log", "*.txt", '*.gox'}

-- Set up the autocommand to check for changes when focus is gained or the buffer is entered
vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
    pattern = suffixes,
    command = "checktime"
})

vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*_gen.go",
    callback = function()
        vim.bo.readonly = true
    end
})
