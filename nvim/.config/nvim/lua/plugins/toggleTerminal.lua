return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("toggleterm").setup({
      size = 5,
      open_mapping = [[<leader>t]],
      direction = "float",
      shade_terminals = true,
      start_in_insert = true,
      persist_size = true,
      close_on_exit = true,
      shell = vim.o.shell,
    })

    vim.keymap.set("n", "<leader>t", function()
      vim.cmd("ToggleTerm")
    end, { desc = "Toggle Terminal", noremap = true, silent = true })

    vim.keymap.set("t", "<C-f>", "<Nop>", { noremap = true, silent = true })
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode", noremap = true })
  end,
}
