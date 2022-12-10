-- ┌────────────┐
-- │░█░█░▀█▀░█▄█│
-- │░▀▄▀░░█░░█░█│
-- │░░▀░░▀▀▀░▀░▀│
-- └────────────┘
local Plug = vim.fn['plug#']
vim.call('plug#begin')
 Plug('dracula/vim', { as = 'dracula' })
 Plug('ms-jpq/chadtree', { branch = 'chad', ['do'] = vim.fn['python3 -m chadtree deps'] })
 Plug 'elkowar/yuck.vim'
 Plug 'mhinz/vim-startify'
 Plug 'nvim-lualine/lualine.nvim'
 Plug('rrethy/vim-hexokinase', { ['do'] = 'make hexokinase' })
 Plug 'neovim/nvim-lspconfig'
 Plug 'hrsh7th/nvim-cmp'
 Plug 'hrsh7th/cmp-nvim-lsp'
 Plug 'hrsh7th/cmp-path'
 Plug 'hrsh7th/cmp-buffer'
 Plug 'hrsh7th/cmp-cmdline'
 Plug 'hrsh7th/cmp-nvim-lua'
 Plug 'saadparwaiz1/cmp_luasnip'
vim.call('plug#end')

-- Settings
vim.o.ru = true --ruler
vim.o.nu = true --number
vim.o.sc = true --showcmd
vim.o.ai = true --autoindent
vim.o.wrap = false
vim.o.ic = true --ignorecase
vim.o.is = true --incsearch
vim.o.ts = 4 --tabstop
vim.o.sts = 4 --softtabstop
vim.o.sw = 5 --shiftwidth
vim.o.mouse = 'a'
vim.o.list = true
vim.o.lcs = 'tab:>-,multispace:-+,' --listchars
vim.o.cul = true --cursorline
vim.o.culopt = "both" --cursorlineopt
vim.o.tgc = true --termguicolors
vim.o.cot = 'menu,menuone,noselect' --completeopt
vim.cmd('colo dracula')
vim.cmd('hi MatchParen guifg=#21222c')
vim.cmd('hi MatchParen guibg=#6272a4')
vim.opt.gfn = { "JetBrainsMono Nerd Font", ":h8" } --guifont
vim.g.neovide_cursor_vfx_mode = "wireframe"
vim.cmd('map <C-C> "+y')
vim.cmd('map <C-V> "+gP')
vim.cmd('map <C-F> :CHADopen --nofocus<Enter>')

-- Packages
vim.cmd('autocmd VimEnter * CHADopen --nofocus')
vim.cmd('autocmd BufEnter * if (winnr("$") == 1 && &buftype == "nofile" && &filetype == "CHADTree") | q! | endif')
vim.g.startify_lists = {
	 { type = 'bookmarks', header = {'\tBookmarks : '}}}
vim.g.startify_bookmarks = { 
	 '~/.config/nvim/init.lua', 
	 '~/.config/qtile/config.py',
	 '~/.config/rofi/config.rasi',
	 '~/.config/eww/eww.yuck' }
vim.g.startify_custom_header = {
'	┌────────────────────────┐',
'	│║ ║╝╔╔   ╝╔═╝  ╔═╝╔═║╔═ │',
'	│║ ║║║║║  ║══║  ║ ║║ ║║ ║│',
'	│ ╝ ╝╝╝╝  ╝══╝  ══╝══╝══ │',
'	└────────────────────────┘'}
vim.g.startify_custom_footer = 'startify#pad(startify#fortune#cowsay())'
vim.g.chadtree_settings = {
	['options.show_hidden'] = true,
	['theme.icon_glyph_set'] = "devicons",
	['theme.icon_colour_set'] = "none",
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

-- LSP and autocomplete
local cmp = require'cmp'
cmp.setup({
	 snippet = {
		expand = function(args)
		require('luasnip').lsp_expand(args.body)
	 end,
	 },
	 experimental = { ghost_text = true },
	 window = { 
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	 },
	 mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	 }),
	 sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	 }, {
		{ name = 'nvim_lua' },
	 })
})
cmp.setup.cmdline(':', {
	 mapping = cmp.mapping.preset.cmdline(),
	 sources = cmp.config.sources({
		  { name = 'path' }
	 }, {
		  { name = 'cmdline' }
	 })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
require('lspconfig')['pyright'].setup {
	 capabilities = capabilities
}

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
