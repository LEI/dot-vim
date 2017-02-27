" Commands

" Quick spell lang switch
" command! En set spelllang=en
" command! Fr set spelllang=fr

" Enable soft wrap (break lines without breaking words)
" command! -nargs=* Wrap setlocal wrap linebreak nolist

" command! SudoWrite :execute ':silent w !sudo tee % > /dev/null' | :edit!
