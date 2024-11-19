" Link this file to the default loading path(e.g. ~/.vimrc)

" Call dein#update() everytime plugins got updated.

let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif

" Add the dein installation directory into runtimepath
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif

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

augroup log_syntax
  autocmd!
  autocmd BufRead,BufNewFile *.log set filetype=log
  autocmd FileType log source ~/workspace/vimconf/colors/log.vim
augroup END
