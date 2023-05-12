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

" Fuzzy find
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

" Language server manager
if $NVIM_BASIC_MODE != "1"
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'fannheyward/telescope-coc.nvim'
  Plug 'github/copilot.vim'
endif

" Auto reload externally modified files
Plug 'djoshea/vim-autoread'

" Auto-determine indentation rules
Plug 'tpope/vim-sleuth'

" Copy link to selection on github
Plug 'knsh14/vim-github-link'

" Git integrations
Plug 'tpope/vim-fugitive'

" Edit text object surroundings
Plug 'tpope/vim-surround'

" Autoformat JS/TS
Plug 'prettier/vim-prettier', { 'do': 'npm install' }

" Syntax highlights
Plug 'OrangeT/vim-csharp'
Plug 'leafgarland/typescript-vim'
Plug 'cespare/vim-toml'
Plug 'tikhomirov/vim-glsl'
Plug 'dag/vim-fish'
Plug 'ziglang/zig.vim'
Plug 'DingDean/wgsl.vim'

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

" Dont try to be smart about comments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

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
  set statusline=%{getcwd()}\ :\ %f\ %#CursorColumn#%#CursorColumn#%=\ %#StatusLineNC#%{FugitiveStatusline()}%#CursorColumn#\ %l:%c\ %p%%\ %y
else
  set statusline=%{getcwd()}\ :\ %f\ %#CursorColumn#\ %{coc#status()}%{get(b:,'coc_current_function','')}%#CursorColumn#%=\ %#StatusLineNC#%{FugitiveStatusline()}%#CursorColumn#\ %l:%c\ %p%%\ %y
endif

" -------------------- Colors --------------------

set termguicolors

au BufNewFile,BufRead *.ejs set filetype=html

if len(system("grep alacritty.dark.yml /home/jaburns/.alacritty.yml")) > 2
  colorscheme corvine
  highlight Normal guibg=NONE

  highlight Tabs guibg=#222222

  highlight CursorLine guibg=#3a3a3a
  highlight TelescopeSelection guibg=#444444
  highlight TelescopePreviewLine guibg=#555555

  highlight VertSplit guibg=NONE
  highlight VertSplit guifg=#8888cc
  highlight StatusLine guibg=#393939
  highlight StatusLine guifg=#aaaaff
  highlight StatusLineNC guibg=#393939
  highlight StatusLineNC guifg=#eeeeee
  highlight CursorColumn guibg=#505050
  highlight CursorColumn guifg=#dddddd

  highlight CocExplorerCocErrorSignColor_Internal guifg=#ff8888
  highlight CocExplorerCocWarningSignColor_Internal guifg=#cccc88

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

" Copilot
let g:copilot_filetypes = { '*': v:false }
imap <silent><script><expr> <C-L> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true
imap <C-J> <Plug>(copilot-suggest)
imap <C-K> <Plug>(copilot-next)
imap <C-H> <Plug>(copilot-dismiss)

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

function! ToggleQuickFix()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
        copen
        wincmd p
    else
        cclose
    endif
endfunction

function! CocExplorerBufferExists()
    for buf in getbufinfo()
        if getbufvar(buf.bufnr, '&filetype') ==# 'coc-explorer'
            return 1
        endif
    endfor
    return 0
endfunction

function! RevealInCocExplorer()
    if CocExplorerBufferExists()
        call CocAction('runCommand', 'explorer.doAction', 'closest', ['reveal:0'], [['relative', 0, 'file']])
    endif
endfunction

" Auto-highligh current file in coc-explorer if open
autocmd BufReadPost * call RevealInCocExplorer()

" No paste with middle mouse wheel
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>
map <2-MiddleMouse> <Nop>
imap <2-MiddleMouse> <Nop>
map <3-MiddleMouse> <Nop>
imap <3-MiddleMouse> <Nop>
map <4-MiddleMouse> <Nop>
imap <4-MiddleMouse> <Nop>

nnoremap <c-p> :Telescope find_files<CR>
nnoremap <leader><cr> <cmd>nohlsearch<cr>
nnoremap <leader><leader> <c-^>

nnoremap <leader>q <cmd>call ToggleQuickFix()<cr>
nnoremap <leader>w <cmd>wa<cr><cmd>call DeleteHiddenBuffers()<cr>
nnoremap <leader>e <cmd>Telescope coc workspace_diagnostics path_display={shorten={len=4,exclude={1,-1}}}<cr>
nmap <silent> <leader>r <Plug>(coc-rename)
nnoremap <leader>t <cmd>CocCommand explorer --no-toggle --sources buffer-,file+ --open-action-strategy previousWindow<cr>
nnoremap <leader>T <cmd>CocCommand explorer --no-toggle --sources buffer-,file+ --position right --open-action-strategy previousWindow<cr>
nnoremap <leader>y :let @+ = expand("%:p")<cr>
vnoremap         Y :GetCurrentBranchLink<cr>
nnoremap <leader>u <cmd>UndotreeToggle<cr>
nnoremap <leader>i <cmd>call CocActionAsync('doHover')<cr>
nmap <silent> <leader>I <cmd>Telescope coc implementations<cr>
nnoremap <leader>o <cmd>copen<cr>
nnoremap <leader>p viwP

nmap <silent> <leader>a <Plug>(coc-codeaction-selected)w
nmap <silent> <leader>s <cmd>Telescope coc workspace_symbols<cr>
nmap <silent> <leader>S <cmd>CocCommand tsserver.goToSourceDefinition<cr>
nmap <silent> <leader>d <cmd>Telescope coc definitions<cr>
nmap <silent> <leader>D <cmd>Telescope coc type_definitions<cr>
nmap <silent>        gd <cmd>Telescope coc definitions<cr>
nmap <silent> <leader>f <cmd>Telescope coc references<cr>
nmap <silent> <leader>F <cmd>Telescope grep_string<cr>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gB :Git branch<cr>
nnoremap <leader>gg :Ge :<cr>
nnoremap <leader>gv <cmd>Telescope git_status<cr>
nnoremap <leader>gd :Git diff<cr>
nnoremap <leader>gf :split<cr>:e term://git fetch --all<cr>i
nnoremap <leader>gu :split<cr>:e term://git pull --rebase<cr>i
nnoremap <leader>gU :split<cr>:e term://git pull<cr>i
nnoremap <leader>gp :split<cr>:e term://git push<cr>i
nnoremap <leader>gl :Git log --all --graph --decorate --oneline --date=relative --pretty=format:"%h %ad %an%d :: %s"<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>G <cmd>Telescope live_grep<cr>
nnoremap <leader>h <cmd>Telescope command_history<cr>
nnoremap <leader>H :CocCommand clangd.switchSourceHeader<cr>
nmap <leader>j :cnext<cr>
nmap <leader>J <Plug>(coc-diagnostic-next)
nmap <leader>k :cprev<cr>
nmap <leader>K <Plug>(coc-diagnostic-prev)

nnoremap <leader>x <cmd>bd<CR>
nnoremap <leader>c :Copilot<CR>
nnoremap <leader>v <cmd>e $MYVIMRC<cr>
nnoremap <leader>V <cmd>CocConfig<cr>
nnoremap <leader>n <cmd>enew<cr>
nmap <leader>m :call coc#config('diagnostic.messageTarget', 'echo')<cr>
nmap <leader>M :call coc#config('diagnostic.messageTarget', 'float')<cr>

" Coc auto-complete configuration
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<cr>"
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Function and class object selection keys
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Prettier config
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
let g:prettier#config#print_width = 100
let g:prettier#config#tab_width = 4
let g:prettier#config#trailing_comma = 'all'
let g:prettier#config#use_tabs = 'false'
let g:prettier#config#semi = 'false'

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

" *** Telescope Config ***
lua << EOF
local actions = require "telescope.actions"
require('telescope').setup{
    defaults = {
        layout_strategy = "vertical",
        mappings = {
            i = {
                -- ["<C-j>"] = actions.send_to_qflist + actions.open_qflist
                ["<C-j>"] = function(bufnr)
                    actions.send_to_qflist(bufnr)
                    actions.open_qflist(bufnr)
                    vim.cmd("wincmd p")
                end
            },
        },
    },
}
EOF
