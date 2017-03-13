" Tabluar

" if exists('g:loaded_tabular')
"   finish
" endif

Plug 'godlygeek/tabular' " Text aligning

" -> ~/.vim/after/plugin/tabular_extra.vim

" AddTabularPipeline multiple_spaces / \{2,}/
"   \ map(a:lines, "substitute(v:val, ' \{2,}', '  ', 'g')")
"   \   | tabular#TabularizeStrings(a:lines, '  ', 'l0')
