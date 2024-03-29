" Lua alernatives:
" monaqa/dial.nvim
" rmagatti/alternate-toggler

Pack 'tpope/vim-speeddating'

" https://github.com/tpope/vim-speeddating/issues/4

" In Vim, -4 % 3 == -1.  Let's return 2 instead.
function! s:mod(a,b)
  if (a:a < 0 && a:b > 0 || a:a > 0 && a:b < 0) && a:a % a:b != 0
    return (a:a % a:b) + a:b
  else
    return a:a % a:b
  endif
endfunction

let s:cycles = [
      \ ['true', 'false'],
      \ ['TRUE', 'FALSE'],
      \ ['True', 'False'],
      \ ['on', 'off'],
      \ ['ON', 'OFF'],
      \ ['On', 'Off'],
      \ ['yes', 'no'],
      \ ['YES', 'NO'],
      \ ['Yes', 'No']]

function! KeywordIncrement(word, offset, increment)
  for set in s:cycles
    let index = index(set, a:word)
    if index >= 0
      let index = s:mod(index + a:increment, len(set))
      return [set[index], -1]
    endif
  endfor
endfunction

let s:handler = {'regexp': '\<\%('.join(map(copy(s:cycles),'join(v:val,"\\|")'),'\|').'\)\>', 'increment': function('KeywordIncrement')}
" let g:speeddating_handlers += [s:handler]

augroup AlternateToggler
  autocmd!
  autocmd FileType * if get(g:, 'loaded_speeddating') | let g:speeddating_handlers += [s:handler] | end
augroup END

" augroup dateformats
"   autocmd!
"   autocmd VimEnter * silent execute 'SpeedDatingFormat %d/%m/%y'
" augroup END
