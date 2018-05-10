#!/bin/bash

DEPENDENCIES="git ctags pear"

for DEP in $DEPENDENCIES; do
    echo "Testing ${DEP}"
    if [ -z "$(which ${DEP})" ] || [ ! -x "$(which ${DEP})" ]; then
        echo "You must install ${DEP} before"
        exit 1
    fi
done

# PHPMD and PHPCS
pear channel-discover pear.pdepend.org
pear channel-discover pear.phpmd.org

if [ $(pear list|grep PHP_CodeSniffer|wc -l) != "1" ]; then
    pear install PHP_CodeSniffer
fi

if [ $(pear list -c pear.phpmd.org|grep PHP_PMD|wc -l) != "1" ]; then
    pear install phpmd/PHP_PMD 
fi

echo "All dependenciess resolved"

# Removing old vim config
rm -Rf ~/.vim
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle

# Installing Pathogen
rm -Rf /tmp/vim-pathogen 2> /dev/null
git clone https://github.com/tpope/vim-pathogen/ /tmp/vim-pathogen
cp /tmp/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload
rm -Rf /tmp/vim-pathogen 2> /dev/null

# Installing bundle packages
function gitclone {
    URL=$1
    PKG=$2

    echo "Testing vim package ${PKG}"

    if [ ! -d ~/.vim/bundle/$PKG ]; then
        git clone $URL ~/.vim/bundle/$PKG 2>/dev/null 1>/dev/null
        if [ $? -gt 0 ]; then
            echo "Failure installing ${PKG}"
            return 1
        else
            echo "Package ${PKG} installed";
            return 0
        fi
    else
        echo "Package ${PKG} already exists"
        return 1
    fi

}
gitclone 'https://github.com/majutsushi/tagbar.git' tagbar
gitclone 'https://github.com/godlygeek/tabular.git' tabular
gitclone 'https://github.com/tomtom/tlib_vim.git' tlib_vim
gitclone 'https://github.com/MarcWeber/vim-addon-mw-utils.git' vim-addon-mw-utils
gitclone 'https://github.com/garbas/vim-snipmate.git' vim-snipmate
gitclone 'https://github.com/honza/vim-snippets.git' vim-snippets
gitclone 'https://github.com/terryma/vim-multiple-cursors.git' vim-multiple-cursors
gitclone 'https://github.com/bpearson/vim-phpcs.git' vim-phpcs
gitclone 'https://github.com/vim-syntastic/syntastic.git' vim-syntastic

# Copying rc file
cp vimrc ~/.vimrc
cp screenrc ~/.screenrc
cp screenlayout ~/.screenlayout
cp screenlayoutrestore ~/.screenlayoutrestore

# Copying personal snippets
mkdir -p ~/.vim/bundle/vim-snippets/snippets/php/
cp mura.snippets ~/.vim/bundle/vim-snippets/snippets/php/
