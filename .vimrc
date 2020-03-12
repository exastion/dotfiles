"
"                  ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"                  ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"                  ██║   ██║██║██╔████╔██║██████╔╝██║
"                  ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ██╗╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                ╚═╝ ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ 

" => Vundle {{{

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'lervag/vimtex'
Plugin '907th/vim-auto-save'
Plugin 'nanotech/jellybeans.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-fugitive'
Plugin 'SirVer/ultisnips'
Plugin 'mboughaba/i3config.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'evidens/vim-twig'
Plugin 'airblade/vim-gitgutter'

call vundle#end()

" }}}
" => General {{{

set nocompatible

set history=200     " keep 200 lines of command line history

filetype plugin on
filetype indent on

" Reload file if it was changed on disk and not in vim.
set autoread

let mapleader = ","

set updatetime=100

" }}}
" => User interface {{{

set scrolloff=5         " How many lines to show around the cursor.
set wildmenu            " Display completition matches in a status line
set wildignore=*.o      " Ignore object files
set ruler               " Show the cursor position all the time

" Allow backspacing over everything in insert mode.
set backspace=eol,start,indent

" Ignore case when searching for lowercase
set ignorecase
set smartcase

set hlsearch
set incsearch

set lazyredraw          " Do not redraw while executing macros
set showmatch           " Show matching brackets
set matchtime=2         " How many tenths of a second to jump back to matching bracket

set noerrorbells        " Turn off annoying bell on error

set showcmd             " Always show last typed command
set cursorline          " Highlight current line

set ttimeout
set ttimeoutlen=100
set display=truncate
set mouse=a

nnoremap <silent> * *<C-o>
nmap <silent> <2-leftmouse> *

nmap <F8> :TagbarToggle<CR>
nmap to :tabe 
nmap tc :tabc<CR>

set number relativenumber
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave    * set relativenumber
    autocmd BufLeave,FocusLost,InsertEnter      * set norelativenumber
augroup END

nmap <F8> :TagbarToggle<CR>

" }}}
" => Colors and Fonts {{{

syntax enable

" Colorscheme
let g:jellybeans_background_color_256='NONE'
colorscheme jellybeans

set encoding=utf8
set fileformats=unix,dos,mac

" }}}
" => Files, backups and undo {{{

set undofile
set undodir=~/.vim/undo

" }}}
" => Text, tab and indent {{{

set expandtab       " Use spaces instead of tabs
set smarttab        " Be smart when using tabs
set shiftwidth=4
set tabstop=4
set autoindent
set smartindent
set nowrap
set tw=76

" }}}
" => Visual mode {{{

" Visual mode pressing / or ? searches for the current selection
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>

" Visual shifting
vnoremap < <gv
vnoremap > >gv

 " }}}
 " => Moving around, windows and buffers {{{

let g:UltiSnipsJumpForwardTrigger = "<tab>"
map <silent> <Home> :call Home()<CR>
imap <Home> <ESC> :call Home()<CR>i


map <silent> <leader><cr> :noh<cr>
map <silent> <Esc><Esc> :noh<cr>

nnoremap <silent> <leader>cd :cd %:p:h<CR>

augroup vimStartup
    au!
    " Return to last edit position when opening files
    autocmd BufReadPost *
                \ if line("'\"") >= 1 && line("'\"") <= line("$") |
                \   exe "normal! g`\"" |
                \ endif
augroup END

" }}}
" => Status line {{{

"set laststatus=2

"set statusline=%<%f\
"set statusline+=%w%h%m%r
"set statusline+=%{fugitive#statusline()}
"set statusline+=\ [%{&ff}/%Y]
"set statusline+=\ [%{getcwd()}]
"set statusline+=%=%-14.(%l,%c%V%)\ %p%%

" }}}
" => Editing mappings {{{

" Move current/selected line(s) up or down
nmap ^[g mz:move-2<cr>`z
nmap ^[r mz:move+<cr>`z
vmap ^[g :move'<-2<cr>`>my`<mzgv`yo`z
vmap ^[r :move'>+<cr>`>my`>mzgv`yo`z

" Un/Comment selected line and move down
map <F4> ,c j

" }}}
" => Misc {{{

cmap w!! w !sudo tee % > /dev/null
autocmd BufWritePost $MYVIMRC source $MYVIMRC
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0]) | startinsert

set nrformats-=octal

inoremap <C-U> <C-G>u<C-U>

let c_comment_strings=1
 " }}}
" => Folding {{{

set foldenable

nnoremap <space> za

" }}}
" => Tex {{{

set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'
let g:vimtex_view_general_viewer = 'zathura'
let g:syntastic_disabled_filetypes=['tex']

autocmd filetype tex nnoremap <F5> :VimtexCompile<CR>

" }}}
" => Autosave {{{

autocmd filetype tex let g:autosave = 1

" }}}
" => Functions {{{

function! VisualSelection(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! Home()
    let l:x = col('.')
    execute "normal ^"
    if x == col('.')
        execute "normal 0"
    endif
endfunction

" }}}


set modeline
set modelines=1
" vim: foldmethod=marker:foldlevel=0
