" File

" File or buffer type
function! status#file#type() abort
  if status#Hide('fileinfo')
    return ''
  endif
  if &filetype ==# 'netrw' && get(b:, 'netrw_browser_active', 0) == 1
    let l:netrw_direction = (g:netrw_sort_direction =~# 'n' ? '+' : '-')
    return &filetype . '[' . g:netrw_sort_by . l:netrw_direction . ']'
  endif
  " if &filetype ==# 'qf'
  "   return &buftype " quickfix
  " endif
  return &filetype
endfunction

" File encoding and format
function! status#file#format() abort
  if status#Hide('fileformat')
    return ''
  endif
  if strlen(&fileencoding) > 0
    let l:enc = &fileencoding
  else
    let l:enc = &encoding
  endif
  if exists('+bomb') && &bomb
    let l:enc.= '-bom'
  endif
  if l:enc ==# 'utf-8'
    let l:enc = ''
  endif
  if &fileformat !=# 'unix'
    let l:enc.= '[' . &fileformat . ']'
  endif
  return l:enc
endfunction
