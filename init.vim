" Call dein#update() everytime plugins got updated.

set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim

if filereadable("/etc/vim/vimrc")
  source /etc/vim/vimrc
elseif filereadable(expand("~/vimrc"))
  source ~/vimrc
elseif filereadable(expand("~/.vimrc"))
  source ~/.vimrc
else
  echoerr "Could not find vimrc."
endif

if &compatible
  set nocompatible
endif

" Add the dein installation directory into runtimepath
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Caching
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')

  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  call dein#end()
  call dein#save_state()
endif

" Installing
if dein#check_install()
  call dein#install()
endif


syntax on
filetype plugin indent on


source ~/.config/nvim/plugins.vim
source ~/.config/nvim/setup.vim
