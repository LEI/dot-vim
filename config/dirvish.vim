" Dirvish

Pack 'justinmk/vim-dirvish'

" Sort folders at the top
" let g:dirvish_mode = ':sort r /[^\/]$/'

" Paths relative to the current directory
if !has('conceal') " v:version <= 730
  let g:dirvish_relative_paths = 1
endif

function! s:DirvishFileType() abort
  " if get(g:, 'loaded_ctrlp', 0) == 1
  " endif

  " Allow CtrlP mapping
  silent! unmap <buffer> <C-p>

  " Map t to open in new tab
  nnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>
  xnoremap <silent><buffer> t :call dirvish#open('tabedit', 0)<CR>

  " Map gr to reload the Dirvish buffer (or use R)
  nnoremap <silent><buffer> gr :<C-U>Dirvish %<CR>

  " Map gh to hide dot-prefixed files
  nnoremap <silent><buffer> gh :silent keeppatterns g@\v/\.[^\/]+/?$@d<cr>

  " Enable :Gstatus
  " if exists('g:loaded_fugitive')
  "   call fugitive#detect(@%)
  " endif

  " Trigger hidden buffer auto command manually (close qf/loc list if needed)
  if bufnr('$') > 1 && exists('#BufHidden#*')
    doautocmd BufHidden *
  endif
endfunction

augroup Dirvish
  autocmd!
  " Hide 'No matching autocommands'
  autocmd BufNew * silent echo
  " Override mappings, options and settings
  autocmd FileType dirvish call s:DirvishFileType()
augroup END
