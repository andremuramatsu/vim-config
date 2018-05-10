" Pathogen loader
execute pathogen#infect()

" Color syntax
syntax on

" Display line numbers
set number

" Highlight search result
set hlsearch

" Automate code ident
set cindent

" Four chars for ident
set shiftwidth=4

" Four chars for ident using gt char
set tabstop=4

" Replaces tabs for spaces
set expandtab

" Color schema
set t_Co=256
colorscheme default
set background=dark

" Guide coluns at 120th column
set textwidth=120
set colorcolumn=120

" Guide coluns at 80th and 120th column
"set textwidth=80
"set colorcolumn=80,120
hi ColorColumn ctermbg=8 ctermfg=15

" Remove background color to work transparent terminals
hi Normal ctermbg=none

" Display file name at the footbar
set laststatus=2

" Display hidden characters
set showbreak=@
set listchars=tab:>\ ,eol:$,nbsp:.
set list

" Specific configuration for some syntax
filetype plugin indent on
autocmd Filetype php set fileencoding=iso-8859-1
autocmd Filetype javascript set fileencoding=iso-8859-1
autocmd Filetype phtml set fileencoding=iso-8859-1
autocmd Filetype html set fileencoding=iso-8859-1

" Snipmate doesn't works if set paste is enabled
set nopaste

" Plugins keyboard shortcuts
map <F9> :TagbarToggle<CR>
vmap <C-i> :Tabularize /=.<CR>
map <C-UP> :bn!<CR>
map <C-DOWN> :bp!<CR>

function! MurasSwitchEditorMode()
	let muramode = &number
	if muramode == "0"
		set number
		set list
	else
		set nonumber
		set nolist
	endif
endfunction
map <F12> :call MurasSwitchEditorMode()<CR>
