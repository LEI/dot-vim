" Extra plugins

" Auto Completion:
if get(g:, 'vim_auto_complete', 0)
  let g:snippet_engine = 'Shougo/neosnippet' " SirVer/ultisnips
  let g:snippet_files = 'Shougo/neosnippet-snippets' " honza/vim-snippets
  if has('nvim') && has('python3') " pip3 install --upgrade neovim
    " Deoplete:
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
    Plug g:snippet_engine | Plug g:snippet_files
    let g:deoplete#enable_at_startup = 1
  elseif has('lua')
    " NeoComplete:
    Plug 'Shougo/neocomplete.vim' | Plug 'Shougo/vimproc.vim', {'do' : 'make'}
    Plug g:snippet_engine | Plug g:snippet_files
    let g:neocomplete#enable_at_startup = 1
    " augroup NeoCompleteEnable
    "   autocmd!
    "   autocmd VimEnter * call NeoCompleteEnable()
    " augroup END
  endif

  let s:snippets_dir = get(g:, 'snippets_dir', $PLUGINS . '/vim-snippets/snippets')
  if g:snippet_files == 'honza/vim-snippets' && isdirectory(s:snippets_dir)
    let g:neosnippet#enable_snipmane_compatibility = 1
    let g:neosnippet#snippets_directory = s:snippets_dir
  endif

  " YouCompleteMe:
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

" Syntax Checkers: scrooloose/syntastic, maralla/validator.vim, w0rp/ale
if get(g:, 'vim_syntax_check', 0)
  " Neomake:
  if has('nvim') || v:version > 704 || v:version == 704 && has('patch503')
    Plug 'neomake/neomake', {'on': 'Neomake'}
  endif
endif
