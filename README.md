# dot-vim

## Requirements

- curl
- [git](https://git-scm.com)
- [vim](https://github.com/vim/vim) or [neovim](https://neovim.io) `+lua`

## Manual installation

Clone and change directory

    git clone https://github.com/LEI/dot-vim.git ~/.dot/vim && cd $_

Create the directory `~/.vim`

    mkdir -p "$HOME/.vim"

Link files to home directory

    ln -isv "~/.dot/vim/{*.vim,autoload,config,ftdetect,ftplugin,plugin}" "$HOME/.vim"

Source `~/.vim/init.vim` from `~/.vimrc`

    echo 'source ~/.vim/init.vim' >> "$HOME/.vimrc"

Gvim

    echo 'source ~/.vim/ginit.vim' >> "$HOME/.gvimrc"

## Resources

- [SpaceVim](https://github.com/SpaceVim/SpaceVim)
- [spf13-vim](https://github.com/spf13/spf13-vim)
- [vim-galore](https://github.com/mhinz/vim-galore)
- [vim-sensible](https://github.com/tpope/vim-sensible)
- [christoomey](https://github.com/christoomey/dotfiles) dotfiles
- [gfontenot](https://github.com/gfontenot/dotfiles/tree/master/tag-vim) dotfiles
- [thoughtbot](https://github.com/thoughtbot/dotfiles) dotfiles
- [paulirish](https://github.com/paulirish/dotfiles/blob/master/.vimrc) dotfiles

## Usage

### Plugins

#### [minpac](https://github.com/k-takata/minpac) (Vim 8)

    :call minpac#update()

#### [vim-plug](https://github.com/junegunn/vim-plug) `v:version < 800`

Install plugins

    :PlugInstall

Update plugins

    :PlugUpdate

Upgrade vim-plug itself

    :PlugUpgrade

### Mappings

#### Fix `Ctrl-h` in Terminal.app

Default `key_backspace` (kbs) entry on OS X is `^H` (ASCII DELETE).

Set it to `\177` (ASCII BACKSPACE) with these commands:

    infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
    tic $TERM.ti
