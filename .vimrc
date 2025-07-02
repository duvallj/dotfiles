" become ~*~modern~*~
set nocompatible
set encoding=utf-8
set exrc
set secure

" file highlighting
syntax enable
" file-specific indenting
filetype plugin indent on

set smarttab

" On Windows, use Unix line endings
set fileformats=unix,dos
set fileformat=unix

augroup vimrc
  autocmd!

  " extra filetype detection
  autocmd BufNewFile,BufRead *.asm set filetype=nasm
  autocmd BufNewFile,BufRead *.{mjs,cjs} set filetype=javascript
  autocmd BufNewFile,BufRead *.{mts,cts} set filetype=typescript
  autocmd BufNewFile,BufRead *.{gohtml,html.jinja} set filetype=html

  " default tab settings (needs to be autocmd b/c these are buffer-local)
  autocmd FileType *           setlocal tabstop=8 softtabstop=2   expandtab shiftwidth=2 autoindent copyindent
  " language-specific settings
  autocmd Filetype make        setlocal tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
  autocmd Filetype python      setlocal tabstop=4 softtabstop=4   expandtab shiftwidth=4
  autocmd Filetype go          setlocal tabstop=8 softtabstop=0 noexpandtab shiftwidth=8
  autocmd Filetype markdown    setlocal spell textwidth=79
  autocmd Filetype tex         setlocal spell

  " tex keybindings (up arrow goes into wrap)
  autocmd Filetype tex noremap  <silent> <Up>   gk
  autocmd Filetype tex noremap  <silent> <Down> gj
  autocmd Filetype tex inoremap <silent> <Up>   <C-o>gk
  autocmd Filetype tex inoremap <silent> <Down> <C-o>gj
augroup END

" Commands to specifically use tabs/spaces for a given file
command! -nargs=0 Tabs   :setlocal tabstop=8 softtabstop=0 noexpandtab shiftwidth=8
command! -nargs=0 Spaces :setlocal tabstop=8 softtabstop=2   expandtab shiftwidth=2

" see tabs
set list
set listchars=tab:▶·

" natural backspace, linewrap settings
set backspace=indent,eol,start
set whichwrap=<,>,[,]

" column to not go over
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" searching
set wildmenu
set hlsearch
set incsearch
set showmatch
set smartcase

" left side
set number
set ruler
set hidden

" allows using <Esc> when in terminal windows
tnoremap <Esc> <C-\><C-n>

" allows use of mouse
set mouse=a

" makes it so colors show up correctly in tmux
set background=dark
" make it so colors show up correctly in cmd.exe
set termguicolors

" Set the color scheme
if !exists('g:colors_name')
  " base16-solarflare is my current favorite, though I'm trying out others
  let my_colorschemes = [
        \ 'base16-da-one-gray',
        \ 'base16-helios',
        \ 'base16-precious-dark-eleven',
        \ 'base16-solarflare',
        \ 'base24-espresso',
  \ ]
  " let light_colorschemes = [
  "     \ 'base16-da-one-white',
  "     \ 'base16-precious-light-white',
  " \ ]
  execute 'colorscheme' my_colorschemes[rand() % len(my_colorschemes)]
endif

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Allow copy with Ctrl+Shift+C
vnoremap <C-S-c> "+y
" Allow copy with Super+C
vnoremap <D-c> "+y
" Default OS paste support (at least for Kitty) includes Ctrl+Shift+V and
" Super+V. Configure these in the terminal, and they _should_ "just work" here.

" Pasting in WSL is a bit trickier, however:
if $DOTFILES_WSL != ""
  " First, we have to set up the correct keyboard handlers
  let g:clipboard = {
  \   'name': 'WslClipboard',
  \   'copy': {
  \      '+': 'clip.exe',
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \   },
  \   'cache_enabled': 0,
  \ }

  " Then, because the above shortcuts are incompatible, we need to use others:
  " Allow copy with Alt+Shift+C
  vnoremap <M-C> "+y
  " Allow paste with Alt+Shift+V
  noremap <M-V> <cmd>norm "+p<cr>
  inoremap <M-V> <cmd>norm "+p<cr>
endif

" Open file from OS clipboard. Only works in normal mode due to restrictions
" of <cmd>
nnoremap <leader>po :tabedit <C-r>+<cr>
" Open file from default clipboard
nnoremap <leader>pp :tabedit <C-r>"<cr>

" ocamlformat
set rtp^="$HOME/.opam/default/share/ocp-indent/vim"
