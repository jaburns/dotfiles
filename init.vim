" -------------------------------------------------
" Additional setup instructions for nvim:
"
" - Install vim-plug: https://github.com/junegunn/vim-plug
" - For Rust, build and install rust-analyzer to PATH: https://rust-analyzer.github.io/manual.html#rust-analyzer-language-server-binary
" - For TS/JS: npm install -g typescript typescript-language-server
" - For C#: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#omnisharp
"   (Download omnisharp binaries to $HOME/source/omnisharp-bin, so that $HOME/source/omnisharp-bin/run exists)
" -------------------- Plugins --------------------

call plug#begin('~/.config/nvim/plugged')

" Collection of common configurations for the Nvim LSP client
Plug 'neovim/nvim-lspconfig'

" Extensions to built-in LSP, for example, providing type inlay hints
" Plug 'nvim-lua/lsp_extensions.nvim'

" Autocompletion framework for built-in LSP
Plug 'nvim-lua/completion-nvim'

" File explorer
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'

" Fuzzy find
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" ag search
Plug 'numkil/ag.nvim'

" Auto-determine indentation rules
Plug 'tpope/vim-sleuth'

" GLSL syntax highlighting
Plug 'tikhomirov/vim-glsl'

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

set laststatus=2
set statusline=
set statusline+=\ %{getcwd()}\ 
set statusline+=
set statusline+=%#CursorColumn#
set statusline+=\ %f\ 
set statusline+=%=
set statusline+=\ %l:%c\ %y\ 

let mapleader=' '

" Use system clipboard as default
set clipboard^=unnamed,unnamedplus

" Toggles vim's paste mode; when we want to paste something into vim from a
" different application, turning on paste mode prevents extra whitespace.
set pastetoggle=<F7>

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

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" ----------------------------------------------------
" Write files when focus is lost and save/close all 
" hidden buffers with shortcut
set autowrite

function! DeleteHiddenBuffers()
    let tpbl=[]
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout' buf
    endfor
endfunction

nnoremap <leader>w :wa<cr>:call DeleteHiddenBuffers()<cr>

" -------------------- Colors --------------------

colorscheme simple-dark
hi Normal ctermbg=NONE
hi Pmenu ctermbg=black ctermfg=white

highlight Tabs ctermbg=235 guibg=#000000
match Tabs "\t"

" -------------------- Leader key shortcuts --------------------

nnoremap <leader><cr> :nohlsearch<cr>
nnoremap <leader><leader> <c-^>
nnoremap <leader>v :e $MYVIMRC<cr>
nnoremap <leader>q :copen 30<cr>
nnoremap <leader>Q :cclose<cr>

let $FZF_DEFAULT_COMMAND = 'ag -g ""'
nnoremap <c-p> :FZF<CR>
nnoremap <leader>` :NvimTreeOpen<cr>

nnoremap <leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <leader>e <cmd>lua vim.jaburns.update_diagnostics_qflist()<CR>:copen<CR>
nnoremap <leader>i <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <leader>I <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>s <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <leader>f <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <leader>F <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>t <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>x <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <leader>n <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>p <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>

imap <silent> <c-space> <Plug>(completion_trigger)

" -------------------- LSP configuration --------------------
"
" Auto-format *.rs (rust) files prior to saving them
autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

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
                disabled = { "missing-unsafe" }
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

-- Hack to print all diagnostics to the quickfix list, bind to vim.jaburns.update_diagnostics_qflist()
-- https://github.com/neovim/nvim-lspconfig/issues/69
do
    local method = "textDocument/publishDiagnostics"
    local default_handler = vim.lsp.handlers[method]
    local qflist = {}
    vim.lsp.handlers[method] = function(err, method, result, client_id, bufnr, config)
        default_handler(err, method, result, client_id, bufnr, config)
        local diagnostics = vim.lsp.diagnostic.get_all()
        qflist = {}
        for bufnr, diagnostic in pairs(diagnostics) do
            for _, d in ipairs(diagnostic) do
                d.bufnr = bufnr
                d.lnum = d.range.start.line + 1
                d.col = d.range.start.character + 1
                d.text = d.message
                table.insert(qflist, d)
            end
        end
    end
    vim.jaburns = {
        update_diagnostics_qflist = function()
            vim.lsp.util.set_qflist(qflist)
        end
    }
end

EOF
