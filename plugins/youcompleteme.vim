" YouCompleteMe

if !has('python') || !has('python3')
  finish
endif

" Automatically hide preview window
" let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

function! YCMInstall(info)
  " The variable a:info is a dictionary with 3 fields:
  " - name: name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force: set on PlugInstall! or PlugUpdate!
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

Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}

augroup YCM
  autocmd!
  " autocmd User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
  " autocmd CompleteDone * pclose
  " autocmd CursorHold, CursorHoldI * :packadd YouCompleteMe | autocmd! YCM
  autocmd CursorHold,CursorHoldI * :call YCMEnable() | :autocmd! YCM
augroup END

" !exists('g:loaded_youcompleteme') | call plug#load('YouCompleteMe') | call youcompleteme#Enable()
function! YCMEnable() abort
  if exists('g:loaded_youcompleteme')
    echoerr 'YCM is already loaded'
    return 1
  endif
  if has('vim_starting')
    echoerr 'YCM not loaded, vim is still starting'
    return 0
  endif
  call plug#load('YouCompleteMe')
  if !exists('g:loaded_youcompleteme')
    echoerr 'YCM was not loaded'
    return 0
  endif
  call youcompleteme#Enable()
  return 1
endfunction
