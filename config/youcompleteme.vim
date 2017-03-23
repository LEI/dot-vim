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

" !exists('g:loaded_youcompleteme') | call plug#load('YouCompleteMe') | call youcompleteme#Enable()
function! YCMEnable() abort
  if exists('g:loaded_youcompleteme')
    echom 'Already loaded YouCompleteMe'
    return 1
  endif
  if has('vim_starting')
    echoerr 'Vim is still starting, not loading YouCompleteMe'
    return 0
  endif
  echo 'Loading YCM...'
  call plug#load('YouCompleteMe')
  echo ''
  if !exists('g:loaded_youcompleteme')
    echoerr 'Could not load YouCompleteMe'
    return 0
  endif
  call youcompleteme#Enable()
  return 1
endfunction

command! -nargs=0 -bar YCMEnable :call YCMEnable()

noremap <unique> <silent> <C-Space> :call YCMEnable()<CR>
" :iunmap <C-Space><CR>
inoremap <expr> <unique> <silent> <C-Space> (YCMEnable() ? "" : "\<C-Space>")

function! s:enable() abort
  let l:loaded = YCMEnable()
  if l:loaded == 1 && &completefunc ==# 'youcompleteme#Complete'
    " doautocmd TextChangedI
    " startinsert / stopinsert
    " return "\<Esc>\"2dla\<C-R>2"
    " return "\<Esc>a\<C-X>\<C-U>\<C-P>"
    call feedkeys( "\<C-X>\<C-U>\<C-P>", 'n' )
  endif
  return "\<C-Space>"
endfunction

augroup YCM
  autocmd!
  " autocmd User YouCompleteMe echom 'User YCM'
  " autocmd User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
  " autocmd CursorHold,CursorHoldI * :call YCMEnable() | :autocmd! YCM
  " autocmd User Config :redraw | :call YCMEnable() | :autocmd! YCM
  " autocmd CompleteDone * pclose
augroup END
