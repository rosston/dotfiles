" Use vim settings, rather than vi setting
" This must be first, because it changes other options as a side effect.
set nocompatible

" Use vim-plug to manage plugins
filetype off                    " force reloading *after* vim-plug loads
call plug#begin('~/.vim/plugged')

Plug 'bkad/CamelCaseMotion'
Plug 'mileszs/ack.vim'
Plug 'GertjanReynaert/cobalt2-vim-theme'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'Shougo/neocomplete.vim'
Plug 'scrooloose/syntastic'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-abolish'
Plug 'bling/vim-airline'
Plug 'tpope/vim-capslock'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'tpope/vim-obsession'
Plug 'honza/vim-snippets'
Plug 'tpope/vim-surround'

call plug#end()
filetype plugin indent on       " enable detection, plugins and indenting in one step

" Turn on syntax highlighting
syntax on

" Turn on omni completion
set omnifunc=syntaxcomplete#Complete

" Set ',' as mapleader
let mapleader=","

" Editing behaviour {{{
set showmode                    " always show what mode we're currently editing in
set tabstop=4                   " a tab is four spaces
set softtabstop=4               " when hitting <BS>, pretend like a tab is removed, even if spaces
set expandtab                   " expand tabs by default (overloadable per file type later)
set shiftwidth=4                " number of spaces to use for autoindenting
set shiftround                  " use multiple of shiftwidth when indenting with '<' and '>'
set backspace=indent,eol,start  " allow backspacing over everything in insert mode
set autoindent                  " always set autoindenting on
set copyindent                  " copy the previous indentation on autoindenting
set number                      " always show line numbers
set showmatch                   " set show matching parenthesis
runtime macros/matchit.vim      " make % match opening/closing HTML tags
set ignorecase                  " ignore case when searching
set smartcase                   " ignore case if search pattern is all lowercase,
                                "    case-sensitive otherwise
set smarttab                    " insert tabs on the start of a line according to
                                "    shiftwidth, not tabstop
set scrolloff=20                " keep 4 lines off the edges of the screen when scrolling
set hlsearch                    " highlight search terms
set incsearch                   " show search matches as you type
set gdefault                    " search/replace "globally" (on a line) by default

" set invisible characters
set listchars=tab:▸\ ,trail:·,extends:#,nbsp:·

set nolist                      " don't show invisible characters by default,
                                " but it is enabled for some file types (see later)
"set pastetoggle=<F2>            " when in insert mode, press <F2> to go to
                                "    paste mode, where you can paste mass data
                                "    that won't be autoindented
set mouse=a                     " enable using the mouse if terminal emulator
                                "    supports it (xterm does)

set fileformats="unix,dos,mac"
set wrap
set textwidth=79
set formatoptions=qrn1
set colorcolumn=80

set nrformats=                  " make <C-a> and <C-x> play well with
                                "    zero-padded numbers (i.e. don't consider
                                "    them octal or hex)

set shortmess+=I                " hide the launch screen
set clipboard=unnamed           " normal OS clipboard interaction
set autoread                    " automatically reload files changed outside of Vim

" Toggle show/hide invisible chars
nnoremap <leader>i :set list!<cr>

" Toggle line numbers
nnoremap <leader>N :setlocal number!<cr>

" Fix Vim’s horribly broken default regex “handling” by automatically
" inserting a \v before any string you search for.
nnoremap / /\v
vnoremap / /\v
" }}}


" Editor layout {{{
set termencoding=utf-8
set encoding=utf-8
set lazyredraw                  " don't update the display while executing macros
set laststatus=2                " tell VIM to always put a status line in, even
                                "    if there is only one window
set cmdheight=2                 " use a status bar that is 2 rows high

set ruler                       " enable line/col numbers in status bar
set relativenumber              " show line numbers relative to current line,
                                "    makes it easier to use motion commands
" }}}


" Vim behaviour {{{
set hidden                      " hide buffers instead of closing them this
                                "    means that the current buffer can be put
                                "    to background without being written; and
                                "    that marks and undo history are preserved
set switchbuf=useopen           " reveal already opened files from the
                                " quickfix window instead of opening new
                                " buffers
set history=1000                " remember more commands and search history
set undolevels=1000             " use many muchos levels of undo
if v:version >= 730
    set undofile                " keep a persistent backup file
    set undodir=~/.vim/tmp/.undo,~/tmp,/tmp
                                " store undo files in one of these directories
endif
set backupdir=~/.vim/tmp/backup/,~/tmp,/tmp
                                " store backup files in one of these
                                " directories
set directory=~/.vim/tmp/swap/,~/tmp,/tmp
                                " store swap files in one of these directories
set wildmenu                    " make tab completion for files/buffers act like bash
set wildmode=list:full          " show a list when pressing tab and complete
                                "    first full match
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                       " change the terminal's title
set visualbell                  " don't beep
set noerrorbells                " don't beep
set showcmd                     " show (partial) command in the last line of the screen
                                "    this also shows visual selection info
set nomodeline                  " disable mode lines (security measure)
set cursorline                  " underline the current line, for quick orientation
" save and restore cursor position when switching buffers
if v:version >= 700
  au BufLeave * let b:winview = winsaveview()
  au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif
" }}}


" Shortcut mappings {{{
" Remap old behavior of , (repeat last f, F, t, or T command in the opposite
" direction) to <leader>F
nnoremap <leader>F ,

" Don't require the Shift key to form chords to enter ex mode.
nnoremap ; :
" Remap old behavior of ; (repeat last f, F, t, or T command) to <leader>f
nnoremap <leader>f ;

" Remap j and k to act as expected when used on long, wrapped, lines
nnoremap j gj
nnoremap k gk

" Clears the search register
nnoremap <silent> <leader>/ :nohlsearch<CR>

" Get into netrw easily
nnoremap <silent> <leader>e :Explore<CR>

" Launch Ack
nnoremap <leader>ag :Ack! ""<left>
" }}}


" Strip trailing whitespace {{{
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" }}}

" Style/theme settings {{{
if has("termtruecolor")
    let &t_8f="\e[38;2;%ld;%ld;%ldm"
    let &t_8b="\e[48;2;%ld;%ld;%ldm"
    set guicolors
endif

if has('gui_running')
  set guifont=Source\ Code\ Pro:h13
endif

colorscheme cobalt2

" set a sane background color for current line
:hi CursorLine guifg=NONE guibg=#1f4662 ctermfg=NONE

" make the wrap guide less crazy than pure black
highlight ColorColumn ctermbg=lightgrey guibg=#3b5364

" change cursor shape in iTerm
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
" }}}


" Make netrw nice {{{
" Change directory to the current buffer when opening files.
set autochdir
" }}}


" vim-indent-guides settings {{{
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#3b5364 ctermbg=3
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#3b5364 ctermbg=4
" }}}


" CtrlP settings {{{
:nnoremap <C-k> :CtrlPBuffer<CR>
let g:ctrlp_max_files = 20000
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
    \ 'file': '\v[\/](\.DS_Store)$',
    \ 'dir': '\v[\/](\.git|\.idea|bower_components|dist|node_modules|tmp|utilities\/deployment\/package\/content)$',
    \ }
" }}}


" neocomplete settings {{{
let g:neocomplete#enable_at_startup = 1
" }}}


" YouCompleteMe settings {{{
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
" }}}


" vim-airline settings {{{
let g:airline#extensions#tabline#enabled = 1
" }}}


" syntastic settings {{{
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" put errors in location list
let g:syntastic_always_populate_loc_list = 1
" automatically show/hide location list based on errors
let g:syntastic_auto_loc_list = 1
" keep the location list (of errors) small
let g:syntastic_loc_list_height = 5

let g:syntastic_enable_balloons = 0
let g:syntastic_enable_highlighting = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
        \ "mode": "active",
        \ "active_filetypes": ["javascript"],
        \ "passive_filetypes": ["html"] }
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_eslint_exec = 'eslint_d'
" }}}


" ack settings {{{
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif
" }}}


" vim-gitgutter settings {{{
let g:gitgutter_realtime = 0
" }}}

fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

