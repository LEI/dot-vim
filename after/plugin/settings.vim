" Load plugin settings

" Each file name in g:vim_settings_path must be an exact substring of the
" plugin directory under g:vim_plugins_path to be sourced
" for s:path in split(globpath(g:vim_settings_path, '*.vim'), '\n')
"   let s:name = fnamemodify(s:path, ':t:r')
"   if !empty(globpath(g:vim_plugins_path, '*' . s:name . '*'))
"     execute 'source ' . s:path
"   endif
" endfor
