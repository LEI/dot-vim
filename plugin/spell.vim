" Spell checking

if !has('spell')
  finish
endif

if &spelllang ==# 'en' " !~# 'fr'
  set spelllang+=fr
endif

" command! SpellEn setlocal spelllang=en
" command! SpellFr setlocal spelllang=fr

" Use 'Spell <lang>' to enable spell checking in the current buffer
command! -nargs=1 -complete=custom,ListLangs Spell setlocal spell spelllang=<args>
function! ListLangs(ArgLead, CmdLine, CursorPos) abort
  let l:list = ['en', 'fr']
  return join(l:list, "\n")
endfunction
