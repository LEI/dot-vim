# dot-vim

## Requirements

- curl
- [git](https://git-scm.com)
- [vim](https://github.com/vim/vim) or [neovim](https://neovim.io) `+lua`

## Manual installation

    mkdir -p "$HOME/.vim"
    ln -isv "$DOT/{*.vim,autoload,ftdetect,ftplugin,plugin,plugins}" "$HOME/.vim"
    echo 'source ~/.vim/init.vim' >> "$HOME/.vim/vimrc"

## Resources

- [Vim sensible](https://github.com/tpope/vim-sensible)
- [Vim Galore](https://github.com/mhinz/vim-galore)
- [SpaceVim](https://github.com/SpaceVim/SpaceVim)
- [spf13-vim](https://github.com/spf13/spf13-vim)

## Usage

### [Vim Plug](https://github.com/junegunn/vim-plug)

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
