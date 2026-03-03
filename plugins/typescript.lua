return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
