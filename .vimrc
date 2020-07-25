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
" more tab settings, use 2 spaces by default (C style)
" other languages taken care of by Vim's default
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab

" language-specific tab settings
autocmd Filetype make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype tex setlocal spell
set makeprg=make


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
set mouse=a

" makes it so colors show up correctly in tmux
set background=dark
" make it so colors show up correctly in cmd.exe
set termguicolors

" Set the color scheme
if !exists('g:colors_name') || g:colors_name != 'base16-solarflare'
  colorscheme base16-solarflare
endif

" polygot isn't that great for latex
let g:polyglot_disabled = ['latex']

" set synastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
