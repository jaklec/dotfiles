return {
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        providers = {
          lsp = { score_offset = 100 },
          buffer = { score_offset = -100 },
        },
      },
    },
  },
}
