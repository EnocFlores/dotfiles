" My custom vimrc file, optional vim-plugs, and some default configurations
"
" Maintainer: The Vim Project <https://github.com/vim/vim>
" Former Maintainer: Bram Moolenaar <Bram@vim.org> - RIP 2023 Aug 3
" Editor: EnocFlores <https://github.com/EnocFlores>
" Last Change: 2023 Dec 22
" 
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" ====================================== "
" === Get the full benefits of Vim   === "
" === but just in case you open vim  === "
" === in vi mode then this check     === "
" === will not activate nocompatible === "
" === mode                           === "
" ====================================== "
if &compatible
    set nocompatible
endif

" ====================================== "
" === To make sure nocompatible is   === "
" === set even if +eval is missing   === "
" === in the vim installation, this  === "
" === loop remains false but is not  === "
" === registered if +eval is missing === "
" === the silent command just allows === "
" === this to not display any errors === "
" === from this trick                === "
" ====================================== "
silent! while 0
    set nocompatible
silent! endwhile

" === Theme & Colors =================== "
set t_Co=256
set background=dark
set termguicolors
let &t_8f = "\<Esc>[38:2:%lu:%lu:%lum"
let &t_8b = "\<Esc>[48:2:%lu:%lu:%lum"
colorscheme ron

" ====================================== "
" === Syntax highlighting a          === "
" === programmer's best friend       === "
" ====================================== "
syntax on

" ====================================== "
" === Adds 'gh' as another way of    === "
" === exiting INSERT mode, back to   === "
" === NORMAL mode                    === "
" ====================================== "
" === No longer using a standard     === "
" === keyboard so this isn't         === "
" === necessary to me anymore (ESC   === "
" === is now in immediate reach)     === "
" ====================================== "
" inoremap gh <ESC>
" vnoremap gh <ESC>
" set timeoutlen=150

" === Enable line numbers ============== "
set number

" ====================================== "
" === Enable cursor position to      === "
" === always be displayed            === "
" ====================================== "
set ruler

" ====================================== "
" === This is an extremely helpful   === "
" === feature to have, next to the   === "
" === ruler, the start of the        === "
" === command you write will show    === "
" ====================================== "
set showcmd

" ====================================== "
" === Use the OS clipboard by        === "
" === default (on versions compiled  === "
" === with `+clipboard`)             === "
" ====================================== "
set clipboard=unnamed

" ====================================== "
" === This will enable some sort of  === "
" === highligh on the line that your === "
" === cursor is on                   === "
" ====================================== "
set cursorline

" ====================================== "
" === When you search a word all the === "
" === instances of that word will be === "
" === highlighted as well, which is  === "
" === why cursorline is so useful    === "
" ====================================== "
set hls

" ====================================== "
" === Allow backspacing anywhere in  === "
" === insert mode                    === "
" ====================================== "
set backspace=indent,eol,start

" ====================================== "
" === This will set tabs to be 4     === "
" === spaces by default, and tabs    === "
" === will be made up of spaces      === "
" === instead of tab characters      === "
" === The one exception for now is   === "
" === with json files, those will be === "
" === 2 spaces                       === "
" ====================================== "
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
autocmd FileType json setlocal tabstop=2 softtabstop=2 shiftwidth=2

" ====================================== "
" === At my current level I do not   === "
" === make heavy use of the vim      === "
" === command line so keeping it at  === "
" === 200 lines seems reasonable     === "
" ====================================== "
set history=200

" ====================================== "
" === This helps a lot when writing  === "
" === commands with autocomplete     === "
" === beacuase is displays all the   === "
" === available options right above  === "
" === which you can tab through      === "
" ====================================== "
set wildmenu

" ====================================== "
" === This is a useful feature when  === "
" === you just want to click the top === "
" === or bottom 5 lines to scroll    === "
" === slightly and brings the text   === "
" === into view better               === "
" ====================================== "
set scrolloff=5

" ====================================== "
" === This will check if you have a  === "
" === mouse and then whether to use  === "
" === xterm mouse features or other  === "
" ====================================== "
if has('mouse')
    if &term =~ 'xterm'
        set mouse=a
    else
        set mouse=nvi
    endif
endif

" ====================================== "
" === This checks if relative time   === "
" === measurement is avilable and    === "
" === therefore the system can       === "
" === handle the incremental search  === "
" === feature                        === "
" ====================================== "
if has('reltime')
    set incsearch
endif

" ====================================== "
" === This sets relative numbers to  === "
" === help in navigating around, in  === "
" === insert mode this is not needed === "
" === which is why it is turned off  === "
" ====================================== "
if exists("&relativenumber")
    set relativenumber
    autocmd BufReadPost * set relativenumber
endif

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" ====================================== "
" === Do not recognize octal numbers === "
" === for Ctrl-A and Ctrl-X, I have  === "
" === personally never used them and === "
" === don't plan to yet              === "
" ====================================== "
set nrformats-=octal



" ====================================== "
" =========== VIM-PLUG START =========== "
" ====================================== "

" ====================================== "
" === First I run a check to see if  === "
" === vim-plug is present            === "
" ====================================== "

if filereadable(expand('~/.vim/autoload/plug.vim'))
    call plug#begin()
" ====================================== "
" === The default plugin directory   === "
" === will be as follows:            === "
" === - Vim (Linux/macOS): '~/.vim/plugged'
" === - Vim (Windows): '~/vimfiles/plugged'
" === - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" === You can specify a custom       === "
" === plugin directory by passing    === "
" === it as the argument             === "
" === - e.g. `call plug#begin('~/.vim/plugged')`
" === - Avoid using standard Vim directory names like 'plugin'
" ====================================== "

    " Plug in purpura colorscheme
    Plug 'yassinebridi/vim-purpura'

    " Plug in nerdcommenter to comment with gc
    Plug 'preservim/nerdcommenter'

    " Initialize plugin system
    " - Automatically executes `filetype plugin indent on` and `syntax enable`.
    call plug#end()
    " DON'T FORGET to run :PlugInstall

    " You can revert the settings after the call like so:
    "   filetype indent off   " Disable file-type-specific indentation
    "   syntax off            " Disable syntax highlighting

    " colorscheme purpura
    
    " sets mapleader because nerdcommenter uses it for its bindings
    let mapleader = " "

    " Add spaces after comment delimiters by default
    let g:NERDSpaceDelims = 1

    " Align line-wise comment delimiters flush left instead of following code indentation
    let g:NERDDefaultAlign = 'left'
else
    echo "vim-plug are not installed, if you do not intend to then you can delete this warning in your .vimrc"
endif

" ====================================== "
" ============= VIM-PLUG END =========== "
" ====================================== "



" ====================================== "
" === These are settings kept from   === "
" === default initial vimrc file     === "
" ====================================== "

" ====================================== "
" === This will highlight strings    === "
" === inside C comments.             === "
" ====================================== "
let c_comment_strings=1

" ====================================== "
" === Sets a timeout for key codes   === "
" === Currently set to 100ms until   === "
" === it just registers as a         === "
" === standalone key press           === "
" ====================================== "
set ttimeout
set ttimeoutlen=100

" ====================================== "
" === For Win32 GUI: remove 't' flag === "
" === from 'guioptions': no tearoff  === "
" === menu entries.                  === "
" === Don't personally use windows   === "
" === but I kept it just in case     === "
" ====================================== "
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | exe 'au!' | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":augroup vimHints | exe 'au!' | augroup END"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo | 
	  \ echo 'You discovered the command-line window! You can close it with ":q".' |
	  \ echohl None
  augroup END

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

