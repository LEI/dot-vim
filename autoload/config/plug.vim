" Config manager: vim-plug

let g:plug_home = get(g:, 'plug_home', g:pack_path . '/opt')
let g:plug_path = get(g:, 'plug_path', g:plug_home . '/vim-plug/autoload/plug.vim')
let g:plug_url = get(g:, 'plug_url', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')

function! config#plug#init() abort
  if empty(glob(g:plug_path))
    execute 'silent !curl -sfLo ' . g:plug_path . ' --create-dirs ' . g:plug_url
    let s:do_install = 1
  endif
  execute source g:plug_path
  call plug#begin() " Start Vim Plug
  call config#LoadDir() " Source plugins configuration ($VIMHOME . '/config')
  call plug#end() " Add plugins to &runtimepath
endfunction

function! config#plug#add(repo, ...) abort
  " Plug l:repo l:opts
  call plug#(a:repo, a:0 ? a:1 : {}) " base_spec
endfunction

function! config#plug#define_commands() abort
  command! -nargs=0 -bar Install PlugInstall
  command! -nargs=0 -bar -bang Install PlugInstall<bang>
  command! -nargs=0 -bar Update PlugUpdate
  command! -nargs=0 -bar -bang Update PlugUpdate<bang>
  command! -nargs=0 -bar Upgrade PlugUpgrade | PlugUpdate!
  command! -nargs=0 -bar InstallSync PlugInstall --sync
endfunction
