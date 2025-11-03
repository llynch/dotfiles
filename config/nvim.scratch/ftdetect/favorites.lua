vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("Favorites", { clear = true }),
  pattern = { "*.fav", ".favorites" }, -- Add more patterns as needed
  callback = function(ev)
    vim.bo[ev.buf].filetype = "favorites"
    vim.keymap.set("n", "<CR>", "Vgf", { buffer = true, remap = false, desc = "Open file under cursor" })
    print("🌟 press enter to open file under cursor")
  end,
})

webdevicons = require("nvim-web-devicons")
if webdevicons then
  webdevicons.set_icon {
    fav = {
      icon = "*",
      color = "#FFD700",
      cterm_color = "220",
      name = "Favorites"
    },
    favorites = {
      icon = "*",
      color = "#FFD700",
      cterm_color = "220",
      name = "Favorites"
    },
  }
end
