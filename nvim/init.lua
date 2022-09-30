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
vim.o.cursorline = true
vim.o.tgc = true

-- Packages
local Plug = vim.fn['plug#']
vim.call('plug#begin')
 Plug('dracula/vim', {as = 'dracula'})
 Plug('ms-jpq/chadtree', {branch = 'chad', ['do'] = vim.fn['python3 -m chadtree deps']})
 Plug 'elkowar/yuck.vim'
 Plug 'mhinz/vim-startify'
 Plug 'nvim-lualine/lualine.nvim'
 Plug('ms-jpq/coq_nvim', {branch = 'coq'})
 Plug 'ms-jpq/coq.artifacts'
 Plug 'ms-jpq/coq.thirdparty'
 Plug('rrethy/vim-hexokinase', {['do'] = 'make hexokinase' })
 Plug 'neovim/nvim-lspconfig'
vim.call('plug#end')

vim.cmd('colorscheme dracula')
vim.cmd('highlight MatchParen guifg=#21222c')
vim.cmd('highlight MatchParen guibg=#6272a4')
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
vim.cmd('autocmd VimEnter * CHADopen --nofocus')
vim.cmd('autocmd BufEnter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif')
vim.g.chadtree_settings = {
	['options.show_hidden'] = true,
	['theme.icon_glyph_set'] = "devicons",
	['theme.icon_colour_set'] = "github",
	['theme.text_colour_set'] = "nord",
	['theme.discrete_colour_map'] = {
		blue = '#bd93f9',
		red = '#ff5555',
		yellow = '#f1fa8c',
		black = '#21222c',
		magenta = '#ff79c6',
		cyan = '#8be9fd',
		white = '#f8f8f2',
		green = '#50fa7b',}}
vim.g.Hexokinase_highlighters = {'backgroundfull'}
vim.g.Hexokinase_optInPatterns = 'full_hex,rgb,rgba,hsl,hsla'

-- LSP
require('lspconfig').pyright.setup{}
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "vimtex",  short_name = "vTEX" },
  { src = 'builtin/syntax' },
}
vim.g.coq_settings = {
	['display.icons.mode'] = "short",
	['auto_start'] = 'shut-up',
	['clients.lsp.enabled'] = true,
	['clients.buffers.enabled'] = false}

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
