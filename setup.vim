" Dracula theme
colorscheme dracula

" Fuzzy
nnoremap <leader>f :FZF<CR>

" Rg
nnoremap <leader>, :Rg <C-R><C-W><CR>

" Status bars
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
" nmap <leader>t :enew<CR>

