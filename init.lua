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
    'sheerun/vim-polyglot',
    tag = 'v4.17.1'
  },
  'vim-airline/vim-airline',
  'tinted-theming/base16-vim',
  {
    'neoclide/coc.nvim',
    branch = 'release',
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
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
  }
})

require('telescope').setup {
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


vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
]])
