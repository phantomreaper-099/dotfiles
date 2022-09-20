-- ┌────────────┐
-- │░█░█░▀█▀░█▄█│
-- │░▀▄▀░░█░░█░█│
-- │░░▀░░▀▀▀░▀░▀│
-- └────────────┘
vim.o.ruler = true
vim.o.number = true
vim.o.showcmd = true
vim.o.autoindent = true
vim.o.wrap = false
vim.o.ignorecase = true
vim.o.incsearch = true
vim.o.tabstop = 5
vim.o.softtabstop = 5
vim.o.wildmode = 'longest,list'
vim.o.shiftwidth = 5
vim.o.mouse = 'a'
vim.o.list = true
vim.o.listchars = 'tab:>>'

-- Packages
local Plug = vim.fn['plug#']
vim.call('plug#begin')
 Plug('dracula/vim', {as = 'dracula'})
 Plug('ms-jpq/chadtree', {branch = 'chad', ['do'] = vim.fn['python3 -m chadtree deps']})
 Plug 'elkowar/yuck.vim'
 Plug 'mhinz/vim-startify'
 Plug 'nvim-lualine/lualine.nvim'
 Plug('ms-jpq/coq_nvim', {branch = 'coq'})
vim.call('plug#end')

vim.cmd('colorscheme dracula')
vim.g.startify_lists = {{ type = 'dir', header = {'   MRU : /home/aman'}},}
vim.g.startify_custom_header = {
'	┌────────────────────────┐',
'	│║ ║╝╔╔   ╝╔═╝  ╔═╝╔═║╔═ │',
'	│║ ║║║║║  ║══║  ║ ║║ ║║ ║│',
'	│ ╝ ╝╝╝╝  ╝══╝  ══╝══╝══ │',
'	└────────────────────────┘'}
vim.g.startify_custom_footer = {
"	Software is like sex, it's better when it's free",
'		- Linus Torvalds',}
vim.cmd('autocmd VimEnter * CHADopen')
vim.cmd('autocmd VimEnter * COQnow -s')
vim.g.chadtree_settings = {
	['options.show_hidden'] = true,}
vim.g.coq_settings = {
	['display.icons.mode'] = "long",}

-- Lualine
require('lualine').setup {
options = {
	icons_enabled = true,
	theme = require('lualine.themes.dracula'),
	component_separators = { left = '', right = ' '},
	section_separators = { left = ' ', right = ' '},
	disabled_filetypes = {
		statusline = {},
		winbar = {},
	},
	ignore_focus = {},
	always_divide_middle = true,
	globalstatus = false,
	refresh = {
		statusline = 1000,
		tabline = 1000,
		winbar = 1000,
	}
},
sections = {
	lualine_a = {{'mode',icon={'',align='right'}}},
	lualine_b = {'branch','diff','diagnostics'},
	lualine_c = {'filename'},
	lualine_x = {'encoding','fileformat'},
	lualine_y = {'filetype'},
	lualine_z = {'location'}
},
inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {'filename'},
	lualine_x = {'location'},
	lualine_y = {},
	lualine_z = {}
},
tabline = {},
winbar = {},
inactive_winbar = {},
extensions = {'chadtree'}
}
