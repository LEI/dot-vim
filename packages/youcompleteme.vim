" YouCompleteMe

" has('python') || has('python3')

if !get(g:, 'enable_ycm', 0)
  finish
endif

Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}

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

" autocmd! User YouCompleteMe if !has('vim_starting') | call youcompleteme#Enable() | endif
" !exists('g:loaded_youcompleteme') :call plug#load('YouCompleteMe') :call youcompleteme#Enable()
