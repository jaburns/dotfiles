
let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

setlocal omnifunc=OmniSharp#Complete
set noshowmatch
set splitbelow
set completeopt=longest,menuone,preview

nnoremap gd :OmniSharpGotoDefinition<cr>
nnoremap <leader>vs :e ~/.vim/bundle/snips-jaburns/UltiSnips/cs.snippets<cr>
nnoremap <leader>i :OmniSharpTypeLookup<cr>
nnoremap <leader>a :OmniSharpGetCodeActions<cr>
nnoremap <leader>s :OmniSharpFindSymbol<cr>
nnoremap <leader>f :OmniSharpFindUsages<cr>:copen 30<cr>
nnoremap <leader>x :cclose<cr>:pclose<cr>
nnoremap <leader>u :OmniSharpFixUsings<cr>
nnoremap <leader>r :OmniSharpReloadSolution<cr>
command! -nargs=1 RR :call OmniSharp#RenameTo("<args>")

augroup vimrc_cs
    autocmd!
    autocmd BufWritePost *.cs :OmniSharpHighlightTypes
augroup END


