" VCS

" Display the branch of the cwd if applicable
function! status#branch#name() abort
  " &bt !~ 'nofile\|quickfix'
  if !exists('*fugitive#head') || &buftype ==# 'quickfix'
    return ''
  endif
  if exists('b:branch_hidden') && b:branch_hidden == 1
    return ''
  endif
  return fugitive#head(7)
endfunction
