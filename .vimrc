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

" polygot isn't that great for latex
let g:polyglot_disabled = ['latex']
" Let vimtex know we are LaTeX only
let g:tex_flavor = 'latex'

" coc.nvim settings start
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

" Use <c-space> to trigger completion.
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
nmap <silent> gd :vsplit<CR><Plug>(coc-definition)
nmap <silent> gy :vsplit<CR><Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" gh == get hint
nmap <silent> gh :call CocAction('doHover')<CR>

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" coc.nvim settings end

" Make it so neovim is able to find python
let g:python3_host_prog = 'C:\Python38\python.exe'

" editorconfig-vim settings
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
let g:EditorConfig_max_line_indicator = "line"
