local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- My plugins here
  use "nvim-lua/plenary.nvim"
  use { 'preservim/nerdtree' }
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'folke/which-key.nvim' }
  use ( 'nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'} )
  use { 'nvim-treesitter/playground' }
  use { 'tpope/vim-fugitive' }
  use { 'gregsexton/gitv' }

  -- costumize status line
  -- use { 'bling/vim-airline' }
  -- use { 'powerline/powerline' }
  use { 'nvim-lualine/lualine.nvim', requires = { 'nvim-tree/nvim-web-devicons', opt = true } }
  -- use { 'nvim-tree/nvim-web-devicons' }
  use { 'nvim-tree/nvim-web-devicons' }

  use { 'ctrlpvim/ctrlp.vim' }
  use { "jiaoshijie/undotree", requires = { "nvim-lua/plenary.nvim", }, }

  -- https://lsp-zero.netlify.app/blog/theprimeagens-config-from-2022.html
  use { 'neovim/nvim-lspconfig' }
  use { 'mason-org/mason.nvim' }
  use {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "neovim/nvim-lspconfig",
    },
}
  use { 'hrsh7th/nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  -- use { 'saadparwaiz1/cmp_luasnip' }
  use({ "L3MON4D3/LuaSnip", tag = "v2.*", run = "make install_jsregexp" })

  use { "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" }

  use { "rking/ag.vim" }
  use { "will133/vim-dirdiff" }
  use { 'lbrayner/vim-rzip' }
  use { 'easymotion/vim-easymotion' }

  use { "ThePrimeagen/harpoon", branch = "harpoon2", requires = { {"nvim-lua/plenary.nvim"} } }

  use { "tikhomirov/vim-glsl" }

  -- use { '3rd/image.nvim', rocks = { 'magick' } }
  use { 'samjwill/vim-bufdir' }
  use { 'github/copilot.vim' }
  -- use { "zbirenbaum/copilot.lua" }
  use { 'stevearc/oil.nvim' }

  use { "kndndrj/nvim-dbee", requires = { "MunifTanjim/nui.nvim", },
      run = function()
        -- Install tries to automatically detect the install method.
        -- if it fails, try calling it with one of these parameters:
        --    "curl", "wget", "bitsadmin", "go"
        require("dbee").install()
      end,
      config = function()
        require("dbee").setup(--[[optional config]])
      end
  }

  use { 'xiyaowong/telescope-emoji.nvim' }

  -- rust plugin
  -- https://github.com/mrcjkb/rustaceanvim
  -- use { 'mrcjkb/rustaceanvim', version = '^5', rocks = { 'rustaceanvim'} }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
