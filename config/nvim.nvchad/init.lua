require "core"

require "io"

local function load_vimfile(file)
  local f = assert(io.open(file, "r"))
  local content = f:read "*all"
  f:close()
  vim.cmd(content)
end

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()
vim.cmd([[nmap \ <Space>]])

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"


load_vimfile('/home/llynch/.vim/vimrc')

-- https://github.com/NvChad/NvChad/blob/v2.0/lua/core/init.lua
local function update_status()
  -- local config = require("core.utils").load_config().ui
  local content = require("nvchad_ui.statusline.default").run()
  vim.opt_local.statusline = content
end

vim.api.nvim_create_autocmd("BufEnter", {
    callback = update_status
})

vim.opt.statusline = nil
