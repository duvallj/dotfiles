return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cspell_ls = {},
        tsgo = {
          cmd = { "npx", "tsgo", "--lsp", "--stdio" },
        },
      },
    },
  },
  {
    "esmuellert/nvim-eslint",
    opts = {},
  },
}
