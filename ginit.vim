GuiTabline 0
GuiPopupmenu 0
GuiFont! Source Code Pro:h11

let s:fontsize = 11
function! AdjustFontSize(amount)
  let s:fontsize = s:fontsize+a:amount
  :execute "GuiFont! Source Code Pro:h" . s:fontsize
endfunction

nnoremap <c-=> :call AdjustFontSize(1)<CR>
nnoremap <c--> :call AdjustFontSize(-1)<CR>
