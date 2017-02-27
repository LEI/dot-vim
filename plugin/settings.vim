" Load plugin settings

" https://github.com/skwp/dotfiles/blob/master/vim/settings.vim

if get(g:, 'loaded_plugins', 0)
  finish
endif
let g:loaded_plugins = 1

let s:settings_path = '~/.vim/settings'
let s:plugins_path = '~/.vim/plugged'

" Load settings for installed plugins only
for s:path in split(globpath(s:settings_path, '*.vim'), '\n')
  let s:name = fnamemodify(s:path, ':t:r')
  let s:check = !empty(globpath(s:plugins_path, '*' . s:name . '*'))
  if s:check
    execute 'source ' . s:path
  endif
endfor
