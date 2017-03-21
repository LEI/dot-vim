" Whitespace warnings

" Indentation warning
function! status#warn#indent() abort
  if !&modifiable || &paste " Ignore &et warnings in paste mode
    return ''
  endif
  if !exists('b:statusline_indent')
    let b:statusline_indent = s:MixedIndent()
  endif
  return b:statusline_indent
endfunction

function! s:MixedIndent()
  " Find spaces that arent used as alignment in the first indent column
  let l:s = search('^ \{' . &tabstop . ',}[^\t]', 'nw')
  let l:t = search('^\t', 'nw')
  let l:et = (&expandtab ? '\s' : '\t') " &et / &noet
  if l:s != 0 && l:t != 0
    return 'mixed-' . l:et . printf('[%s]', &expandtab ? l:t : l:s)
  elseif l:s != 0 && !&expandtab
    return l:et . printf('[%s]', l:s)
  elseif l:t != 0 && &expandtab
    return l:et . printf('[%s]', l:t)
  endif
  return ''
endfunction

" Trailing whitespaces
function! status#warn#trailing() abort
  if !&modifiable
    return ''
  endif
  if !exists('b:statusline_trailing')
    let l:s = search('\s\+$', 'nw')
    let b:statusline_trailing =  l:s != 0 ? 'trailing' . printf('[%s]', l:s) : ''
  endif
  return b:statusline_trailing
endfunction
