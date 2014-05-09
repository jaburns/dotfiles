
" --------- OmniSharp settings -------------------------------------------------

" This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

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

