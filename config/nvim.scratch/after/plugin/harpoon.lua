local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup({
    menu = {
        width = vim.api.nvim_win_get_width(0) - 2,
    }
})
-- REQUIRED

vim.keymap.set("n", "<C-e>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>r", function() harpoon:list():remove() end)
vim.keymap.set("n", "<leader>ee", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-e><C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)
