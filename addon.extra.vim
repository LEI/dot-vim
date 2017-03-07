" Extra plugins
" let g:vim_completion = 1
" let g:vim_syntax_check = 1

finish
" Auto Completion:
if get(g:, 'vim_completion', 0) > 0
  let s:has_completion = 0
  if has('nvim') && has('python3') " pip3 install --upgrade neovim
    let s:has_completion = 1
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    let g:deoplete#enable_at_startup = 1
  elseif has('lua')
    let s:has_completion = 1
    Plug 'Shougo/neocomplete.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    let g:neocomplete#enable_at_startup = 1
    " augroup NeoCompleteEnable
    "   autocmd!
    "   autocmd VimEnter * call NeoCompleteEnable()
    " augroup END
  endif
  if s:has_completion == 1 && v:version >= 704
      Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
  endif

  " Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}
  " if s:has_completion && (has('python') || has('python3'))
  "   Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
  " endif

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
endif
