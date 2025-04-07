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

require("lazy").setup({
  {
    "vim-airline/vim-airline",
    branch = "master",
  },
  {
    "tinted-theming/tinted-vim",
    branch = "main",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
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
  {
    "saghen/blink.cmp",
    version = "1.*",
    --@module "blink.cmp"
    --@type blink.cmp.Config
    opts = {
      keymap = { preset = "enter" },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", },
      },
    },
    opts_extend = { "sources.default", },
  },
  {
    "neovim/nvim-lspconfig",
    tag = "v1.7.0",
    dependencies = {
      "saghen/blink.cmp",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      servers = {
        gopls = {},
        nixd = {},
        ts_ls = {
          cmd = { "npx", "typescript-language-server", "--stdio" },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local builtin = require("telescope.builtin")
      for server, config in pairs(opts.servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          if client.server_capabilities.definitionProvider then
            map("n", "grd", function() builtin.lsp_definitions { jump_type = "tab" } end)
          end

          if client.server_capabilities.typeDefinitionProvider then
            map("n", "gry", function() builtin.lsp_type_definitions { jump_type = "tab" } end)
          end

          if client.server_capabilities.implementationProvider then
            map("n", "gri", function() builtin.lsp_implementations { jump_type = "tab" } end)
          end

          if client.server_capabilities.referencesProvider then
            map("n", "grr", builtin.lsp_references)
          end

          if client.server_capabilities.renameProvider then
            map("n", "grn", vim.lsp.buf.rename)
          end

          if client.server_capabilities.codeActionProvider then
            map("n", "gra", vim.lsp.buf.code_action)
          end
        end,
      })

      vim.api.nvim_create_autocmd("LspProgress", {
        pattern = "*",
        command = "redrawstatus",
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    tag = "stable",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>f", function() require("conform").format({ async = true }) end, mode = "", desc = "Format buffer", },
    },
    --@module "conform"
    --@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        css = { "prettier" },
        go = { "goimports", "gofmt" },
        html = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 1000,
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim"
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
    "nvim-telescope/telescope-fzf-native.nvim",
    branch = "main",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
    config = function()
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "tpope/vim-repeat",
    branch = "master",
  },
  {
    "tpope/vim-surround",
    branch = "master",
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
    "tpope/vim-rhubarb",
    branch = "master",
    cmd = { "GBrowse" },
  },
  {
    "lewis6991/gitsigns.nvim",
    tag = "v0.8.1",
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({"]c", bang = true})
          else
            gitsigns.nav_hunk("next")
          end
        end)

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({"[c", bang = true})
          else
            gitsigns.nav_hunk("prev")
          end
        end)

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk)
        map("n", "<leader>hr", gitsigns.reset_hunk)
        map("v", "<leader>hs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end)
        map("v", "<leader>hr", function() gitsigns.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end)
        map("n", "<leader>hS", gitsigns.stage_buffer)
        map("n", "<leader>hu", gitsigns.undo_stage_hunk)
        map("n", "<leader>hR", gitsigns.reset_buffer)
        map("n", "<leader>hp", gitsigns.preview_hunk)
      end
    }
  },
  {
    "rhysd/conflict-marker.vim",
    branch = "master",
    config = function()
      vim.cmd([[
let g:conflict_marker_enable_mappings = 0
nmap <buffer>]x <Plug>(conflict-marker-next-hunk)
nmap <buffer>[x <Plug>(conflict-marker-prev-hunk)
]])
    end,
  },
  {
    "rbong/vim-flog",
    branch = "master",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
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
