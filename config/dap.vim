" Debug Adapter Protocol

if !has('nvim')
  " Pack 'puremourning/vimspector' " Multi-language graphical debugger
  finish
endif

" Pack 'jayp0521/mason-nvim-dap.nvim'

" Pack 'mfussenegger/nvim-dap'
" Pack 'rcarriga/nvim-dap-ui'

" function! VSCodeJSDebug()
"   !npm install --legacy-peer-deps && npm run compile
" endfunction
" Pack 'microsoft/vscode-js-debug', {'type': 'opt', 'do': function('VSCodeJSDebug')}
" Pack 'mxsdev/nvim-dap-vscode-js'

" function! VSCodeFirefox()
"   !npm intall
"   !npm run build
" endfunction
" Pack 'firefox-devtools/vscode-firefox-debug', {'type': 'opt', 'do': function('VSCodeFirefox')}

" FIXME ../lua/user/debug.lua
" https://github.com/mfussenegger/nvim-dap/issues/82

" https://alpha2phi.medium.com/neovim-dap-enhanced-ebc730ff498b

" Alternative to CtrlP / FZF
" Pack 'nvim-telescope/telescope.nvim'
" Pack 'nvim-telescope/telescope-dap.nvim'
" lua require('telescope').load_extension('dap')

" https://github.com/nvim-treesitter/nvim-treesitter/issues/3092
" Pack 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Pack 'theHamsta/nvim-dap-virtual-text'

" Pack 'dap-budy/dap-buddy.nvim'
" Pack 'williamboman/mason.nvim' " LSP servers, DAP servers and more

" Pack 'David-Kunz/jester'

" lua require('user.debug')
