" All system-wide defaults are set in $VIMRUNTIME/debian.vim and sourced by
" the call to :runtime you can find below.  If you wish to change any of those
" settings, you should do it in this file (/etc/vim/vimrc), since debian.vim
" will be overwritten everytime an upgrade of the vim packages is performed.
" It is recommended to make changes after sourcing debian.vim since it alters
" the value of the 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
if has("syntax")
  syntax on
endif

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Uncomment the following to have Vim load indentation rules and plugins
" according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		" Hide buffers when they are abandoned
set mouse=a		" Enable mouse usage (all modes)
set encoding=utf-8
set fileencoding=utf-8
set tabstop=2
set shiftwidth=2
set expandtab
"set lines=40
"set columns=90
set dir=/home/vim
set backupdir=/home/vim/bkup
set packpath+=/home/vim
set runtimepath+=/home/vim,/home/vim/after

" 'unnamedplus' for linux, non-plus for macox
"set clipboard=unnamedplus
set clipboard=unnamed

set guioptions-=T
set hlsearch
set cursorline
set cursorcolumn
set termguicolors
set lazyredraw
set fileformat=unix
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list

" turn absolute line numbers on
set number relativenumber

let mapleader=","

syntax on

filetype plugin indent on

colorscheme evening

if &compatible
  set nocompatible
endif

" Enable transparency
" hi Normal guibg=NONE ctermbg=NONE

" NTree
let g:netrw_liststyle = 3
map <leader>1 :Vexplore<CR>
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

" For fast search
map <leader>. :g/\<<C-R><C-W>\><CR>

" Maps
" map <F4> :Tlist<cr>
" map <F8> :!ctags -R --language-force=c<cr>
nnoremap <F5> :%!xxd<cr>

" View mode in terminal
" tnoremap <C-`> <C-\><C-N>

" Source a global configuration file if available
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
