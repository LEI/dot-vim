# dot-vim

## Requirements

- curl
- [git](https://git-scm.com)
- [vim](https://github.com/vim/vim) or [neovim](https://neovim.io) `+lua`

## Manual installation

    mkdir -p "$HOME/.vim"
    ln -isv "$DOT/{*.vim,autoload,config,ftdetect,ftplugin,plugin}" "$HOME/.vim"
    echo 'source ~/.vim/init.vim' >> "$HOME/.vim/vimrc"

## Resources

- [SpaceVim](https://github.com/SpaceVim/SpaceVim)
- [spf13-vim](https://github.com/spf13/spf13-vim)
- [vim-galore](https://github.com/mhinz/vim-galore)
- [vim-sensible](https://github.com/tpope/vim-sensible)

- [christoomey](https://github.com/christoomey/dotfiles)
- [gfontenot](https://github.com/gfontenot/dotfiles/tree/master/tag-vim)
- [thoughtbot](https://github.com/thoughtbot/dotfiles)

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
