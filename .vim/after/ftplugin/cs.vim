
let g:OmniSharp_typeLookupInPreview = 1

setlocal omnifunc=OmniSharp#Complete
set noshowmatch
set splitbelow
set completeopt=longest,menuone,preview

let g:syntastic_cs_checkers = ['syntax', 'issues']

nnoremap gd :OmniSharpGotoDefinition<cr>
nnoremap <leader>hh :OmniSharpHighlightTypes<cr>
nnoremap <leader>tt :OmniSharpTypeLookup<cr>
nnoremap <leader>ii :OmniSharpGetCodeActions<cr>
nnoremap <leader>fs :OmniSharpFindSymbol<cr>
nnoremap <leader>fu :OmniSharpFindUsages<cr>
nnoremap <leader>uu :OmniSharpFixUsings<cr>
nnoremap <leader>rr :OmniSharpReloadSolution<cr>
command! -nargs=1 RR :call OmniSharp#RenameTo("<args>")

