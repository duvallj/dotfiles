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
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    branch = "master",
    opts = {
      theme = "base16",
    },
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
    tag = "v2.1.0",
    dependencies = {
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
    opts = {
      servers = {
        clangd = {},
        cssls = {},
        eslint = {},
        gopls = {},
        html = {},
        jsonls = {},
        nixd = {},
        rust_analyzer = {},
        ts_ls = {
          cmd = { "npx", "typescript-language-server", "--stdio" },
        },
      },
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
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

          -- TODO: mapping to quickly open previous tag (accessible with <C-i>) in new tab.
          -- I want this because all the following mappings, if they find something that there's only one of, jump immediately to it.
          if client.server_capabilities.definitionProvider then
            map("n", "grd", function() Snacks.picker.lsp_definitions() end)
          end

          if client.server_capabilities.declarationProvider then
            map("n", "grD", function() Snacks.picker.lsp_declarations() end)
          end

          if client.server_capabilities.typeDefinitionProvider then
            map("n", "gry", function() Snacks.picker.lsp_type_definitions() end)
          end

          if client.server_capabilities.implementationProvider then
            map("n", "gri", function() Snacks.picker.lsp_implementations() end)
          end

          if client.server_capabilities.referencesProvider then
            map("n", "grr", function() Snacks.picker.lsp_references() end, { nowait = true })
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
      { "<leader>bb", function() require("conform").format({ async = true }) end, mode = "", desc = "Format buffer", },
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
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
        scope = { enabled = false },
      },
      picker = {
        enabled = true,
        win = {
          -- input window
          input = {
            keys = {
              ["<CR>"] = { "tab", mode = { "i", "n" } },
            },
          },
          -- results list window
          list = {
            keys = {
              ["<CR>"] = "tab",
            },
          },
        }
      },
      statuscolumn = { enabled = true },
    },
    -- See https://github.com/folke/snacks.nvim for the full list of ideas;
    -- For now, I'm mostly keeping these binds the same as my old config.
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- find
      { "<leader>fd", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>ff", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      -- Grep
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>f*", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- LSP
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      -- Other
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    },
  },
  {
    "folke/trouble.nvim",
    tag = "v3.7.1",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
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
    "tpope/vim-unimpaired",
    branch = "master",
  },
  {
    'tpope/vim-fugitive',
    branch = "master",
    lazy = false,
    keys = {
      { "<leader>gg", "<cmd>GBrowse<cr>", mode = "n", desc = "GBrowse", },
      { "<leader>gg", "<cmd>'<,'>GBrowse<cr>", mode = "v", desc = "GBrowse (visual)", },
    },
  },
  {
    "tpope/vim-rhubarb",
    branch = "master",
  },
  {
    "lewis6991/gitsigns.nvim",
    tag = "v1.0.2",
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
