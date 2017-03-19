" Views

" nerdtree, unite, tags... (g:ale_filetype_blacklist)
let s:ignore_ft = get(g:, 'view_filetype_blacklist', ['help', 'netrw', 'qf'])

" Return true if the current buffer state should be saved or restored
function! s:is_file() abort
  " vim-vinegar opendir() error on Enter (-) if &modifiable is off
  if &buftype !=# '' || &filetype ==# ''
    return 0
  endif
  for l:ft in s:ignore_ft
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
