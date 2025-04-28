vim.g.mapleader = " " -- easy to reach leader key
--vim.keymap.set("n", "\\", " ") -- second leader
vim.keymap.set("n", "-", "<Esc>:e %:p:h<CR>") -- need nvim 0.8+
vim.keymap.set("n", "<leader>n", "<Esc>:NERDTreeToggle<CR>") -- need nvim 0.8+
