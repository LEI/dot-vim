" YouCompleteMe

" has('python') || has('python3')

" The variable a:info is a dictionary with 3 fields:
" - name: name of the plugin
" - status: 'installed', 'updated', or 'unchanged'
" - force: set on PlugInstall! or PlugUpdate!
function! YCMInstall(info)
  if a:info.status ==# 'installed' || a:info.force
    " The following additional language support options are available
    " - C# support: add --omnisharp-completer to ./install.py
    " - Go support: ensure go is installed and add --gocode-completer
    " - TypeScript support: install nodejs and npm then install the TypeScript SDK with npm install -g typescript.
    " - JavaScript support: install nodejs and npm and add --tern-completer when calling ./install.py
    " - Rust support: install rustc and cargo and add --racer-completer when calling ./install.py
    !./install.py --tern-completer --gocode-completer
  endif
endfunction

" !exists('g:loaded_youcompleteme') :call plug#load('YouCompleteMe') :call youcompleteme#Enable()

function! YCMEnable() abort
  if has('vim_starting')
    echom 'Vim is still starting, skipping YCM'
    return
  endif
  if !exists('g:loaded_youcompleteme')
    call plug#load('YouCompleteMe')
  else
    echom 'YCM is already loaded'
  endif
  if exists('g:loaded_youcompleteme')
    call youcompleteme#Enable()
  else
    echom 'YCM was not loaded'
  endif
endfunction

Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}

function! s:loaded() abort
  augroup YCM
    autocmd!
    " Defer loading until vim is ready and idle
    " autocmd User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
    " autocmd CursorHold, CursorHoldI * :packadd YouCompleteMe | autocmd! YCM
    " autocmd CursorHold,CursorHoldI * call YCMEnable() | autocmd! YCM
    autocmd CursorHold,CursorHoldI * call plug#load('YouCompleteMe') | call youcompleteme#Enable() | autocmd! YCM
  augroup END
endfunction

call package#Add({'name': 'youcompleteme', 'on': {'plug_end': function('s:loaded')}})
