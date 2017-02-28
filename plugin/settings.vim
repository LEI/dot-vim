" Load settings for installed plugins

finish

" TODELETE

" https://github.com/skwp/dotfiles/blob/master/vim/settings.vim

if get(g:, 'loaded_plugins', 0)
  finish
endif
let g:loaded_plugins = 1

let s:settings_path = '~/.vim/settings'
let s:plugins_path = '~/.vim/plugged'

" Each file name in s:settings_path must be an exact substring of the
" plugin directory under s:plugins_path to be sourced

for s:path in split(globpath(s:settings_path, '*.vim'), '\n')
  let s:name = fnamemodify(s:path, ':t:r')
  if !empty(globpath(s:plugins_path, '*' . s:name . '*'))
    execute 'source ' . s:path
  endif
endfor
