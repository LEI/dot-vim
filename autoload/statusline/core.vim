" Status line functions

" Get the current mode and update SatusLine highlight group
function! statusline#core#mode(...) abort
  if statusline#Hide('mode') || &filetype =~# g:statusline_ignore_filetypes
    return ''
  endif
  let l:mode =  a:0 ? a:1 :mode()
  if g:statusline.winnr != winnr() " && get(b:, 'mode_show', 0) != 1
    let l:mode = 'nc'
  endif
  " if l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  " elseif l:mode ==# 'i'
  "   highlight! link StatusLine StatusLineInsert
  " elseif l:mode ==# 'R'
  "   highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  " endif
  return get(g:statusline.modes, l:mode, l:mode)
endfunction

function! statusline#core#highlight(...) abort
  let l:im = a:0 ? a:1 : ''
  " let l:im = a:0 ? a:1 : v:insertmode
  if l:im ==# 'i' " Insert mode
    highlight! link StatusLine StatusLineInsert
  elseif l:im ==# 'r' " Replace mode
    highlight! link StatusLine StatusLineReplace
  elseif l:im ==# 'v' " Virtual replace mode
    highlight! link StatusLine StatusLineReplace
  elseif strlen(l:im) > 0
    echoerr 'Unknown mode: ' . l:im
  else
    highlight link StatusLine NONE
  endif
endfunction

" Buffer flags
function! statusline#core#flags() abort
  if statusline#Hide('flags')
    return ''
  endif
  " echom 'FT ->' &filetype
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

" File or buffer type
function! statusline#core#type() abort
    if &filetype ==# ''
      if &buftype !=# 'nofile'
        return &buftype
      endif
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
function! statusline#core#format() abort
  if statusline#Hide('fileformat')
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
