" Call dein#update() everytime plugins got updated.

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

source ~/workspace/vimconf/vimrc
source ~/workspace/vimconf/plugins.vim
source ~/workspace/vimconf/setup.vim
