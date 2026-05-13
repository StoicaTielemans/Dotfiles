return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = {
                  -- This adds the Hyprland stubs to the LSP path
                  "/usr/share/hypr/stubs",
                },
                checkThirdParty = false,
              },
              diagnostics = {
                -- This stops the "undefined global" warning for 'hl'
                globals = { "hl", "vim" },
              },
            },
          },
        },
      },
    },
  },
}
