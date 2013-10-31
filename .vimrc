".vimrc

" Load up plugins if pathogen is installed
silent! call pathogen#infect()
silent! call pathogen#helptags()

set autoindent          " Copy indent from current line when starting a new line
set copyindent          " Copy the previous indentation on autoindenting
set linebreak           " Break wrapped lines on words
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
set cursorline          " Highlight the cursor line
set nostartofline       " Don't jump to start of line when paging up/down
set timeoutlen=300      " Set multi-character command time-out
set gdefault            " Makes search/replace global by default
set mouse=a             " Enables the mouse in all modes
set title               " Show file in title bar
set rnu                 " Use relative line numbers
set hlsearch            " Highlight search results
set viminfo='20,\"500   " Remember copy registers after quitting in the .viminfo file
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " No backup~ files
set hidden              " Don't ask to save when changing buffers
set noswapfile          " Stop creating bothersome swap files

" Use comma as leader, move comma's default functionality to \
let mapleader=','
nnoremap <bslash> ,

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
    syntax enable
    set guifont=Consolas
    set background=dark
    colorscheme solarized
endif

" Toggles vim's paste mode; when we want to paste something into vim from a
" different application, turning on paste mode prevents extra whitespace.
set pastetoggle=<F7>

" Clear search result highlighting on press enter
nnoremap <cr> :nohlsearch<cr>

" Map \\ to go back to the previous buffer.
nnoremap <leader><leader> <c-^>
nnoremap <leader>v :sp $MYVIMRC<cr>

" Automatically reload vimrc after saving changes to it
autocmd BufWritePost .vimrc source $MYVIMRC
autocmd BufWritePost _vimrc source $MYVIMRC

" Make Y behave consistently like D instead of yy
nnoremap Y y$

" Simplify quick macro invocation with q register
nnoremap Q @q

" Use line position mark jump by default, and remap ` to quickly use M
nnoremap ' `
nnoremap ` mM
nnoremap `` `M

" jk quickly to exit insert/visual mode
inoremap jk <esc>
vnoremap jk <esc>

" Use K to split the current line
nnoremap K i<cr><esc>

" Ctrl+j/k to move around quicker
nnoremap <c-j> 15gj
nnoremap <c-k> 15gk
vnoremap <c-j> 15gj
vnoremap <c-k> 15gk

" Map a ctrl-free shortcut for pasting the yank register
vnoremap <leader>p c<c-r>0<esc>
nnoremap <leader>p i<c-r>0<esc>

" Some sane bindings for window resizing
nnoremap <c-w>, 2<c-w><
nnoremap <c-w>. 2<c-w>>
nnoremap <c-w>y 10<c-w><
nnoremap <c-w>o 10<c-w>>
nnoremap <c-w><c-y> 10<c-w><
nnoremap <c-w><c-o> 10<c-w>>

" Stay in visual mode when indenting
vnoremap < <gv
vnoremap > >gv

" Map Ctrl+v to paste in insert mode, using the appropriate clipboard
if has('macunix')
    inoremap <c-v> <c-r>"
elseif has('unnamedplus')
    inoremap <c-v> <c-r>+
else
    inoremap <c-v> <c-r>*
endif

" This option makes Vim use the system default clipboard. On OSX use nothing.
if has('unnamedplus')
    " Note that on X11, there are _two_ system clipboards: the "standard" one, and
    " the selection/mouse-middle-click one. Vim sees the standard one as register
    " '+' (and this option makes Vim use it by default) and the selection one as '*'
    set clipboard=unnamedplus,unnamed
elseif !has('macunix')
    set clipboard=unnamed
endif

" Allow us to save a file we don't have permission to save after opening it
cnoremap w!! w !sudo tee % >/dev/null

" Switch syntax highlighting on when the terminal has colors
if &t_Co > 2 || has('gui_running')
    syntax on
endif

" Automatically delete trailing DOS-returns and whitespace on file open and write
augroup vimrc
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END

" --------- CtrlP settings -----------------------------------------------------

" Force CtrlP to operate from the working directory instead of the current file's
let g:ctrlp_working_path_mode = ''

" Size CtrlP window a little bigger than default
let g:ctrlp_max_height = 20

" --------- OmniSharp settings -------------------------------------------------

" This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

" Ignore some subfolders and files which we won't want to edit in vim
set wildignore+=*\\bin\\*,*/bin/*,*\\obj\\*,*/obj/*,*.dll,*.exe,*.pidb,*.meta

" Set the type lookup function to use the preview window instead of the status line
let g:OmniSharp_typeLookupInPreview = 1

" Showmatch significantly slows down omnicomplete when the first match contains parentheses.
set noshowmatch

" Don't autoselect first item in omnicomplete, show if only one item (for preview)
set completeopt=longest,menuone,preview

" Use OmniSharp's goto-definition in place of vim's built-in implementation.
nnoremap gd :OmniSharpGotoDefinition<cr>

" A bunch of default mappings for OmniSharp, TODO: cull
nnoremap <F5> :wa!<cr>:OmniSharpBuildAsync<cr>
nnoremap <leader>fi :OmniSharpFindImplementations<cr>
nnoremap <leader>ft :OmniSharpFindType<cr>
nnoremap <leader>fs :OmniSharpFindSymbol<cr>
nnoremap <leader>fu :OmniSharpFindUsages<cr>
nnoremap <leader>fm :OmniSharpFindMembersInBuffer<cr>
nnoremap <leader>tt :OmniSharpTypeLookup<cr>
nnoremap <leader>ii :OmniSharpGetCodeActions<cr>
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
nnoremap <leader>tp :OmniSharpAddToProject<cr>
nnoremap <leader>oh :OmniSharpHighlightTypes<cr>
nnoremap <leader>os O/// <summary><cr></summary><esc>O

" Map command 'OSR' to do a rename with OmniSharp
command! -nargs=1 OSR :call OmniSharp#RenameTo("<args>")

" --------- Unity3D bindings ---------------------------------------------------

function! Unity3D_newClass (name)
    exe "e %:p:h/" . a:name . '.cs'
    normal ousing System;
    normal ousing UnityEngine;
    normal o
    exe 'normal opublic class ' . a:name . ' : MonoBehaviour'
    normal o{
    normal o}
    normal k
endfunction

" Creates a new Unity MonoBehaviour in the same directory as the current file.
command! -nargs=1 Unew :call Unity3D_newClass("<args>")

" --------- neocomplcache settings (mainly for OmniSharp) ----------------------

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_min_syntax_length = 0
let g:neocomplcache_disable_auto_complete = 1
let g:neocomplcache_enable_auto_close_preview = 0

" Terminal vim understands c-space as c-@ so map both to auto-complete
imap <c-space> <c-x><c-o><c-n><c-p>
imap <c-@> <c-space>
inoremap <expr><CR> pumvisible() ? neocomplcache#smart_close_popup() : "\<CR>"

" Define keyword for minor languages
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Enable heavy omni completion
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.cs = '.*'

