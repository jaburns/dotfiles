" -------------------------------------------------
" Additional setup instructions for nvim:
"
" - Install vim-plug: https://github.com/junegunn/vim-plug
" - :PlugInstall
" - :CocInstall
"     coc-explorer
"     coc-tsserver
"     coc-rust-analyzer
"     coc-pyright
"     coc-omnisharp
"     coc-json
"     coc-clangd
" -------------------------------------------------
"  Notes
"    Find and replace
"      :Rg some_pattern
"      <c-j><cr> to populate QF list
"      :cdo s/some_pattern/something_else/g (or :cfdo %s/...)
" -------------------- Plugins --------------------

call plug#begin('~/.config/nvim/plugged')

" Language server manager
if $NVIM_BASIC_MODE != "1"
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'antoinemadec/coc-fzf'
endif

" Auto reload externally modified files
Plug 'djoshea/vim-autoread'

" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Auto-determine indentation rules
Plug 'tpope/vim-sleuth'

" Copy link to selection on github
Plug 'knsh14/vim-github-link'

" Git integrations
Plug 'tpope/vim-fugitive'

" Edit text object surroundings
Plug 'tpope/vim-surround'

" Syntax highlights
Plug 'OrangeT/vim-csharp'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'
Plug 'dag/vim-fish'

" Visualize and navigate undo tree
Plug 'mbbill/undotree'

call plug#end()

" -------------------- Basic configuration --------------------

syntax enable
filetype plugin indent on

set mouse=a
set tabstop=4           " A tab is rendered as n spaces
set shiftwidth=4        " Default tab size is 4
set expandtab           " Default to spaces instead of tabs
set linebreak           " Break wrapped lines on words
set ruler               " Show the line and column number of the cursor position
set number              " Print the line number in front of each line
set scrolloff=15        " Minimal number of screen lines to keep above and below the cursor
set cursorline          " Highlight the cursor line
set nostartofline       " Don't jump to start of line when paging up/down
set timeoutlen=500      " Set multi-character command time-out
set title               " Show file in title bar
"set rnu                " Use relative line numbers
set hlsearch            " Highlight search results
set viminfo='20,\"500   " Remember copy registers after quitting in the .viminfo file
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " No backup~ files
set nowritebackup       " Really, no backup files even temporarily
set hidden              " Don't ask to save when changing buffers
set noswapfile          " Stop creating bothersome swap files
set lazyredraw          " Don't render every detail when running macros
set nowrap              " No line wrap by default
set textwidth=0         " Turn off automatic newline insertion
set wrapmargin=0        "  "
set signcolumn=yes      " Always show error/info column on left
set clipboard^=unnamed,unnamedplus " Use system clipboard as default
set pastetoggle=<f12>   " F12 for paste mode which doesnt insert tabs and junk
set ignorecase          " Case insensitive search for all lowercase unless \C provided
set noequalalways       " Dont resize windows when they're opened/closed
set splitbelow          " Default to splitting windows downwards
set smartcase           "  "

" Space as leader
let mapleader=' '

" Dont clear clipboard on quit
function! SaveVimClipboard()
    try
        call system("xclip -i -sel p -f | xclip -i -sel c", getreg('+'))
    catch
    endtry
endfunction
autocmd VimLeave * call SaveVimClipboard()

" Make Y behave consistently like D instead of yy
nnoremap Y y$

" Enter to yank in visual mode to match tmux
vnoremap <cr> y

" Make X behave like d, but preserve the " register.
nnoremap X "_d
vnoremap X "_d
nnoremap XX "_dd

" Make c preserve the " register
nnoremap c "_c
nnoremap C "_C
vnoremap c "_c
vnoremap C "_C

" Prevent pasting in visual mode from yanking the replaced text.
vnoremap p "_dP

" Prevent x from clobbering the " register.
nnoremap x "_x
vnoremap x "_x

" Simplify quick macro invocation with q register
nnoremap Q @q

" Use tick and doubletick to get around quickly, leaving ` for named marks.
nnoremap '1 mQ
nnoremap '2 mW
nnoremap '3 mE
nnoremap '4 mR
nnoremap '5 mT
nnoremap ''1 `Q
nnoremap ''2 `W
nnoremap ''3 `E
nnoremap ''4 `Q
nnoremap ''5 `Q

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

" Ctrl+a is tmux leader, so remap increment to ctrl+s
nnoremap <c-s> <c-a>

" Get the standard c-backspace behaviour in insert mode
inoremap <c-backspace> <c-w>

" Paste in insert mode
inoremap <c-v> <esc>pa
inoremap <c-c> <c-v>

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

" Ctrl-w to drop cursor out of terminal
tnoremap <c-w> <c-\><c-n>

" -------------------- Status line --------------------

set laststatus=2

if $NVIM_BASIC_MODE == "1"
  set statusline=%{getcwd()}\ %#CursorColumn#\ %f\ %#StatusLine#%#CursorColumn#%=\ %#StatusLine#%{FugitiveStatusline()}%#CursorColumn#\ %l:%c\ %p%%\ %y
else
  set statusline=%{getcwd()}\ %#CursorColumn#\ %f\ %#StatusLine#%{coc#status()}%{get(b:,'coc_current_function','')}%#CursorColumn#%=\ %#StatusLine#%{FugitiveStatusline()}%#CursorColumn#\ %l:%c\ %p%%\ %y
endif

" -------------------- Colors --------------------

set termguicolors

if len(system("grep alacritty.dark.yml /home/jaburns/.alacritty.yml")) > 2
  colorscheme corvine
  hi Normal guibg=NONE
  highlight Tabs guibg=#222222
else
  colorscheme envy
  set background=light
  hi Normal guibg=NONE
  highlight Tabs guibg=#dddddd
  highlight VertSplit guibg=#dddddd
  highlight VertSplit guibg=#dddddd
  highlight StatusLine guibg=#dddddd
endif

match Tabs "\t"

"   " ---------- Make terminal auto-close when exit with 0 error code ----------
"   "https://vi.stackexchange.com/questions/10292/how-to-close-and-and-delete-terminal-buffer-if-programs-exited
"
"   " Get the exit status from a terminal buffer by looking for a line near the end
"   " of the buffer with the format, '[Process exited ?]'.
"   func! s:getExitStatus() abort
"     let ln = line('$')
"     " The terminal buffer includes several empty lines after the 'Process exited'
"     " line that need to be skipped over.
"     while ln >= 1
"       let l = getline(ln)
"       let ln -= 1
"       let exitCode = substitute(l, '^\[Process exited \([0-9]\+\)\]$', '\1', '')
"       if l != '' && l == exitCode
"         " The pattern did not match, and the line was not empty. It looks like
"         " there is no process exit message in this buffer.
"         break
"       elseif exitCode != ''
"         return str2nr(exitCode)
"       endif
"     endwhile
"     throw 'Could not determine exit status for buffer, ' . expand('%')
"   endfunc
"
"   func! s:afterTermClose() abort
"     if s:getExitStatus() == 0
"       bdelete!
"     endif
"   endfunc
"
"   augroup MyNeoterm
"     autocmd!
"     " The line '[Process exited ?]' is appended to the terminal buffer after the
"     " `TermClose` event. So we use a timer to wait a few milliseconds to read the
"     " exit status. Setting the timer to 0 or 1 ms is not sufficient; 20 ms seems
"     " to work for me.
"     autocmd TermClose * call timer_start(20, { -> s:afterTermClose() })
"   augroup END

" -------------------- Leader key and plugin-related config/shortcuts --------------------

function! BuildAndRunProject(...)
    split
    Glcd
    exe "e term://" . join(a:000)
    exe "normal i"
endfunction

command! -nargs=* Run call BuildAndRunProject(<f-args>)

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'buflisted(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bdelete' buf
    endfor
endfunction

" No paste with middle mouse wheel
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

nnoremap <c-p> :Files<CR>
nnoremap <leader><cr> <cmd>nohlsearch<cr>
nnoremap <leader><leader> <c-^>

nnoremap <leader>q <cmd>cclose<cr>
nnoremap <leader>w <cmd>wa<cr><cmd>call DeleteHiddenBuffers()<cr>
nnoremap <leader>e <cmd>CocFzfList diagnostics<cr>
nmap <silent> <leader>r <Plug>(coc-rename)
nnoremap <leader>t <cmd>CocCommand explorer --sources buffer+,file+ --open-action-strategy previousWindow<cr>
nnoremap <leader>T <cmd>call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])<cr>
nnoremap <leader>y :let @+ = expand("%:p")<cr>
vnoremap         Y :GetCurrentBranchLink<cr>
nnoremap <leader>u <cmd>UndotreeToggle<cr>
nnoremap <leader>i <cmd>call CocActionAsync('doHover')<cr>
nmap <silent> <leader>I <Plug>(coc-implementation)
nnoremap <leader>o <cmd>copen<cr>
nnoremap <leader>p viw"_dP

nmap <silent> <leader>a <Plug>(coc-codeaction-selected)w
nnoremap <leader>s :%s/\s\+$//g<cr>
nmap <silent> <leader>d <Plug>(coc-definition)
nmap <silent>        gd <Plug>(coc-definition)
nmap <silent> <leader>f <Plug>(coc-references)
nnoremap <leader>F <cmd>call SearchQuickfixWithFzf()<cr>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gB :Git branch<cr>
nnoremap <leader>gg :Ge :<cr>
nnoremap <leader>gd :Git diff<cr>
nnoremap <leader>gf :split<cr>:e term://git fetch --all<cr>i
nnoremap <leader>gu :split<cr>:e term://git pull --rebase<cr>i
nnoremap <leader>gU :split<cr>:e term://git pull<cr>i
nnoremap <leader>gp :split<cr>:e term://git push<cr>i
nnoremap <leader>gl :Git log --all --graph --decorate --oneline<cr>
nnoremap <leader>gL :Git log --all --graph --decorate --oneline --first-parent<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>h :CocCommand clangd.switchSourceHeader<cr>
nmap <leader>j :cnext<cr>
nmap <leader>J <Plug>(coc-diagnostic-next)
nmap <leader>k :cprev<cr>
nmap <leader>K <Plug>(coc-diagnostic-prev)
nnoremap <leader>l :!npx eslint --fix <c-r>%<cr>

nnoremap <leader>x <cmd>bd<CR>
nnoremap <leader>v <cmd>e $MYVIMRC<cr>
nnoremap <leader>V <cmd>CocConfig<cr>
nnoremap <leader>n <cmd>enew<cr>
nmap <leader>m :call coc#config('diagnostic.messageTarget', 'echo')<cr>
nmap <leader>M :call coc#config('diagnostic.messageTarget', 'float')<cr>

nnoremap <leader><f4> <cmd>call CocAction('runCommand', 'tsserver.watchBuild')<cr>:copen<cr>
nnoremap <f4> :Run tsc --watch --noEmit<cr>
nnoremap <f5> :Run npm start
nnoremap <f6> :Run node rundev.js
nnoremap <f7> :Run blender

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" *** FZF Config ***

if has("win32")
  let $FZF_DEFAULT_COMMAND = 'git ls-files'
else
  let $FZF_DEFAULT_COMMAND = 'lsfiles'
endif

" CTRL-A CTRL-Q to select all and build quickfix list
" function! s:build_quickfix_list(lines)
"   call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
"   copen
"   cc
" endfunction
" let g:fzf_action = {
"   \ 'ctrl-k': function('s:build_quickfix_list'),
"   \ 'ctrl-t': 'tab split',
"   \ 'ctrl-x': 'split',
"   \ 'ctrl-v': 'vsplit' }
let $FZF_DEFAULT_OPTS = '--bind ctrl-j:select-all --reverse'

" :Prg To ripgrep from the git project root of the current buffer with FZF
command! -bang -nargs=* Prg
  \ call fzf#vim#grep(
  \   "rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'dir': system('git -C '.expand('%:p:h').' rev-parse --show-toplevel 2> /dev/null')[:-2]}), <bang>0)

" Helper function to write quickfix to temp file and open with preview with FZF
function! s:format_temp_qf_item(item) abort
  return (a:item.bufnr ? bufname(a:item.bufnr) : '')
        \ . ':' . (a:item.lnum  ? a:item.lnum : '')
        \ . (a:item.col ? ':' . a:item.col : ':')
        \ . ':' . substitute(a:item.text, '\v^\s*', ' ', '')
endfunction
function! SearchQuickfixWithFzf()
  if has("win32")
    let l:tmpfile = $USERPROFILE . '/AppData/Local/Temp/nvim_quickfix.txt'
  else
    let l:tmpfile = '/tmp/nvim_quickfix.txt'
  endif
  call writefile(map(getqflist(), 's:format_temp_qf_item(v:val)'), l:tmpfile, '')
  call fzf#vim#grep('cat ' . l:tmpfile, 1, fzf#vim#with_preview({ 'options': '--prompt="QF> "' }))
endfunction

" *** misc ***

" Clear trailing whitespace when saving files
autocmd BufWritePre * :%s/\s\+$//e

" Auto-format *.rs (rust) files prior to saving them
if $NVIM_BASIC_MODE != "1"
  autocmd BufWritePre *.rs call CocAction('format')
endif

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Avoid showing extra messages when using completion
set shortmess+=c
