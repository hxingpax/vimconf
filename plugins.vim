" Dracula theme
call dein#add('dracula/vim')
let g:dracula_colorterm = 0
colorscheme dracula

" Logging highlight
call dein#add('MTDL9/vim-log-highlighting')

" Linting
call dein#add('w0rp/ale')


" Vim + Git
call dein#add('tpope/vim-fugitive', {'on_cmd': 'Gstatus', 'augroup': 'fugitive', 'on_source': 'gitv'})
call dein#add('junegunn/gv.vim')
call dein#add('airblade/vim-gitgutter')


" Fuzzy
call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 1 }) 
call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })


" Status bars
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes')
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
" nmap <leader>t :enew<CR>


" Show indentation
call dein#add('yggdroot/indentline')


" Commenter
call dein#add('scrooloose/nerdcommenter')


" NeoMake
call dein#add('neomake/neomake')


" YouCompleteMe
call dein#add('ycm-core/YouCompleteMe', {'build': './install.py --clangd-completer', 'merged': 1})
"call dein#add('hxingpax/YouCompleteMe', {'build': './install.py --clangd-completer', 'merged': 1})
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_min_num_identifier_candidate_chars = 0
let g:ycm_max_num_candidates = 50
let g:ycm_max_num_candidates_to_detail = 0
let g:ycm_max_num_identifier_candidates = 10
let g:ycm_auto_trigger = 1


" Deoplete
" Disabled as we prefer YouCompleteMe
"call dein#add('Shougo/deoplete.nvim')
"if !has('nvim')
"  call dein#add('roxma/nvim-yarp')
"  call dein#add('roxma/vim-hug-neovim-rpc')
"endif
"call deoplete#enable()



" Search in project files
call dein#add('eugen0329/vim-esearch')


" Session management
call dein#add('tpope/vim-obsession')


" Ruby
call dein#add('vim-ruby/vim-ruby')


" Dir difference
call dein#add('will133/vim-dirdiff')


" Enhance Markdown
call dein#add('iamcco/markdown-preview.nvim', {'on_ft': ['markdown', 'pandoc.markdown', 'rmd'],
					\ 'build': 'sh -c "cd app & yarn install"' })
" set to 1, nvim will open the preview window after entering the markdown buffer
" default: 0
let g:mkdp_auto_start = 0
" set to 1, the nvim will auto close current preview window when change
" from markdown buffer to another buffer
" default: 1
let g:mkdp_auto_close = 1
" set to 1, the vim will refresh markdown when save the buffer or
" leave from insert mode, default 0 is auto refresh markdown as you edit or
" move the cursor
" default: 0
let g:mkdp_refresh_slow = 0
" set to 1, the MarkdownPreview command can be use for all files,
" by default it can be use in markdown file
" default: 0
let g:mkdp_command_for_global = 0
" set to 1, preview server available to others in your network
" by default, the server listens on localhost (127.0.0.1)
" default: 0
let g:mkdp_open_to_the_world = 0
" use custom IP to open preview page
" useful when you work in remote vim and preview on local browser
" more detail see: https://github.com/iamcco/markdown-preview.nvim/pull/9
" default empty
let g:mkdp_open_ip = ''
" specify browser to open preview page
" default: ''
let g:mkdp_browser = ''
" set to 1, echo preview page url in command line when open preview page
" default is 0
let g:mkdp_echo_preview_url = 0
" a custom vim function name to open preview page
" this function will receive url as param
" default is empty
let g:mkdp_browserfunc = ''
" options for markdown render
" mkit: markdown-it options for render
" katex: katex options for math
" uml: markdown-it-plantuml options
" maid: mermaid options
" disable_sync_scroll: if disable sync scroll, default 0
" sync_scroll_type: 'middle', 'top' or 'relative', default value is 'middle'
"   middle: mean the cursor position alway show at the middle of the preview page
"   top: mean the vim top viewport alway show at the top of the preview page
"   relative: mean the cursor position alway show at the relative positon of the preview page
" hide_yaml_meta: if hide yaml metadata, default is 1
" sequence_diagrams: js-sequence-diagrams options
" content_editable: if enable content editable for preview page, default: v:false
let g:mkdp_preview_options = {
    \ 'mkit': {},
    \ 'katex': {},
    \ 'uml': {},
    \ 'maid': {},
    \ 'disable_sync_scroll': 0,
    \ 'sync_scroll_type': 'middle',
    \ 'hide_yaml_meta': 1,
    \ 'sequence_diagrams': {},
    \ 'flowchart_diagrams': {},
    \ 'content_editable': v:false
    \ }
" use a custom markdown style must be absolute path
" like '/Users/username/markdown.css' or expand('~/markdown.css')
let g:mkdp_markdown_css = ''
" use a custom highlight style must absolute path
" like '/Users/username/highlight.css' or expand('~/highlight.css')
let g:mkdp_highlight_css = ''
" use a custom port to start server or random for empty
let g:mkdp_port = ''
" preview page title
" ${name} will be replace with the file name
let g:mkdp_page_title = '?${name}?'

