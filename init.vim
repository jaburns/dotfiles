" -------------------------------------------------
" Additional setup instructions for nvim:
""
" - Install vim-plug: https://github.com/junegunn/vim-plug
" - For Rust, build and install rust-analyzer to PATH: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
" - For TS/JS: npm install -g typescript typescript-language-server
" - For C#: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#omnisharp
"   (Download omnisharp binaries to $HOME/source/omnisharp-bin, so that $HOME/source/omnisharp-bin/run exists)
" -------------------- Plugins --------------------

call plug#begin('~/.config/nvim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Auto reload externally modified files
Plug 'djoshea/vim-autoread'

" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'

" File explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Auto-determine indentation rules
Plug 'tpope/vim-sleuth'

" GLSL syntax highlighting
Plug 'tikhomirov/vim-glsl'

" Diagnostics window
Plug 'jaburns/trouble.nvim'

" Copy link to selection on github
Plug 'knsh14/vim-github-link'

" Git integrations
Plug 'tpope/vim-fugitive'

" Edit text object surroundings
Plug 'tpope/vim-surround'

" Show buffers in the tab line (breaks tabs, but LSP sucks with tabs anyway)
Plug 'ap/vim-buftabline'

" Non-broken syntax highlighting for typescript
Plug 'leafgarland/typescript-vim'

call plug#end()

" -------------------- Basic configuration --------------------

syntax enable
filetype plugin indent on

set mouse=a
set tabstop=4           " A tab is rendered as n spaces
set linebreak           " Break wrapped lines on words
set ruler               " Show the line and column number of the cursor position
set number              " Print the line number in front of each line
set scrolloff=15        " Minimal number of screen lines to keep above and below the cursor
set cursorline          " Highlight the cursor line
set nostartofline       " Don't jump to start of line when paging up/down
set timeoutlen=500      " Set multi-character command time-out
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
set textwidth=0         " Turn off automatic newline insertion
set wrapmargin=0        "  "
set signcolumn=yes      " Always show error/info column on left
set clipboard^=unnamed,unnamedplus " Use system clipboard as default
set pastetoggle=<F7>    " F7 for paste mode which doesnt insert tabs and junk
set ignorecase          " Case insensitive search for all lowercase unless \C provided
set noequalalways       " Dont' resize windows when they're opened/closed
set smartcase           "  "

" Space as leader
let mapleader=' '

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

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Use <Tab> as trigger keys for completion
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

tnoremap <c-x> <c-\><c-n>

" -------------------- Status line --------------------

set laststatus=2
set statusline=\ %{getcwd()}\ %#CursorColumn#\ %f\ %=\ %#StatusLine#%{FugitiveStatusline()}%#CursorColumn#\ %l:%c\ %y\ 

" -------------------- Colors --------------------

set termguicolors

if has("win32")
  colorscheme xcodelighthc
else
  colorscheme corvine
  hi Normal guibg=NONE
endif

highlight Tabs guibg=#222222
match Tabs "\t"

hi NvimTreeFolderName guifg=#7399D8
hi NvimTreeOpenedFolderName guifg=#7399D8
hi NvimTreeEmptyFolderName guifg=#7399D8

" -------------------- Leader key and plugin-related shortcuts --------------------

let g:gitgutter_map_keys = 0

function! BuildAndRunProject(...)
    echo 
    vsplit
    exe "normal \<c-w>l"
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

nnoremap gt :bnext<cr>
nnoremap gT :bprev<cr>

nnoremap <c-p> :FZF<CR>
nnoremap <leader><cr> <cmd>nohlsearch<cr>
nnoremap <leader><leader> <c-^>

nnoremap <leader>q <cmd>cclose<cr><cmd>TroubleClose<cr>
nnoremap <leader>w <cmd>wa<cr><cmd>call DeleteHiddenBuffers()<cr>
nnoremap <leader>e <cmd>Trouble lsp_workspace_diagnostics<cr>
nnoremap <leader>E <cmd>Trouble lsp_document_diagnostics<cr>
nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>t <cmd>NvimTreeToggle<cr>
nnoremap <leader>T <cmd>NvimTreeRefresh<CR>
nnoremap <leader>y :let @+ = expand("%:p")<cr>
vnoremap         Y :GetCurrentBranchLink<cr>
nnoremap <leader>u :GitGutterUndoHunk<cr>
nnoremap <leader>i <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>I <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <leader>o <cmd>copen 30<cr>
nnoremap <leader>p viw"_dP

nnoremap <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap        gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>f <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>F <cmd>call SearchQuickfixWithFzf()<cr>
nnoremap <leader>gw :GitGutterAll<cr>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gB :Git branch<cr>
nnoremap <leader>gg :botright vertical Git<cr>
nnoremap <leader>gd :botright vertical Git diff<cr>
nnoremap <leader>gf :split<cr>:e term://git fetch --all<cr>i
nnoremap <leader>gu :split<cr>:e term://git pull --rebase<cr>i
nnoremap <leader>gU :split<cr>:e term://git pull<cr>i
nnoremap <leader>gp :split<cr>:e term://git push<cr>i
nnoremap <leader>gl :botright vertical Git log --all --graph --decorate --oneline<cr>
nnoremap <leader>gL :botright vertical Git log --all --graph --decorate --oneline --first-parent<cr>
nnoremap <leader>gb :Git blame<cr>
nnoremap <leader>j <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>k <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

nnoremap <leader>x <cmd>bd<CR>
nnoremap <leader>v <cmd>e $MYVIMRC<cr>
nnoremap <leader>n <cmd>enew<cr>

nnoremap <f5> :Run npm start
nnoremap <f6> :Run node rundev.js

"nnoremap <leader>? <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <leader>? <cmd>lua vim.lsp.buf.signature_help()<CR>
"nnoremap <leader>? <cmd>lua vim.lsp.buf.formatting()<CR>
"nnoremap <leader>? <cmd>lua vim.lsp.buf.type_definition()<CR>

imap <silent> <c-space> <Plug>(completion_trigger)

" -------------------- LSP + plugin configuration --------------------

let g:buftabline_indicators = 1

" *** FZF Config ***

if has("win32")
  let $FZF_DEFAULT_COMMAND = 'git ls-files'
else
  let $FZF_DEFAULT_COMMAND = 'lsfiles'
endif

" CTRL-A CTRL-Q to select all and build quickfix list
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_action = {
  \ 'ctrl-k': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let $FZF_DEFAULT_OPTS = '--bind ctrl-j:select-all'

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

" *** nvimtree config ***

let g:nvim_tree_ignore = [ '.git', 'node_modules', 'target', '*.meta' ]
let g:nvim_tree_gitignore = 1
let g:nvim_tree_auto_close = 1
let g:nvim_tree_follow = 1
let g:nvim_tree_indent_markers = 1
let g:nvim_tree_disable_netrw = 0
let g:nvim_tree_hijack_netrw = 0 
let g:nvim_tree_highlight_opened_files = 1
let g:nvim_tree_lsp_diagnostics = 1
let g:nvim_tree_tab_open = 1

" *** misc ***

" Auto-format *.rs (rust) files prior to saving them
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

" Avoid showing extra messages when using completion
set shortmess+=c

" Configure LSP
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Enable c#
local pid = vim.fn.getpid()
local omnisharp_bin = "/home/jaburns/source/omnisharp-bin/run"
if vim.fn.has('win32') == 1 then
    omnisharp_bin = "c:/omnisharp/omnisharp-vim/omnisharp-roslyn/OmniSharp.exe"
end
nvim_lsp.omnisharp.setup{
    on_attach=on_attach,
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) };
}

-- Enable tsserver
nvim_lsp.tsserver.setup({
    on_attach=on_attach,
})

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            diagnostics = {
                disabled = { "missing-unsafe", "incorrect-ident-case", "macro-error", "unresolved-proc-macro" }
            },
            cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true
            },
            procMacro = {
                enable = true
            },
            checkOnSave = {
                command = "clippy"
            }
        }
    }
})

-- Enable diagnostics
-- :help vim.lsp.diagnostic.on_publish_diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = false,
    }
)

-- Configure diagnostics window
require("trouble").setup {
    height = 30,
    auto_preview = false,
    action_keys = { -- key mappings for actions in the trouble list
--     close = "q", -- close the list
--     cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
--     refresh = "r", -- manually refresh
--     jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
--     open_split = { "<c-x>" }, -- open buffer in new split
--     open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
--     open_tab = { "<c-t>" }, -- open buffer in new tab
--     jump_close = {"o"}, -- jump to the diagnostic and close the list
       toggle_mode = "e", -- toggle between "workspace" and "document" diagnostics mode
--     toggle_preview = "P", -- toggle auto_preview
       hover = "i", -- opens a small poup with the full multiline message
--     preview = "p", -- preview the diagnostic location
       close_folds = "a", -- close all folds
       open_folds = "A", -- open all folds
       toggle_fold = "f" -- toggle fold of current file
--     previous = "k", -- preview item
--     next = "j" -- next item
    },
}

EOF
