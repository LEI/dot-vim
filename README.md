# dot-vim

## Requirements

- curl
- [git](https://git-scm.com)
- [vim](https://github.com/vim/vim) or [neovim](https://neovim.io)

## Manual installation

    mkdir -p "$HOME/.vim"
    ln -isv "$DOT/{*.vim,ftdetect,ftplugin,plugin,settings}" "$HOME/.vim"
    echo 'source ~/.vim/init.vim' >> "$HOME/.vim/vimrc"

## Resources

- [Vim sensible](https://github.com/tpope/vim-sensible)
- [Vim Galore](https://github.com/mhinz/vim-galore)
- [SpaceVim](https://github.com/SpaceVim/SpaceVim)
- [spf13-vim](https://github.com/spf13/spf13-vim)

## Usage

### Fix `C-h` (Terminal.app)

Default key_backspace (kbs) entry is ^H (ASCII DELETE): key_backspace=^H,

Set key_backspace to \177 (ASCII BACKSPACE):

    infocmp $TERM | sed 's/kbs=^[hH]/kbs=\\177/' > $TERM.ti
    tic $TERM.ti

### [Vim Plug](https://github.com/junegunn/vim-plug)

Install plugins

    :PlugInstall

Update plugins

    :PlugUpdate

Upgrade vim-plug itself

    :PlugUpgrade
