" Diff

set diffopt+=vertical " Always use vertical diffs

" See the difference between the current buffer and the file it was loaded from
if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
        \ | wincmd p | diffthis
endif
