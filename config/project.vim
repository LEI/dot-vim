" Projectionist

Pack 'tpope/vim-projectionist'

function! s:get(key, default) abort
  for [root, value] in projectionist#query(a:key)
    " echom 'root: ' . root . ' value: ' . value
    return value
  endfor
  return a:default
endfunction

function! s:activate() abort
  " let l:alternate = s:get('alternate', [])
  let l:filetype = s:get('filetype', &filetype)
  let l:runner = s:get('runner', 'jasmine')
  let l:test = s:get('test', '')

  if l:filetype ==# 'typescript'
    let l:filetype = 'javascript'
  endif
  if l:filetype !=# '' && l:runner !=# '' " && l:test !=# ''
    let l:var = 'test#' . l:filetype . '#' . l:runner . '#executable'
    if l:test ==# ''
      let l:test = get(g:, l:var, '')
    endif
    if l:test !=# ''
      exec 'let g:' . l:var . ' = l:test'
    endif
    " echom l:alternate
    " echom 'filetype: ' . l:filetype
    " echom 'runner: ' . l:runner
    " echom 'test: ' . l:test
  endif
endfunction

augroup Project
  autocmd!
  " autocmd User ProjectionistDetect
  "       \ if SomeCondition(get(g:, 'projectionist_file')) |
  "       \   call projectionist#append(root, projections) |
  "       \ endif
  autocmd User ProjectionistActivate
        \ nnoremap <Leader>a :A<CR> |
        \ call s:activate()
augroup END
