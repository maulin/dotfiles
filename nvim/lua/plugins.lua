local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Set leader before plugins

vim.g.mapleader = ','
vim.g.maplocalleader = ','


require('lazy').setup(
  {
    {
      'tpope/vim-fugitive',
      dependencies = {
        { 'tpope/vim-rhubarb' },
      }
    },
    {'preservim/nerdtree'},
    {'folke/tokyonight.nvim'},
    {'VonHeikemen/lsp-zero.nvim'},
    {'neovim/nvim-lspconfig'},
    {
      'hrsh7th/nvim-cmp',
      dependencies = {
        { 'saadparwaiz1/cmp_luasnip' },
        {'hrsh7th/cmp-nvim-lsp'},
        {'hrsh7th/cmp-buffer'},
        {
          "L3MON4D3/LuaSnip",
          dependencies = {
            "rafamadriz/friendly-snippets",
          },
        },
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function () 
        local configs = require('nvim-treesitter.configs')

        configs.setup({
          ensure_installed = { 
            'html',
            'javascript',
            'json',
            'lua',
            'markdown',
            'ruby',
            'typescript',
            'vim',
            'vimdoc',
            'yaml',
          },
          sync_install = false,
          auto_install = true,
          highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
          },
          indent = { enable = true },  
        })
      end
    },
    {
      'nvim-telescope/telescope.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-fzf-native.nvim'
      }
    }
  }
)
