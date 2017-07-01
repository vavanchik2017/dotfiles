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

Plugin 'Valloric/YouCompleteMe'

Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'

Plugin 'vimwiki/vimwiki'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'sjl/badwolf'

call vundle#end()
filetype plugin indent on

" ------------- User options -------------
" Encodings
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,cp866,koi8-r,koi8-u,latin1

" Main
syntax enable
set number
set mouse=a
set display+=lastline
set cursorline "Horizontal highlighting
set cursorcolumn "Vertical highlighting
set backspace=indent,eol,start
set ignorecase!
set hlsearch
set is
set list
set listchars=tab:⋮\ ,eol:¬,trail:·

set modeline
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set nostartofline
"set virtualedit=all
"set undofile " Maintain undo history between sessions

" Airline config
let g:airline_powerline_fonts = 1
let g:airline_theme='term'
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'

colorscheme badwolf

