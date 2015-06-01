
let g:OmniSharp_typeLookupInPreview = 1

setlocal omnifunc=OmniSharp#Complete
set noshowmatch
set splitbelow
set completeopt=longest,menuone,preview

let g:syntastic_cs_checkers = ['syntax', 'semantic', 'issues']

nnoremap gd :OmniSharpGotoDefinition<cr>
nnoremap <leader>hh :OmniSharpHighlightTypes<cr>
nnoremap <leader>tl :OmniSharpTypeLookup<cr>
nnoremap <leader>ca :OmniSharpGetCodeActions<cr>
nnoremap <leader>fs :OmniSharpFindSymbol<cr>
nnoremap <leader>fu :OmniSharpFindUsages<cr>
nnoremap <leader>xu :OmniSharpFixUsings<cr>
nnoremap <leader>xi :OmniSharpFixUsings<cr>
nnoremap <leader>rs :OmniSharpReloadSolution<cr>
command! -nargs=1 RR :call OmniSharp#RenameTo("<args>")

