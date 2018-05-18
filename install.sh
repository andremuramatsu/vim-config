#!/bin/bash

DEPENDENCIES="git ctags pear"

function echo_warn {
    echo -e "\033[033m${1}\033[m"
}

function echo_success {
    echo -e "\033[032m${1}\033[m"
}

function echo_info {
    echo -e "\033[038m${1}\033[m"
}

function echo_error {
    echo -e "\033[031m${1}\033[m"
}

function gitclone {
    URL=$1
    PKG=$2
    TGT=$3

    if [ -z "${TGT}" ]; then
        TGT="/home/${USER}/.vim/bundle/${PKG}"
    fi

    echo_info "Testing vim package ${PKG} ${TGT}"

    if [ ! -d "${TGT}" ]; then
        git clone $URL $TGT 2>&1 > /dev/null
        if [ $? -gt 0 ]; then
            echo_error "Failure installing ${PKG}"
            return 1
        else
            echo_success "Package ${PKG} installed";
            return 0
        fi
    else
        echo_warn "Package ${PKG} already exists"
        return 1
    fi

}

# Testing SO dependencies
for DEP in $DEPENDENCIES; do
    echo_info "Testing ${DEP}"
    if [ -z "$(which ${DEP})" ] || [ ! -x "$(which ${DEP})" ]; then
        echo_error "You must install ${DEP} before"
        exit 1
    fi
done
echo_success "SO dependencies ok"

# PHPMD and PHPCS
if [ $(pear list -c pear.php.net |grep PHP_CodeSniffer|wc -l) != "1" ]; then
    CMD="sudo pear install PHP_CodeSniffer"
    
    ${CMD}
    if [ $? -gt 0 ]; then
        echo_error "You must install PHP_CodeSniffer as root before continue"
        echo_warn "$CMD"
        exit 1
    fi
fi

if [ $(pear list -c pear.phpmd.org|grep PHP_PMD|wc -l) != "1" ]; then
    CMD="sudo pear channel-discover pear.pdepend.org"
    CMD="${CMD} && sudo pear channel-discover pear.phpmd.org"
    CMD="${CMD} && sudo pear channel-update pear.pdepend.org"
    CMD="${CMD} && sudo pear channel-update pear.phpmd.org"
    CMD="${CMD} && sudo pear install phpmd/PHP_PMD" 

    ${CMD}
    if [ ! $? -eq 0 ]; then
        echo_error "You must install PHP_CodeSniffer as root before continue"
        echo_warn "$CMD"
        exit 1
    fi

fi

echo_success "All dependenciess resolved"
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/bundle

# Installing Pathogen
echo_info "Testing vim package pathogen"
if [ ! -f ~/.vim/autoload/pathogen.vim ]; then 
    rm -Rf /tmp/vim-pathogen 2> /dev/null
    git clone https://github.com/tpope/vim-pathogen/ /tmp/vim-pathogen 2>&1 > /dev/null
    if [ $? -gt 0 ]; then
        echo_error "Failure installing pathogen"
        exit 1
    fi

    cp /tmp/vim-pathogen/autoload/pathogen.vim ~/.vim/autoload
    rm -Rf /tmp/vim-pathogen 2> /dev/null
    echo_success "Package pathogen installed"
else
    echo_warn "Package already exists"
fi

# Installing bundle packages
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
