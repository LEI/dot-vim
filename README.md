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

## Usage

### [Vim Plug](https://github.com/junegunn/vim-plug)

Install plugins

    :PlugInstall

Update plugins

    :PlugUpdate

Upgrade vim-plug itself

    :PlugUpgrade
