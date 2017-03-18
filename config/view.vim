" Views

" Options:
" cursor: cursor position in file and in window
" folds: manually created folds, opened/closed folds and local fold options
" options: options and mappings local to a window or buffer (not global values for local options)
" localoptions: same as 'options'
" slash,unix: useful on Windows when sharing view files

" set viewdir=$HOME/.vim/view " Customize location of saved views
set viewoptions-=options " folds,options,cursor

" Return true if the current buffer state should be saved or restored
function! s:is_file() abort
  let l:ignore = get(g:, 'ignored_filetypes', ['help', 'netrw', 'qf'])
  " vim-vinegar opendir() error on Enter (-) if &modifiable is off
  if &buftype !=# '' || &filetype ==# ''
    return 0
  endif
  for l:ft in l:ignore
    if l:ft ==# &filetype
      return 0
    endif
  endfor
  " if &filetype =~# &filetype !=# ''
  "   return 0
  " endif
  return 1
endfunction

augroup ViewGroup
  autocmd!
  autocmd VimEnter,BufWinEnter * if s:is_file() | silent! loadview | endif
  autocmd BufWinLeave * if s:is_file() | mkview | endif
augroup END
