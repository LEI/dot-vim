" VCS

" Display the branch of the cwd if applicable
function! status#branch#name() abort
  if !exists('*fugitive#head') || status#Hide('branch')
    return ''
  endif
  return fugitive#head(7)
endfunction
