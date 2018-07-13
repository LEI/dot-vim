" Fugitive

if !executable('git')
  finish
endif

" gregsexton/gitv, mhinz/vim-signify
Pack 'tpope/vim-fugitive' " Git wrapper
Pack 'tpope/vim-git' " Latest git runtime files
" Pack 'shumphrey/fugitive-gitlab.vim' " Add Gitlab support

" if !exists('g:loaded_fugitive')
"   finish
" endif

augroup Fugitive
  autocmd!
  " Auto-clean git objects buffers
  autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END
