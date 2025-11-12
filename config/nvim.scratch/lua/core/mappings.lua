function toggle_checkbox()
    local line = vim.api.nvim_get_current_line()
    if string.find(line, "%[ %]") then
        line = string.gsub(line, "%[ %]", "[x]")
    elseif string.find(line, "%[x%]") then
        line = string.gsub(line, "%[x%]", "[ ]")
    else
        line = "- [ ] " .. line
    end
    vim.api.nvim_set_current_line(line)
end

vim.g.mapleader = " " -- easy to reach leader key
--vim.keymap.set("n", "\\", " ") -- second leader
vim.keymap.set("n", "-", "<Esc>:e %:p:h<CR>") -- need nvim 0.8+
vim.keymap.set("n", "<leader>n", "<Esc>:NERDTreeToggle<CR>") -- need nvim 0.8+

-- Newly added key mapping
-- Maybe this would need its onw file later.
vim.keymap.set('n', '<leader>w', '<cmd>write<CR>', { desc = "Save the current file" })
vim.keymap.set('n', '<leader>s', '<cmd>w<CR><cmd>source %<CR>', { desc = "Source the current file" })
vim.keymap.set("n", "<leader>yy", '<cmd>let @*=expand("%")."\\n"<CR>', { desc = "Copy filename to the clipboard" })
vim.keymap.set("n", "<leader>yl", '<cmd>let @*=expand("%").":".line(".")."\\n"<CR>', { desc = "Copy filename with line number to the clipboard" })
vim.keymap.set("n", "P", 'o<Esc>p', { desc = "Paste on a inserted line" })

-- checkbox toggles
vim.keymap.set("n", "t", toggle_checkbox, { desc = "Toggle all checkboxes to checked" })
