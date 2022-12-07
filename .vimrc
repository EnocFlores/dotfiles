" Editor: Enoc Flores
" Last change:	2022 Dec 06
"
" This is loaded if no vimrc file was found.
" To run Vim without these configs run with flags: "-u NONE" or "-C".

" ============================================== "

" ============================================== "

" Adds qp as another way of exiting INSERT and VISUAL mode back to NORMAL mode
inoremap gh <ESC>
vnoremap gh <ESC>
set timeoutlen=150

" Enable line numbers
set number
set ruler

" Theme & Colors
set background=dark
set termguicolors
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
colorscheme ron

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Other useful life settings
set cursorline
set tabstop=2
set backspace=indent,eol,start

if exists("&relativenumber")
	set relativenumber
	au BufReadPost * set relativenumber
endif

syntax on
