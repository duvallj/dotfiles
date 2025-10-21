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
    "tinted-theming/tinted-vim",
    branch = "main",
  },
 {
    "nvim-lualine/lualine.nvim",
    branch = "master",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      theme = "base16",
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "saghen/blink.cmp",
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = "default" }, -- <C-Space> to show, <C-y> to accept, <C-e> to exit
      sources = {
        default = { "lsp", "path", "buffer", },
      },
      fuzzy = {
        -- Always prioritize exact matches
        sorts = {
          'exact',
          -- defaults
          'score',
          'sort_text',
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    tag = "v2.3.0",
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
        -- rust_analyzer = {}, -- Configured by rustaceanvim instead
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
    ---@module "conform"
    ---@type conform.setupOpts
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
    'mfussenegger/nvim-dap',
    version = "0.11",
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "dap-repl",
        callback = function()
          require("blink.cmp.completion.windows.menu").auto_show = false
        end,
      })
    end,
    cmd = {
      "DapToggleBreakpoint",
      "DapNew",
      "DapContinue",
      "DapStepOver",
      "DapStepInto",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Continue" },
      { "<F4>", function() require("dap").restart() end, desc = "Restart Debugging" },
      { "<F3>", function() require("dap").terminate() end, desc = "Stop Debugging" },
      { "<F6>", function() require("dap").pause() end, desc = "Pause Debugging" },
      { "<F10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Step Into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Step Out" },
      { "<F9>", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dr", function() require("dap").repl.open() end , desc = "Open Repl" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last Debugged" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover (Debugging)" },
      { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Preview (Debugging)" },
      {
        "<leader>df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "Frames (Debugging)",
      },
      {
        "<leader>ds",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes (Debugging)",
      },
    },
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    'leoluz/nvim-dap-go',
    version = false,
    opts = {
      dap_configurations = {
        {
          type = "go",
          name = "Attach remote",
          mode = "remote",
          request = "attach",
        },
      },
    },
    keys = {
      { "<leader>dgt", function() require("dap-go").debug_test() end, desc = "Debug Test (Go)", ft = "go" },
      { "<leader>dgl", function() require("dap-go").debug_last_test() end, desc = "Debug Last Test (Go)", ft = "go" },
    },
  },
  {
    "folke/snacks.nvim",
    branch = "main",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      explorer = {
        enabled = true,
        replace_netrw = false,
      },
      image = { enabled = true },
      indent = {
        enabled = true,
        animate = { enabled = false },
        scope = { enabled = false },
      },
      picker = { enabled = true },
      statuscolumn = { enabled = false }, -- doesn't work with gitsigns.vim
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
      { "<leader>fr", function() Snacks.picker.resume() end, desc = "Resume" },
      -- Grep
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>f*", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      -- git
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      -- LSP
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      -- Other
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    },
  },
  {
    "folke/trouble.nvim",
    tag = "v3.7.1",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Trouble/Quickfix Item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Trouble/Quickfix Item",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>d", group = "debugging" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>h", group = "hunks" },
          { "<leader>s", group = "search" },
          { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
  },
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory of window", mode = "n" },
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
  -- TODO: write a version of vim-unimpaired for ]n and [n
  {
    -- Used for :Git blame
    "tpope/vim-fugitive",
    branch = "master",
  },
  {
    -- Used for :GBrowse
    "tpope/vim-rhubarb",
    branch = "master",
    dependencies = { "tpope/vim-fugitive" },
  },
  -- TODO: quick version of :GBrowse that's accessible in both normal and visual modes
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
        end, { desc = "Next Hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({"[c", bang = true})
          else
            gitsigns.nav_hunk("prev")
          end
        end, { desc = "Prev Hunk" })
        map("n", "]C", function() gitsigns.nav_hunk("last") end, { desc = "Last Hunk" })
        map("n", "[C", function() gitsigns.nav_hunk("first") end, { desc = "First Hunk" })

        -- Actions
        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage Hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset Hunk" })
        map("v", "<leader>hs", function() gitsigns.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Stage Hunk" })
        map("v", "<leader>hr", function() gitsigns.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "Reset Hunk" })
        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage Buffer" })
        map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset Buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview Hunk" })
      end
    }
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
