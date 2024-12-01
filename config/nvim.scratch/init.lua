require "core.mappings"
require "core.plugins"

require "io"

local function load_vimfile(file)
  local f = assert(io.open(file, "r"))
  local content = f:read "*all"
  f:close()
  vim.cmd(content)
end

load_vimfile(vim.fn.expand('~/.vim/vimrc'))
