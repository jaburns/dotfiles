".vimrc


set autoindent          " Copy indent from current line when starting a new line
set copyindent          " Copy the previous indentation on autoindenting
set cindent             " Indenting for C-like languages
set shiftwidth=4        " An indent is n spaces
set nojoinspaces        " Don't convert spaces to tabs
set shiftround          " Round spaces to nearest shiftwidth multiple
set smarttab            " Indent instead of tab at start of line
set expandtab           " Always uses spaces instead of tabs
set tabstop=4           " A tab is rendered as n spaces
set ruler               " Show the line and column number of the cursor position
set number              " Print the line number in front of each line
set scrolloff=10        " Minimal number of screen lines to keep above and below the cursor
set nostartofline       " Don't jump to start of line when paging up/down
set timeoutlen=150      " Set multi-character command time-out
set gdefault            " Makes search/replace global by default
set mouse=a             " Enables the mouse in all modes
set title               " Show file in title bar
set rnu                 " Use relative line numbers
set viminfo='20,\"500   " Remember copy registers after quitting in the .viminfo file
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " No backup~ files


" Get rid of GUI noise (toolbar, menus, scrollbars)
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=M


filetype plugin indent on


" GUI VIM font/color configuration
if has('gui_win32')
    set guifont=Consolas
    colorscheme slate
endif


" Toggles vim's paste mode; when we want to paste something into vim from a
" different application, turning on paste mode prevents extra whitespace.
set pastetoggle=<F7>


" Make j and k behave as expected on overflow lines
nnoremap j gj
nnoremap k gk

" jk quickly to exit insert/visual mode
inoremap jk <esc>
vnoremap jk <esc>

" Use K to split the current line
nnoremap K i<cr><esc>

" Ctrl+j/k to move around quicker
noremap <c-j> 15gj
noremap <c-k> 15gk

" Use the arrow keys to move between splits
noremap <left>  <c-w>h
noremap <up>    <c-w>k
noremap <down>  <c-w>j
noremap <right> <c-w>l

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Map Ctrl+v to paste in insert mode, using the appropriate clipboard
if has('unnamedplus')
    inoremap <c-v> <c-r>+
else
    inoremap <c-v> <c-r>*
endif

" Allow us to save a file we don't have permission to save after opening it
cnoremap w!! w !sudo tee % >/dev/null


" This option makes Vim use the system default clipboard
if has('unnamedplus')
    " Note that on X11, there are _two_ system clipboards: the "standard" one, and
    " the selection/mouse-middle-click one. Vim sees the standard one as register
    " '+' (and this option makes Vim use it by default) and the selection one as '*'
    set clipboard=unnamedplus,unnamed
else
    set clipboard=unnamed
endif


" Switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has('gui_running')
    syntax on
endif


" Automatically delete trailing DOS-returns and whitespace on file open and write
augroup vimrc
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END


" Maximize gvim on load in Windows
if has('gui_win32')
    au vimrc GUIEnter * simalt ~x
endif


" Load up plugins if pathogen is installed
silent! call pathogen#infect()
silent! call pathogen#helptags()



