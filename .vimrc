" become ~*~modern~*~
set nocompatible
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
set tabstop=8
set softtabstop=2
set expandtab
set shiftwidth=2
set smarttab

" On Windows, use Unix line endings
set fileformats=unix,dos
set fileformat=unix

" NOTE: smarttab is global, don't set it in these.
command! -nargs=0 Tabs   :setlocal tabstop=8 softtabstop=0 noexpandtab shiftwidth=8
command! -nargs=0 Spaces :setlocal tabstop=8 softtabstop=2   expandtab shiftwidth=2

" language-specific settings
autocmd Filetype make     setlocal tabstop=4 softtabstop=0 noexpandtab shiftwidth=4
autocmd Filetype python   setlocal tabstop=4 softtabstop=4   expandtab shiftwidth=4
autocmd Filetype go       setlocal tabstop=8 softtabstop=0 noexpandtab shiftwidth=8
autocmd Filetype markdown setlocal spell textwidth=79
autocmd Filetype tex      setlocal spell

" tex keybindings (up arrow goes into wrap)
autocmd Filetype tex noremap  <silent> <Up>   gk
autocmd Filetype tex noremap  <silent> <Down> gj
autocmd Filetype tex inoremap <silent> <Up>   <C-o>gk
autocmd Filetype tex inoremap <silent> <Down> <C-o>gj

" extra highlighting
autocmd BufRead,BufWrite *.asm set filetype=nasm
autocmd BufRead,BufWrite *.mts set filetype=typescript
autocmd BufRead,BufWrite *.{c,h} set filetype=c.doxygen
autocmd BufRead,BufWrite *.{cc,cpp,hh,hpp} set filetype=cpp.doxygen
autocmd BufRead,BufWrite *.{gohtml,html.jinja} set filetype=html

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
set ruler
set hidden

" see tabs
set list
set listchars=tab:▶·

" allows using <Esc> when in terminal windows
tnoremap <Esc> <C-\><C-n>

" allows use of mouse
set mouse=a

" Make scrolling not go so far
set scroll=4

" makes it so colors show up correctly in tmux
set background=dark
" make it so colors show up correctly in cmd.exe
set termguicolors

" Set the color scheme
if !exists('g:colors_name')
  colorscheme base16-solarflare
  " colorscheme base16-gruvbox-dark-pale
  " colorscheme base16-helios
  " colorscheme base16-standardized-dark
endif

" Set the font to something nice

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

" coc.nvim settings start

" Only start coc.nvim at startup if an environment variable is set
let g:dotfiles_coc_enabled = $DOTFILES_ENABLE_COC_NVIM == "" ? 0 : 1
if g:dotfiles_coc_enabled == 0
   " For some reason, coc still handles events and shows the popup menu even
   " though it hasn't started?? it's weird
   CocDisable
endif

" Use a function to toggle Coc's enabled status
" See https://stackoverflow.com/q/64507845
let g:coc_start_at_startup = g:dotfiles_coc_enabled
function! ToggleCoc()
   if g:dotfiles_coc_enabled == 0
      let g:dotfiles_coc_enabled = 1
      CocStart
      CocEnable
      echo 'COC on'
   else
      let g:dotfiles_coc_enabled = 0
      echo 'COC off'
      call coc#rpc#stop()
   endif
endfunction

" \c == enable/disable coc
nnoremap <silent> <leader>c <cmd>call ToggleCoc()<cr>

" all plugins to install
let g:coc_global_extensions = [
  \ "coc-json",
  \ "coc-tsserver",
  \ "coc-prettier",
  \ "coc-snippets",
  \ ]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ g:dotfiles_coc_enabled == 0 ? "\<Tab>" :
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ coc#jumpable() ? "\<C-j>" :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB>
      \ g:dotfiles_coc_enabled == 0 ? "\<C-h>" :
      \ coc#pum#visible() ? coc#pum#prev(1) :
      \ coc#jumpable() ? "\<C-k>" :
      \ "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR>
      \ g:dotfiles_coc_enabled == 0 ? "\<CR>" :
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ coc#expandable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand',''])\<CR>" :
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Also have unambiguous mappings for next/prev snippet placeholder
let g:coc_snippet_next = '<C-j>'
let g:coc_snippet_prev = '<C-k>'

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
nmap <silent> gh <CMD>call CocAction('doHover')<CR>

" \a == do code action
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
" \ac == code action at cursor
nmap <leader>ac <Plug>(coc-codeaction-cursor)
" \as == code action for source
nmap <leader>as <Plug>(coc-codeaction-source)

" \f == format code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" \rn == rename symbol
nmap <leader>rn <Plug>(coc-rename)

" Add `:Format` command to format current buffer.
" Formats the entire buffer.
command! -nargs=0 Format :call CocAction('format')

command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

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

" So that the status bar actually redraws when coc has a spinner in it
autocmd User CocStatusChange redrawstatus

" coc.nvim settings end

" ocamlformat
set rtp^="$HOME/.opam/default/share/ocp-indent/vim"

" telescope.nvim settings start
nnoremap <leader>ff <cmd>Telescope git_files<cr>
nnoremap <leader>fd <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>f* <cmd>Telescope grep_string<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fc <cmd>Telescope command_history<cr>
nnoremap <leader>fs <cmd>Telescope search_history<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>
" telescope.nvim settings end

" fugitive settings start
nnoremap <leader>gg <cmd>GBrowse<cr>
vnoremap <leader>gg <cmd>'<,'>GBrowse<cr>
" fugitive settings end

" conflict-marker.vim settings start
let g:conflict_marker_enable_mappings = 0
nmap <buffer>]x <Plug>(conflict-marker-next-hunk)
nmap <buffer>[x <Plug>(conflict-marker-prev-hunk)
" conflict-marker.vim settings end
