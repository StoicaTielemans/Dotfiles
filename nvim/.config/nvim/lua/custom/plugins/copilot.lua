return {
  {
    'github/copilot.vim',
    config = function()
      -- Optional configuration settings
      vim.g.copilot_no_tab_map = false -- Disable Copilot's default Tab mapping
      -- You can add more settings if needed, refer to the readme of copilot.vim for full config options
    end,
  },
}
