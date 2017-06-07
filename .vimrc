" ------------- System options -------------
" Main
runtime! archlinux.vim
set nocompatible

" Powerline
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set laststatus=2

" Vundle
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'vimwiki/vimwiki'
Plugin 'scrooloose/nerdcommenter'
Plugin 'airblade/vim-gitgutter'
Plugin 'sjl/badwolf'
call vundle#end()
filetype plugin indent on

" ------------- User options -------------
" Main
set mouse=a
set display+=lastline
set cursorline
set cursorcolumn
set number
set tabstop=3
set ignorecase!
set hlsearch
set is
"set nostartofline
"set virtualedit=all
"set undofile " Maintain undo history between sessions

" Encodings
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,cp866,koi8-r,koi8-u,latin1

" Visual
syntax enable
colorscheme badwolf
set list!
set listchars=tab:¦\ ,eol:¬,trail:·

" Airline config
let g:airline_powerline_fonts = 1
let g:airline_theme='term'
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

