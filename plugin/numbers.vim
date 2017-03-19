" Number column

" v:version > 703 || v:version == 703 && has('patch1115')
" myusuf3/numbers.vim

set number " Print the line number in front of each line
" set numberwidth=4 " Minimal number of columns to use for the line number

if exists('+relativenumber')
  set relativenumber " Show the line number relative to the line with the cursor
endif

function! s:disable_local() abort
  setlocal nonumber
  if exists('+relativenumber')
    setlocal norelativenumber
  endif
endfunction

augroup NumberColumn
  autocmd!
  autocmd FileType gundo,minibufexpl,nerdtree,startify,tagbar,taglist,unite,vimshell,w3m call s:disable_local()
augroup END
