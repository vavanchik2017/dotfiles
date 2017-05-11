" All system-wide defaults are set in $VIMRUNTIME/archlinux.vim (usually just
" /usr/share/vim/vimfiles/archlinux.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vimrc), since archlinux.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing archlinux.vim since it alters the value of the
" 'compatible' option.

set nocompatible  

" Vundle start
filetype off " Vundle

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle bundles
Plugin 'VundleVim/Vundle.vim'
"
Plugin 'tpope/vim-fugitive'
Plugin 'vimwiki/vimwiki'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'airblade/vim-gitgutter'
Plugin 'scrooloose/nerdcommenter'

call vundle#end()
filetype plugin indent on " Vundle
" Vundle end

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages.
runtime! archlinux.vim

" If you prefer the old-style vim functionalty, add 'runtime! vimrc_example.vim'
" Or better yet, read /usr/share/vim/vim74/vimrc_example.vim or the vim manual
" and configure vim to your own liking!

" User options
syntax enable
colorscheme happy_hacking

set nocp
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp1251,cp866,koi8-r,koi8-u,latin1
set ic
set is
set hls
set undofile " Maintain undo history between sessions
set number
set mouse=a
let $PYTHONPATH='/usr/lib/python3.5/site-packages'
set laststatus=2
map <F4> [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

" Airline
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'


" Move selected block in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

