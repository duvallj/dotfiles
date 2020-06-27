set nocompatible
set t_Co=256
set encoding=utf-8
set exrc
set secure

" enable spellcheck
set spelllang=en

" file highlighting
syntax enable
" file-specific indenting
filetype plugin indent on
" autocmd Filetype make set tabstop=4 shiftwidth=4 softtabstop=0 smarttab expandtab
autocmd Filetype make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
autocmd Filetype tex setlocal spell
set makeprg=make

" more tab settings, use 2 spaces by default (C style)
" other languages taken care of by Vim's default
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab

" natural backspace, linewrap settings
set backspace=indent,eol,start
set whichwrap=<,>,[,]

" column to not go over
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" lots of cool stuff to enable
set wildmenu
" set nowrap
set autoindent
set copyindent
set hlsearch
set incsearch
set showmatch
set smartcase
set number
set relativenumber
set ruler
set hidden

" allows using <Esc> when in terminal windows
tnoremap <Esc> <C-\><C-n>
" allows interactivity with the system clipboard
set clipboard=unnamedplus,unnamed
" allows use of mouse
"set mouse=a

" makes it so colors shop up correctly in tmux
set background=dark

" make vimtex work correctly
let g:polyglot_disabled = ['latex']
packadd! vimtex
call vimtex#pack_install()
" use correct latex flavor
let g:tex_flavor = "latex"
" use non-firefox pdf viewer
let g:vimtex_view_general_viewer = 'evince'
