" Call dein#update() everytime plugins got updated.


if filereadable("/etc/vim/vimrc")
  source /etc/vim/vimrc
elseif filereadable(expand("~/vimrc"))
  source ~/vimrc
elseif filereadable(expand("~/.vimrc"))
  source ~/.vimrc
else
  echoerr "Could not find vimrc."
endif
