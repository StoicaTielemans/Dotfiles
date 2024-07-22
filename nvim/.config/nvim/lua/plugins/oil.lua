return {
  {
    'stevearc/oil.nvim',
    opts = {
      delete_to_trash = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, '.')
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
      },
    },
    progress = {
      max_width = 0.9,
    },
    -- Optional dependencies
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },
}
