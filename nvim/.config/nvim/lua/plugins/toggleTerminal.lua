return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      size = 15,
      open_mapping = [[<leader>t]],
      direction = "horizontal",
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    })

    vim.keymap.set("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode", noremap = true })
  end,
}
