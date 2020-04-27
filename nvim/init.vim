let g:python_host_skip_check = 1
let g:python3_host_skip_check = 1

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'wellle/targets.vim'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'rakr/vim-one' 
Plug 'gruvbox-community/gruvbox' 

" Initialize plugin system
call plug#end()

set termguicolors
colorscheme gruvbox
set bg=light

set grepprg=rg\ --vimgrep

" Search
set ignorecase
set smartcase
set inccommand=nosplit
set nowrap
set foldlevel=99

set cursorline

augroup LuaHighlight 
	autocmd!
	autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

lua <<EOF
require'nvim-treesitter.configs'.setup {
	ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true,              -- false will disable the whole extension
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",

		},
	}
}
EOF

" Window split behaviour
set splitright
set splitbelow

" Allow unsaved background buffers
set hidden

" Remap escape
inoremap jk <Esc>

" Mappings to move to the start and end of lines quickly
noremap H ^
noremap L $
vnoremap L g_

let mapleader = " "

nnoremap <leader>p :FZF<CR>

autocmd! FileType fzf set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

let g:sneak#label = 1
nmap <leader>j <Plug>Sneak_s
nmap <leader>k <Plug>Sneak_S

augroup filetype_go
	autocmd!
	let g:go_list_type = "quickfix"
	let g:go_fmt_command = "goimports"
	autocmd filetype go nmap <leader>gb  <plug>(go-build)
	autocmd filetype go nmap <leader>gr  <plug>(go-run)
	autocmd filetype go nmap <leader>gt  <plug>(go-test)
	autocmd filetype go nmap <leader>gi  <plug>(go-info)
augroup end

autocmd QuickFixCmdPost [^l]* cwindow
