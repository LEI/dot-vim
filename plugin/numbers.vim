" Number column

" v:version > 703 || v:version == 703 && has('patch1115')
" myusuf3/numbers.vim

" gundo,minibufexpl,nerdtree,startify,tagbar,taglist,unite,vimshell,w3m
let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree']

function! s:disable_numbers() abort
  setlocal nonumber
  if exists('+relativenumber')
    setlocal norelativenumber
  endif
endfunction

augroup NumbersExclude
  autocmd!
  autocmd CmdWinEnter * call s:disable_numbers()
        \ | setlocal signcolumn=no
  autocmd FileType * if index(g:numbers_exclude, &filetype) != -1
        \ | call s:disable_numbers()
        \ | endif
augroup END
