" Dracula theme
call dein#add('dracula/vim')
colorscheme dracula

" Linting
call dein#add('w0rp/ale')

" Vim + Git
call dein#add('tpope/vim-fugitive', {'on_cmd': 'Gstatus', 'augroup': 'fugitive', 'on_source': 'gitv'})
call dein#add('junegunn/gv.vim')
call dein#add('airblade/vim-gitgutter')

" Fuzzy
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
nnoremap <leader>, :FZF<CR>

" Status bars
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')

" Show indentation
call dein#add('yggdroot/indentline')

" Commenter
call dein#add('scrooloose/nerdcommenter')

" NeoMake
call dein#add('neomake/neomake')

" YouCompleteMe
call dein#add('Valloric/YouCompleteMe', {'build': './install.py', 'merged': 0})

" Search in project files
call dein#add('eugen0329/vim-esearch')

" Session management
call dein#add('tpope/vim-obsession')

" Ruby
call dein#add('vim-ruby/vim-ruby')
