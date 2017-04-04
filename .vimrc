".vimrc
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'kien/ctrlp.vim'

call vundle#end()
filetype plugin indent on

set autoindent          " Copy indent from current line when starting a new line
set copyindent          " Copy the previous indentation on autoindenting
set nojoinspaces        " Don't convert spaces to tabs
set shiftround          " Round spaces to nearest shiftwidth multiple
set smarttab            " Indent instead of tab at start of line
set shiftwidth=4        " An indent is n spaces
set tabstop=4           " A tab is rendered as n spaces
set softtabstop=4       " "
set expandtab          " Always uses spaces instead of tabs

set linebreak           " Break wrapped lines on words
set ruler               " Show the line and column number of the cursor position
set number              " Print the line number in front of each line
set scrolloff=15        " Minimal number of screen lines to keep above and below the cursor
set cursorline          " Highlight the cursor line
set nostartofline       " Don't jump to start of line when paging up/down
set timeoutlen=500      " Set multi-character command time-out
set gdefault            " Makes search/replace global by default
set title               " Show file in title bar
set rnu                 " Use relative line numbers
set hlsearch            " Highlight search results
set viminfo='20,\"500   " Remember copy registers after quitting in the .viminfo file
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " No backup~ files
set hidden              " Don't ask to save when changing buffers
set noswapfile          " Stop creating bothersome swap files
set lazyredraw          " Don't render every detail when running macros
set nowrap              " No line wrap by default
set ignorecase          " This needs to be enabled to use smartcase
set smartcase           " Use smartcase in searches (and replaces unfortunately)
set textwidth=0         " Turn off automatic newline insertion
set wrapmargin=0        "  "
set autowrite           " Write files when focus is lost

syntax enable
set background=light

let mapleader=' '

" Clear vimrc augroup so we don't pile up autocmds when reloading the config.
augroup vimrc
    autocmd!
augroup END

highlight Tabs ctermbg=235 guibg=#000000
match Tabs "\t"

" Make Y behave consistently like D instead of yy
nnoremap Y y$

" Make X behave like d, but preserve the " register.
nnoremap X "_d
vnoremap X "_d
nnoremap XX "_dd

" Make c preserve the " register
nnoremap c "_c
nnoremap C "_C
vnoremap c "_c
vnoremap C "_C

nnoremap H ^
vnoremap H ^

" Prevent pasting in visual mode from yanking the replaced text.
vnoremap p "_dP

" Prevent x from clobbering the " register.
nnoremap x "_x
vnoremap x "_x

" Simplify quick macro invocation with q register
nnoremap Q @q

" Use tick and doubletick to get around quickly, leaving ` for named marks.
nnoremap ' mM
nnoremap '' `M

" Keep selection during tabbing. Don't require shift to tab in v-mode.
vnoremap . >gv
vnoremap , <gv

" Use K to split the current line
nnoremap K i<cr><esc>

" Ctrl+j/k to move around quicker
nnoremap <c-j> 15j
nnoremap <c-k> 15k
vnoremap <c-j> 15j
vnoremap <c-k> 15k

" Get the standard c-backspace behaviour in insert mode
inoremap <c-backspace> <c-w>

" Paste in insert mode
inoremap <c-v> <esc>pa
inoremap <c-c> <c-v>

fun! RefreshAllBuffers()
  set noconfirm
  bufdo e!
  set confirm
  syntax on
endfun

nnoremap <leader>q call RefreshAllBuffers()

" Print and/or yank the current file name
nnoremap <leader>f :echo @%<cr>
nnoremap <leader>yf o<esc>0C<c-r>%<esc>0y$"_ddk

nnoremap <leader>p "_ciw<c-r>"<esc>
nnoremap <leader>P "_ciW<c-r>"<esc>

" Get rid of GUI noise in gvim (toolbar, menus, scrollbars)
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=M

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction

nnoremap <leader>q :call DeleteHiddenBuffers()<cr>

" Mappings to open settings
nnoremap <leader>vv :e $MYVIMRC<cr>
nnoremap <leader>vc :e ~/.vim/after/ftplugin/cs.vim<cr>
nnoremap <leader>vj :e ~/.vim/after/ftplugin/javascript.vim<cr>

" Use system clipboard as default
if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
end

" Toggles vim's paste mode; when we want to paste something into vim from a
" different application, turning on paste mode prevents extra whitespace.
set pastetoggle=<F7>

" Clear search result highlighting on press enter
nnoremap <leader><cr> :nohlsearch<cr>

" Some leader combos to navigate buffers
nnoremap <leader><leader> <c-^>

augroup vimrc
    " Automatically reload vimrc after saving changes to it
    autocmd BufWritePost vimrc source $MYVIMRC

    " Treat AS3 files like javascript files
    autocmd BufNewFile,BufRead *.as set filetype=javascript
    autocmd BufNewFile,BufRead *.as set shiftwidth=4

    " Automatically save files on switch from buffer, and reload files on switch to buffer
    au FocusGained,BufEnter * :silent! !
    au FocusLost,WinLeave * :silent! w
augroup END

" Some sane bindings for window resizing
nnoremap <c-w>y 10<c-w><
nnoremap <c-w>u 10<c-w>+
nnoremap <c-w>i 10<c-w>-
nnoremap <c-w>o 10<c-w>>
nnoremap <c-w><c-y> 10<c-w><
nnoremap <c-w><c-u> 10<c-w>+
nnoremap <c-w><c-i> 10<c-w>-
nnoremap <c-w><c-o> 10<c-w>>
nnoremap <c-w>, 2<c-w><
nnoremap <c-w>. 2<c-w>>

" Allow us to save a file we don't have permission to save after opening it
cnoremap w!! w !sudo tee % >/dev/null

" Automatically delete trailing DOS-returns and whitespace on file open and write
augroup vimrc
    autocmd BufRead,BufWritePre,FileWritePre * silent! %s/[\r \t]\+$//
augroup END

" Ignore some subfolders and files which we won't want to edit in vim
let NERDTreeIgnore = ['\.meta$']
set wildignore+=*\\bin\\*,*/bin/*,*\\obj\\*,*/obj/*,*.dll,*.exe,*.pidb,*.meta
set wildignore+=node_modules,*.svg,*/public/vendors/**,*/build/**

" Enable default omnicomplete
set omnifunc=syntaxcomplete#Complete

" --------- CtrlP settings -----------------------------------------------------

" Force CtrlP to operate from the working directory instead of the current file's
let g:ctrlp_working_path_mode = ''

" Size CtrlP window a little bigger than default
let g:ctrlp_max_height = 20

" Ignore gitignore files
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
