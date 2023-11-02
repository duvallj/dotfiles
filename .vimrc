" become ~*~modern~*~
set nocompatible
set t_Co=256
set encoding=utf-8
set exrc
set secure

" file highlighting
syntax enable
" file-specific indenting
filetype plugin indent on
" enable spellcheck
set spelllang=en

" tab settings, use 2 spaces by default (C style)
" this is for new files, most are autodetected
set tabstop=2
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab

" language-specific settings
autocmd Filetype make setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4
autocmd Filetype markdown setlocal spell textwidth=79

autocmd Filetype tex setlocal spell
" tex keybindings (up arrow goes into wrap)
autocmd Filetype tex noremap  <silent> <Up>   gk
autocmd Filetype tex noremap  <silent> <Down> gj
autocmd Filetype tex inoremap <silent> <Up>   <C-o>gk
autocmd Filetype tex inoremap <silent> <Down> <C-o>gj

" extra highlighting
autocmd BufRead *.{c,h} set filetype=c.doxygen
autocmd BufRead *.{cpp,hpp} set filetype=cpp.doxygen
autocmd BufRead *.asm set filetype=nasm

" natural backspace, linewrap settings
set backspace=indent,eol,start
set whichwrap=<,>,[,]

" column to not go over
set colorcolumn=80
highlight ColorColumn ctermbg=darkgray

" lots of cool stuff to enable
set wildmenu
set autoindent
set copyindent
set hlsearch
set incsearch
set showmatch
set smartcase
set number
set signcolumn=number
set relativenumber
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
if !exists('g:colors_name') || g:colors_name != 'base16-solarflare'
  colorscheme base16-solarflare
endif

" Set the font to something nice
set guifont=Cascadia\ Code\ PL:h12

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" coc.nvim settings start
" all plugins to install
let g:coc_global_plugins = [
  \ "coc-json",
  \ "coc-rust-analyzer",
  \ "coc-clangd",
  \ "coc-tsserver"
  \ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gm <Plug>(coc-implementation)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" gh == get hint
nmap <silent> gh :call CocAction('doHover')<CR>

" Add `:Format` command to format current buffer.
" Formats the entire buffer.
command! -nargs=0 Format :call CocAction('format')

command! -nargs=0 Prettier :w | !npx prettier -w %:p

" Add `:Fold` command to fold current buffer.
" folds a certain block of code awaw from view
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

" Add `:Diag` command to get current list of diagnostics
command! -nargs=0 Diag :CocList diagnostics

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <S-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<S-Down>"
  nnoremap <silent><nowait><expr> <S-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<S-Up>"
  inoremap <silent><nowait><expr> <S-Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<S-Down>"
  inoremap <silent><nowait><expr> <S-Up> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<S-Up>"
  vnoremap <silent><nowait><expr> <S-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<S-Down>"
  vnoremap <silent><nowait><expr> <S-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<S-Up>"
endif

" Don't start coc.nvim on startup
let g:coc_start_at_startup = 0

" Use a function to toggle Coc's enabled status
" See https://stackoverflow.com/q/64507845
let s:coc_enabled = 0
function! ToggleCoc()
   if s:coc_enabled == 0
      let s:coc_enabled = 1
      CocStart
      echo 'COC on'
   else
      let s:coc_enabled = 0
      echo 'COC off'
      call coc#rpc#stop()
   endif
endfunction
nnoremap <silent> <leader>c :call ToggleCoc()<cr>
" coc.nvim settings end

" ocamlformat
set rtp^="$HOME/.opam/default/share/ocp-indent/vim"

" telescope.nvim settings start
nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>fF <cmd>Telescope git_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" telescope.nvim settings end
