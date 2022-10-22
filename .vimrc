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
autocmd Filetype markdown setlocal spell
set makeprg=ninja

" extra highlighting
autocmd BufRead *.{c,h} set filetype=c.doxygen
autocmd BufRead *.{cpp,hpp} set filetype=cpp.doxygen

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

" Set the font to something nice
" set guifont=Cascadia\ Code\ PL:h14

" coc.nvim settings start
" all plugins to install
let g:coc_global_plugins = [
      \ "coc-json",
      \ "coc-rust-analyzer"
      \ ]
" statusline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Don't pass messages to |ins-completion-menu|
set shortmess+=c

" Always show signcolumn
set signcolumn=number

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd :vsplit<CR><Plug>(coc-definition)
nmap <silent> gy :vsplit<CR><Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" gh == get hint
nmap <silent> gh :call CocAction('doHover')<CR>

" Add `:Format` command to format current buffer.
" Formats the entire buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
" folds a certain block of code awaw from view
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

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
" coc.nvim settings end

" Make it so neovim is able to find python
let g:python3_host_prog = 'C:\Python310\python.exe'

" editorconfig-vim settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_max_line_indicator = "line"

" vimtex settings
let g:vimtex_compiler_method = 'latexmk'
let g:vimtex_view_general_viewer = 'C:\Users\Me\AppData\Local\SumatraPDF\SumatraPDF.exe'
let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
" let g:vimtex_view_general_options_latexmk = '-reuse-instance'

" tex keybindings (up arrow goes into wrap)
autocmd Filetype tex noremap  <silent> <Up>   gk
autocmd Filetype tex noremap  <silent> <Down> gj
autocmd Filetype tex inoremap <silent> <Up>   <C-o>gk
autocmd Filetype tex inoremap <silent> <Down> <C-o>gj
autocmd Filetype tex call vimtex#init()

" automatically format on save
autocmd BufWritePost *.{c,h}{,pp} Format
autocmd BufWritePost *.rs Format

let g:coc_global_extensions = [
      \ "coc-rust-analyzer"
      \ ]
