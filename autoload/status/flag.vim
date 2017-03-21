" Buffer flags
function! status#flag#line() abort
  if &filetype =~# 'netrw\|taglist\|qf\|vim-plug'
    return ''
  endif
  if &filetype ==# '' && &buftype ==# 'nofile'
    return '' " NetrwMessage
  endif
  if &buftype ==# 'help'
    return 'H'
  endif
  let l:flags = []
  if &previewwindow
    call add(l:flags, 'PRV')
  endif
  if &readonly
    call add(l:flags, 'RO')
  endif
  if &modified
    call add(l:flags, '+')
  elseif !&modifiable
    call add(l:flags, '-')
  endif
  return join(l:flags, ',')
endfunction
