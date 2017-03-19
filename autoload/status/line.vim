" Functions

" Get the current mode and update SatusLine highlight group
function! status#line#Mode(...) abort
  let l:mode =  a:0 ? a:1 :mode()
  " if l:mode ==# 'n'
  "   highlight! link StatusLine StatusLineNormal
  " elseif l:mode ==# 'i'
  "   highlight! link StatusLine StatusLineInsert
  " elseif l:mode ==# 'R'
  "   highlight! link StatusLine StatusLineReplace
  " elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# '^V'
  "   highlight! link StatusLine StatusLineVisual
  " endif
  if g:statusline.winnr != winnr()
    let l:mode = 'nc'
  endif
  return get(g:statusline.modes, l:mode, l:mode)
endfunction

" Display the branch of the cwd if applicable
function! status#line#Branch() abort
  " &bt !~ 'nofile\|quickfix'
  if !exists('*fugitive#head') || &buftype ==# 'quickfix'
    return ''
  endif
  if exists('b:branch_hidden') && b:branch_hidden == 1
    return ''
  endif
  return fugitive#head(7)
endfunction

" Buffer flags
function! status#line#Flags() abort
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

" File or buffer type
function! status#line#FileType() abort
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
function! status#line#FileInfo() abort
  if &filetype ==# '' && &buftype !=# '' && &buftype !=# 'nofile'
    return ''
  endif
  if &filetype =~# 'netrw' || &buftype =~# 'help\|quickfix'
    return ''
  endif
  if strlen(&fileencoding) > 0
    let l:enc = &fileencoding
  else
    let l:enc = &encoding
  endif
  if exists('+bomb') && &bomb
    let l:enc.= ',B'
  endif
  if l:enc ==# 'utf-8'
    let l:enc = ''
  endif
  if &fileformat !=# 'unix'
    let l:enc.= '[' . &fileformat . ']'
  endif
  return l:enc
endfunction

" Whitespace warnings
" aserebryakov/filestyle
function! status#line#Indent() abort
  let l:symbol_mixed = 'mixed '
  let l:symbol_space = '\s' " spaces
  let l:symbol_tab = '\t' " tabs
  " let l:sep = ':'
  if !&modifiable || &paste " Ignore warnings in paste mode
    return ''
  endif
  if !exists('b:statusline_indent')
    let b:statusline_indent = ''
    " Find spaces that arent used as alignment in the first indent column
    let l:spaces = search('^ \{' . &tabstop . ',}[^\t]', 'nw')
    let l:tabs = search('^\t', 'nw')
    if l:tabs != 0 && l:spaces != 0
      " Spaces and tabs are used to indent
      let b:statusline_indent = l:symbol_mixed
      if !&expandtab
        let b:statusline_indent.= l:symbol_space " . l:sep . l:spaces
      else
        let b:statusline_indent.= l:symbol_tab " . l:sep . l:tabs
      endif
    elseif l:spaces != 0 && !&expandtab
      let b:statusline_indent = l:symbol_space " . l:sep . l:spaces
    elseif l:tabs != 0 && &expandtab
      let b:statusline_indent = l:symbol_tab " . l:sep . l:tabs
    endif
  endif
  return b:statusline_indent
endfunction

function! status#line#Trailing() abort
  let l:search = 'trailing' " \s\+$
  if !exists('b:statusline_trailing')
    let l:msg = ''
    let l:match = search('\s\+$', 'nw')
    if l:match != 0
      let l:msg = l:search . ' ' . l:match " '\s$'
    endif
    let b:statusline_trailing = l:msg
  endif
  return b:statusline_trailing
endfunction

" Quickfix or location list title
function! status#line#QuickFixTitle() abort
  return get(w:, 'quickfix_title', '')
endfunction
