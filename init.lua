-- Setup lazy.vim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'vim-airline/vim-airline',
    branch = 'master',
  },
  {
    'tinted-theming/tinted-vim',
    branch = 'main',
  },
  {
    'neoclide/coc.nvim',
    branch = 'release',
    config = function()
      vim.cmd([[
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
      ]])
    end,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<CR>"] = "select_tab",
          },
          n = {
            ["<CR>"] = "select_tab",
          },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        }
      },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope git_files<cr>", desc = "Find Files (git)", },
      { "<leader>fd",  "<cmd>Telescope find_files<cr>", desc = "Find Files (all)", },
      { "<leader>fg",  "<cmd>Telescope live_grep<cr>", desc = "Grep", },
      { "<leader>f*",  "<cmd>Telescope grep_string<cr>", desc = "Grep (under cursor)", },
      { "<leader>fb",  "<cmd>Telescope buffers<cr>", desc = "Find Buffer", },
      { "<leader>fh",  "<cmd>Telescope help_tags<cr>", desc = "Find Help", },
      { "<leader>fc",  "<cmd>Telescope command_history<cr>", desc = "Find Command", },
      { "<leader>fs",  "<cmd>Telescope search_history<cr>", desc = "Find Search", },
      { "<leader>fr",  "<cmd>Telescope resume<cr>", desc = "Resume Search", },
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    branch = 'main',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
    config = function()
      require('telescope').load_extension('fzf')
    end,
  },
  {
    'tpope/vim-repeat',
    branch = 'master',
  },
  {
    'tpope/vim-surround',
    branch = 'master',
  },
  {
    'tpope/vim-fugitive',
    tag = 'v3.7',
    lazy = false,
    keys = {
      { "<leader>gg", "<cmd>GBrowse<cr>", mode = "n", desc = "GBrowse", },
      { "<leader>gg", "<cmd>'<,'>GBrowse<cr>", mode = "v", desc = "GBrowse (visual)", },
    },
  },
  {
    'tpope/vim-rhubarb',
    branch = 'master',
  },
  {
    'lewis6991/gitsigns.nvim',
    tag = 'v0.8.1',
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal({']c', bang = true})
          else
            gitsigns.nav_hunk('next')
          end
        end)

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal({'[c', bang = true})
          else
            gitsigns.nav_hunk('prev')
          end
        end)

        -- Actions
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        map('n', '<leader>hS', gitsigns.stage_buffer)
        map('n', '<leader>hu', gitsigns.undo_stage_hunk)
        map('n', '<leader>hR', gitsigns.reset_buffer)
        map('n', '<leader>hp', gitsigns.preview_hunk)
      end
    }
  },
  {
    'rhysd/conflict-marker.vim',
    branch = 'master',
    config = function()
      vim.cmd([[
let g:conflict_marker_enable_mappings = 0
nmap <buffer>]x <Plug>(conflict-marker-next-hunk)
nmap <buffer>[x <Plug>(conflict-marker-prev-hunk)
]])
    end,
  },
  {
    'rbong/vim-flog',
    branch = 'master',
    lazy = true,
    cmd = { 'Flog', 'Flogsplit', 'Floggit' },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    config = function()
      local configs = require("nvim-treesitter.configs")
      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "javascript", "html", "css", "typescript", "tsx", "c" },
        sync_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
})

-- Let kitty know when nvim is open
vim.api.nvim_create_autocmd({ "VimEnter", "VimResume" }, {
  group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
  end,
})
vim.api.nvim_create_autocmd({ "VimLeave", "VimSuspend" }, {
  group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
  callback = function()
    io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
  end,
})


vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
]])
