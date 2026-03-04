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

-- cribbed from https://www.lazyvim.org/plugins/treesitter
-- and https://github.com/LazyVim/LazyVim/blob/31caef21fdf4009a7d5c8342a14b7d8b97be611d/lua/lazyvim/util/treesitter.lua
-- adapted for my own (minimal) needs
TS_installed = {} ---@type table<string,boolean>
TS_queries = {} ---@type table<string,boolean>
function TS_refresh_installed()
  TS_installed, TS_queries = {}, {}
  for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
    TS_installed[lang] = true
  end
end

function TS_have_query(lang, query)
  local key = lang .. ":" .. query
  if TS_queries[key] == nil then
    TS_queries[key] = vim.treesitter.query.get(lang, query) ~= nil
  end
  return TS_queries[key]
end

function TS_have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == "number" and vim.bo[what].filetype or what
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or TS_installed[lang] == nil then
    return false
  end
  if query and not TS_have_query(lang, query) then
    return false
  end
  return true
end

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
      extensions = {
        "nvim-dap-ui",
        "oil",
        "trouble",
      },
    },
  },
  {
    "kevinhwang91/nvim-hlslens",
    branch = "main",
    opts = {},
    keys = {
      { "n", "<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>" },
      { "N", "<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>" },
      { "*", "*<Cmd>lua require('hlslens').start()<CR>" },
      { "#", "#<Cmd>lua require('hlslens').start()<CR>" },
      { "g*", "g*<Cmd>lua require('hlslens').start()<CR>" },
      { "g#", "g#<Cmd>lua require('hlslens').start()<CR>" },
      { "<leader>l", "<Cmd>nohlsearch<CR>", desc = ":nohlsearch" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSLog", "TSInstall", "TSUninstall" },
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      folds = { enable = true },
      ensure_installed = {
        "bash",
        "c",
        "css",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "styled",
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
      local TS = require("nvim-treesitter")

      TS.setup(opts)
      TS_refresh_installed()

      local to_install = vim.tbl_filter(function(lang)
        return not TS_have(lang)
      end, opts.ensure_installed or {})
      if #to_install > 0 then
        TS.install(to_install, { summary = true }):await(function()
          TS_refresh_installed()
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim-treesitter", { clear = true }),
        callback = function(ev)
          local ft, lang = ev.match, vim.treesitter.language.get_lang(ev.match)
          if not TS_have(ft) then
            return
          end

          ---@param feat string
          ---@param query string
          local function enabled(feat, query)
            local f = opts[feat] or {}
            return f.enable ~= false
              and not (type(f.disable) == "table" and vim.tbl_contains(f.disable, lang))
              and TS_have(ft, query)
          end

          if enabled("highlight", "highlights") then
            vim.treesitter.start(ev.buf, lang)
          end

          if enabled("indent", "indents") then
            -- TODO: do I need the TS_have(nil, "indents") check?
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if enabled("folds", "folds") then
            vim.wo.foldmethod = "expr"
            -- TODO: do I need the TS_have(nil, "folds") check?
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      move = {
        enable = true,
        set_jumps = true,
        keys = {
          goto_next_start = {
            ["]f"] = "@function.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
          },
        }
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter-textobjects")
      TS.setup(opts)

      local function attach(buf)
        local ft = vim.bo[buf].filetype
        if not (vim.tbl_get(opts, "move", "enable") and TS_have(ft, "textobjects")) then
          return
        end

        local moves = vim.tbl_get(opts, "move", "keys") or {}
        for method, keymaps in pairs(moves) do
          for key, query in pairs(keymaps) do
            local queries = type(query) == "table" and query or { query }
            local parts = {}
            for _, q in ipairs(queries) do
              local part = q:gsub("@", ""):gsub("%..*", "")
              part = part:sub(1, 1):upper() .. part:sub(2)
              table.insert(parts, part)
            end
            local desc = table.concat(parts, " or ")
            desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
            desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
            vim.keymap.set({ "n", "x", "o" }, key, function()
              require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
            end, {
              buffer = buf,
              desc = desc,
              silent = true,
            })
          end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("nvim-treesitter-textobjects", { clear = true }),
        callback = function(ev)
          attach(ev.buf)
        end,
      })
      vim.tbl_map(attach, vim.api.nvim_list_bufs())
    end
  },
  {
    "windwp/nvim-ts-autotag",
    opts = {},
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
      completion = {
        menu = {
          auto_show = function()
            return vim.bo.filetype ~= "dap-repl"
          end
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    tag = "v2.5.0",
    dependencies = {
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
    opts = {
      servers = {
        clangd = {},
        cssls = {},
        gopls = {},
        html = {},
        jsonls = {},
        nixd = {},
        -- rust_analyzer = {}, -- Configured by rustaceanvim instead
      },
    },
    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
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
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
    config = function()
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      local dap, dapui = require("dap"), require("dapui")
      dapui.setup({})

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- Javascript debug adapters
      -- TODO: abstract this out into module somewhere
      for _, adapterType in ipairs({ "node", "chrome" }) do

        local pwaType = "pwa-" .. adapterType

        if not dap.adapters[pwaType] then
          dap.adapters[pwaType] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "js-debug",
              args = { "${port}" },
            },
          }
        end

        -- Define adapters without the "pwa-" prefix for VSCode compatibility
        if not dap.adapters[adapterType] then
          dap.adapters[adapterType] = function(cb, config)
            local nativeAdapter = dap.adapters[pwaType]

            config.type = pwaType

            if type(nativeAdapter) == "function" then
              nativeAdapter(cb, config)
            else
              cb(nativeAdapter)
            end
          end
        end
      end

      local js_filetypes = {
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
      };
      for _, language in ipairs(js_filetypes) do
        local runtimeExecutable = nil
        if language:find("typescript") then
          runtimeExecutable = vim.fn.executable("tsx") == 1 and "tsx" or "ts-node"
        end
        local configurations = dap.configurations[language] or {}
        table.insert(configurations, {
          type = "pwa-node",
          request = "launch",
          name = "Launch File",
          program = "${file}",
          cwd = "${workspaceFolder}",
          sourceMaps = true,
          runtimeExecutable = runtimeExecutable,
      })
      dap.configurations[language] = configurations
      end
    end,
    cmd = {
      "DapToggleBreakpoint",
      "DapNew",
      "DapContinue",
      "DapStepOver",
      "DapStepInto",
    },
    keys = {
      { "<leader>ds", function() require("dap").terminate() end, desc = "Stop Debugging (F3)" },
      { "<F3>",       function() require("dap").terminate() end, desc = "Stop Debugging" },
      { "<F4>",       function() require("dap").restart() end, desc = "Restart Debugging" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue (F5)" },
      { "<F5>",       function() require("dap").continue() end, desc = "Continue" },
      { "<F6>",       function() require("dap").pause() end, desc = "Pause Debugging" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" },
      { "<F9>",       function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Logpoint message: ")) end, desc = "Set Logpoint" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into (F10)" },
      { "<F10>",      function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Step Over (F11)" },
      { "<F11>",      function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out (F12)" },
      { "<F12>",      function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dr", function() require("dap").run_last() end, desc = "Run Last Debugged" },
      { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover (Debugging)" },
      { "<leader>dp", function() require("dap.ui.widgets").preview() end, desc = "Preview (Debugging)" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle Debugger UI" },
    },
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
    'mrcjkb/rustaceanvim',
    version = '^6', -- Recommended
    lazy = false, -- This plugin is already lazy
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {},
  },
  {
    "folke/snacks.nvim",
    branch = "main",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
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

-- Make it so moving files in oil.nvim causes LSP updates
-- TODO: put this in the main configuration somehow?
vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions[1].type == "move" then
      Snacks.rename.on_rename_file(event.data.actions[1].src_url, event.data.actions[1].dest_url)
    end
  end,
})

vim.cmd([[
set runtimepath^=~/.vim
let &packpath=&runtimepath
source ~/.vimrc
]])
