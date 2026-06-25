return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                ignore = { "*" }, -- Stop Pyright from linting
              },
            },
          },
        },
      },
    },
  },
}
