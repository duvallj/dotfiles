return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle",
            formatterProseWrap = true,
            formatterPrintWidth = 80,
            formatterIndentSize = 2,

            exportPdf = "onSave",
            semanticTokens = "disable",
          },
        },
      },
    },
  },
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    version = "1.*",
    opts = {},
  },
}
