" Extra plugins
" let g:vim_completion = 1
" let g:vim_syntax_check = 1

" Auto Completion:
if get(g:, 'vim_completion', 0)
  if has('nvim') && has('python3') " pip3 install --upgrade neovim
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    if v:version >= 704
        Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
    endif
  elseif has('lua')
    Plug 'Shougo/neocomplete.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    if v:version >= 704
        Plug 'Shougo/neosnippet' | Plug 'Shougo/neosnippet-snippets'
    endif
    " augroup NeoCompleteEnable
    "   autocmd!
    "   autocmd VimEnter * call NeoCompleteEnable()
    " augroup END
  endif
" if has('python') || has('python3')
    "   Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
    " endif
    " " Enable snipMate compatibility feature
    " let g:neosnippet#enable_snipmate_compatibility = 1
    " " Set snippets drectory path
    " let g:neosnippet#snippets_directory = s:snippets_dir

  " Plug 'Valloric/YouCompleteMe', {'do': function('YCMInstall'), 'on': []}
  " Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

  " The variable a:info is a dictionary with 3 fields:
  " - name: name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force: set on PlugInstall! or PlugUpdate!
  function! YCMInstall(info)
    if a:info.status == 'installed' || a:info.force
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

" Formatting: google/vim-codefmt

" Syntax Checkers:
if get(g:, 'vim_syntax_check', 0)
  " scrooloose/syntastic, maralla/validator.vim, w0rp/ale

  " has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
  Plug 'neomake/neomake', {'on': 'Neomake'}

  " Shell: bashate, shellcheck
  " VimL: vim-vint
  Plug 'syngan/vim-vimlint' | Plug 'ynkdir/vim-vimlparser'
endif
