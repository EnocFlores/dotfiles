" My custom vimrc file, optional vim-plugs, and some default configurations
"
" Maintainer: The Vim Project <https://github.com/vim/vim>
" Former Maintainer: Bram Moolenaar <Bram@vim.org> - RIP 2023 Aug 3
" Editor: EnocFlores <https://github.com/EnocFlores>
" Last Change: 2024 Mar 06
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

" === Set colorscheme to ron =========== "
colorscheme ron

" ====================================== "
" === There is some differences that === "
" === occur when using tmux within   === "
" === your choosen terminal, the     === "
" === background and foreground can  === "
" === be particulurly tricky and so  === "
" === this checks for a screen       === "
" === terminal and adds this fix so  === "
" === that everything looks as       === "
" === expected across your different === "
" === terminals, this fix can be     === "
" === found in the term.txt file in  === "
" === the VIM REFERENCE MANUAL       === "
" ====================================== "
if &term == 'screen-256color'
    " set t_Co=256
    " set termguicolors
    let &termguicolors = v:true
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    " Set the background color
    " highlight Normal ctermbg=0

    " Set the foreground color
    " highlight Normal ctermfg=1
endif

" ====================================== "
" === This is still being tested on  === "
" === compatability with neovim      === "
" ====================================== "
" if has('nvim') || has('vim')
"   if has('unix') && has('termguicolors')
"     " Enable true color support
"     set termguicolors
"   elseif has('unix') && has('tmux') && $TMUX != ''
"     " Enable 256 color support in tmux
"     set t_Co=256
"   endif
" endif

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

" ====================================== "
" === Sets a timeout for key codes   === "
" === Currently set to 100ms until   === "
" === it just registers as a         === "
" === standalone key press           === "
" ====================================== "
" set ttimeout
" set ttimeoutlen=150

" === Enable line numbers ============== "
set number

" === Wrap text so you can see it all=== "
set wrap

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
let device = system('uname -o')

if exists("+clipboard")
    if device =~ 'Darwin'
        set clipboard=unnamed
    elseif device =~ 'Android'
        " Copy to clipboard command
        command! -range=% -nargs=0 CopyToClipboard :<line1>,<line2>w !termux-clipboard-set
        " Paste from clipboard command
        command! PasteFromClipboard :r !termux-clipboard-get

        " Copy to clipboard keymap
        nnoremap <leader>y :CopyToClipboard<CR>
        vnoremap <leader>y :CopyToClipboard<CR>
        " Paste from clipboard keymap
        nnoremap <leader>p :PasteFromClipboard<CR>
        vnoremap <leader>p :PasteFromClipboard<CR>
    else
        set clipboard=unnamedplus
    endif
else
    set clipboard=unnamedplus
    echo "Your vim installation lacks +clipboard, you can remove this notification from your vimrc or install vim-gtk"
endif

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
" === I want my searches to be case  === "
" === insensitive except for when I  === "
" === uppercase letters              === "
" ====================================== "
set ignorecase
set smartcase

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
" === Change the cursor to beam in   === "
" === insert mode and back to block  === "
" === in command mode                === "
" ====================================== "
if has("autocmd")
  au InsertEnter * silent execute "!echo -ne '\e[5 q'" | redraw!
  au InsertLeave * silent execute "!echo -ne '\e[2 q'" | redraw!
  au VimLeave * silent execute "!echo -ne '\e[2 q'" | redraw!
endif

" ====================================== "
" === Do not recognize octal numbers === "
" === for Ctrl-A and Ctrl-X, I have  === "
" === personally never used them and === "
" === don't plan to yet              === "
" ====================================== "
set nrformats-=octal

" ====================================== "
" === By default vim usually unloads === "
" === a buffer from memory when      === "
" === opening another file, this     === "
" === setting allows vim to just hide=== "
" === it, you can :bNext or Ctrl+o   === "
" ====================================== "
set hidden

" === netrw configs ==================== "
" nnoremap <C-n> <Esc>:35Lexplore<cr> "Fails in nvim, so:
nnoremap <C-n> <Esc>:Lexplore<cr>:vertical resize 35<cr>
nnoremap <C-e> <Esc>:Explore<cr>
let g:netrw_liststyle=3
let g:netrw_altv=1
let g:netrw_preview=1
let g:netrw_winsize=300

" === search through my git repo ======= "
set gp=git\ grep\ -ni

" ====================================== "
" === File navigation ================== "
" ====================================== "
set isfname+=@-@
set includeexpr=substitute(v:fname,'^@\/','','')

" === Just some JavaScript configs ===== "
set path+=components,src
set suffixesadd+=,/index.js,index.js

" ====================================== "
" === Have a status line that is     === "
" === always active and will show    === "
" === pane, mode, and file path      === "
" ====================================== "

" === Always have status line active === "
set laststatus=2

" === Function to show modes =========== "
function! StatuslineMode()
    let l:mode = mode()
    if l:mode == 'n'
        return 'NORMAL'
    elseif l:mode == 'i'
        return 'INSERT'
    elseif l:mode == 'c'
        return 'COMMAND'
    elseif l:mode == 'v'
        return 'VISUAL'
    elseif l:mode == 'r'
        return 'REPLACE'
    elseif l:mode == 't'
        return 'TERMINAL'
    else
        return toupper(l:mode)
    endif
endfunction

" ====================================== "
" === %n=buffer name, %r=read-only   === "
" === %m=modified, %==left/right sep === "
" === %y=file type, %l=line number   === "
" === %0%c=coloumn number with 0 pad === "
" === %p=position as percentage      === "
" === %L=total lines in file         === "
" ====================================== "
set statusline=[%n]\ \|\ %{StatuslineMode()}\ \|\ %{expand('%:~:.')}\ %r%m%=%y\ \|\ %l,0%c\ \|\ %p%%\ %L

" ====================================== "
" === Remap Ctrl+h/j/k/l to change   === "
" === between panes                  === "
" ====================================== "
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" ====================================== "
" === Have tabs numbered and show    === "
" === number of windows in each tab  === "
" === as well as an indicator of any === "
" === modified buffer in that tab    === "
" ====================================== "
" highlight TabNumber ctermfg=11 guifg=#0000ff ctermbg=NONE guibg=NONE
highlight TabNumber ctermfg=13 guifg=#0000ff

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
        let winnr = tabpagewinnr(i + 1)
        let buflist = tabpagebuflist(i + 1)
        let bufnr = buflist[winnr - 1]
        let file = bufname(bufnr)
        let buftype = getbufvar(bufnr, '&buftype')
        if buftype == 'nofile'
            if file =~ '\/.'
                let file = substitute(file, '.*\/\zs', '', '')
            endif
        else
            let file = fnamemodify(file, ':t')
        endif
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif
        let modified = 0
        for buf in tabpagebuflist(i + 1)
            if getbufvar(buf, '&modified')
                let modified = 1
                break
            endif
        endfor
        " let s .= ' ' . (i + 1) . ' ' . file . ' ' . tabpagewinnr(i + 1, '$') . 'w ' . (modified ? '[+] ' : '') . ' '
        let s .= ' ' . (i + 1) . ' ' . '%#TabNumber#' . file . ' ' . tabpagewinnr(i + 1, '$') . 'w ' . (modified ? '[+] ' : '') . ' '
        " let s .= ' ' . '%#Title#' . (i + 1) . '%#TabLine#' . ' ' . file . ' ' . tabpagewinnr(i + 1, '$') . 'w ' . (modified ? '[+] ' : '') . ' '
        " let s .= ' ' . '%#TabNumber#' . (i + 1) . '%#TabLine#' . ' ' . file . ' ' . tabpagewinnr(i + 1, '$') . 'w ' . (modified ? '[+] ' : '') . ' '
        " let s .= ' ' . ('%#TabNumber#' . i + 1) . ' ' . file . ' ' . tabpagewinnr(i + 1, '$') . 'w ' . (modified ? '[+] ' : '') . ' '
    endfor
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%#TabLine#%999XX' : ' ')
    return s
endfunction

set tabline=%!MyTabLine()

" ====================================== "
" === surround.vim exists, but I do  === "
" === not want more plugins than     === "
" === those I really can't implement === "
" === this is nowhere near advanced  === "
" === as the plugin but it is simple === "
" === enough for my use case         === "
" === Limitation: Only works in the  === "
" === regular line mode, not V or C-v=== "
" ====================================== "
function! SurroundWith(char)
  " Define pairs
  let sPairs = { '(' : '( ', '[' : '[ ', '{' : '{ ', ')' : '(', ']' : '[', '}' : '{', '<' : '<> ', '>' : '<>' }
  let ePairs = { '(' : ' )', '[' : ' ]', '{' : ' }', '<' : ' </>', '>' : '</>' }
  " yank the selected text into the unnamed register
  normal! gvd
  " replace the selected text with the character
  normal! c
  " execute 'normal! i' . a:char
  if has_key(sPairs, a:char)
    execute 'normal! i' . sPairs[a:char]
  else
    execute 'normal! i' . a:char
  endif
  " paste the yanked text
  normal! p
  " insert the character at the end
  " execute 'normal! a' . a:char
  if has_key(ePairs, a:char)
    execute 'normal! a' . ePairs[a:char]
  else
    execute 'normal! a' . a:char
  endif
  " move the cursor to the end of the line
  " normal! $
endfunction

vnoremap <silent> s :<C-u>call SurroundWith(nr2char(getchar()))<CR>



" ====================================== "
" =========== VIM-PLUG START =========== "
" ====================================== "

" ====================================== "
" === If vim-plug is not found, then === "
" === prompt user to auto install it === "
" === at launch or comment out this  === "
" === VIM-PLUG block                 === "
" ====================================== "
if empty(glob('~/.vim/autoload/plug.vim'))
    let user_input = input("Do you want to install vim-plug? (y/n): ")

    if user_input ==# 'y' || user_input ==# 'Y'
        echo "Alright, installing vim-plug now..."
        silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    else
        echo "Okay then, you should comment out everything within the VIM-PLUG blocks in your vimrc to avoid further interference with these checks and messages"
    endif
endif

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
    " Plug 'yassinebridi/vim-purpura'

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
    echo "vim-plug is not installed, if you do not intend to then you can delete this warning in your .vimrc"
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
" === Remove Q from setting into Ex  === "
" === mode and instead remap it to gq=== "
" === Q will instead format lines    === "
" ====================================== "
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

