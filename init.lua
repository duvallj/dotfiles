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
  'vim-airline/vim-airline',
  'tinted-theming/base16-vim',
  {
    'neoclide/coc.nvim',
    branch = 'release',
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release'
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
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
  },
  {
    'lewis6991/gitsigns.nvim',
    tag = 'v0.8.1',
  }
})

require('telescope').setup {
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
  }
}

require('telescope').load_extension('fzf')

require('gitsigns').setup()


vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
]])
