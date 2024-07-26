--[[
  File: plugins.lua
  Description: This file needed for loading plugin list into lazy.nvim and loading plugins
  Info: Use <zo> and <zc> to open and close foldings
  See: https://github.com/folke/lazy.nvim
]]

require "helpers/globals"

return {
  -- dashboard, start page {{{
  -- {
  --   "glepnir/dashboard-nvim",
  --   event = 'VimEnter',
  --   config = true,
  --   dependencies = "nvim-tree/nvim-web-devicons"
  -- },

  {
    "mhinz/vim-startify",

    dependencies = {
      {
        "tiagovla/scope.nvim",
        lazy = false,
        config = function()
          require "extensions.scope"
        end
      }
    },
    config = function()
      require "extensions.startify"
    end
  },
  --}}}

  -- noice (gui for commandline, messages, etc.) DISABLED {{{
  -- {
  --   "folke/noice.nvim",
  --   -- event = "VeryLazy",
  --   opts = {
  --     -- add any options here
  --   },
  --   dependencies = {
  --     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
  --     "MunifTanjim/nui.nvim",
  --     -- OPTIONAL:
  --     --   `nvim-notify` is only needed, if you want to use the notification view.
  --     --   If not available, we use `mini` as the fallback
  --     "rcarriga/nvim-notify",
  --   },
  --   config = function()
  --     require "extensions.noice"
  --   end
  -- },
  -- }}}

  -- figet.nvim - notifications {{{
  {
    "j-hui/fidget.nvim",
    opts = {
      -- options
    },
  },
  -- }}}

  -- nvim-origami: fold/unfold using h/l {{{
  {
    "chrisgrieser/nvim-origami",
    event = "BufReadPost", -- later or on keypress would prevent saving folds
    opts = {},             -- needed even when using default config
    config = function()
      require "extensions.origami"
    end
  },
  -- }}}

  -- Mason {{{
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- the config is called inside LSP config to call it in the right order
    end
  },
  -- }}}

  -- DAP (Debug Adapter Protocol) {{{
  {
    'mfussenegger/nvim-dap',
  },
  -- }}}

  -- LSP config {{{
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
      "creativenull/efmls-configs-nvim"
    },
    config = function()
      require "extensions.lspconfig"
    end
  },
  --}}}

  -- murmur (highlight words) {{{
  {
    "nyngwang/murmur.lua",
    lazy = false,
    config = function()
      require "extensions.murmur"
    end
  },
  --}}}

  -- indent-blankline (DISABLED) {{{
  -- {
  --   'lukas-reineke/indent-blankline.nvim',
  --   main = 'ibl',
  --   config = function()
  --     require "extensions.ibl"
  --   end
  -- },
  -- }}}

  -- neo-tree file, symbols browser - DISABLED in favour of oil {{{
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   branch = "v3.x",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
  --     "MunifTanjim/nui.nvim",
  --     "3rd/image.nvim",              -- Optional image support in preview window: See `# Preview Mode` for more information
  --   },
  --   config = function()
  --     require "extensions.neotree"
  --   end
  -- },
  -- }}}

  -- oil - file browser as a simple buffer {{{
  {
    'stevearc/oil.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require "extensions.oil"
    end
  },
  -- }}}

  -- dropbar/breadcrumbs {{{
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
    dependencies = {
      'nvim-telescope/telescope-fzf-native.nvim'
    },
    config = function()
      require "extensions.dropbar"
    end
  },
  -- }}}

  -- Telescope {{{
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      'jonarrien/telescope-cmdline.nvim',
      "nvim-telescope/telescope-ui-select.nvim",
      "catgoose/telescope-helpgrep.nvim",
      "ecthelionvi/NeoComposer.nvim",
    },
    config = function()
      require "extensions.telescope"
    end
  },
  -- }}}

  -- CMP {{{
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-cmdline', 'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
      -- 'zbirenbaum/copilot.lua',
      -- 'zbirenbaum/copilot-cmp',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
    },
    config = function()
      require "extensions.cmp"
    end
  },
  -- }}}

  -- Codeium {{{
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
  -- }}}

  -- autopairs {{{
  {
    'windwp/nvim-autopairs',
    config = function()
      require("nvim-autopairs").setup()
    end
  },
  -- }}}

  -- edit surroundings {{{
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = true,
  },
  -- }}}

  -- comments {{{
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  -- }}}

  -- find and replace {{{
  {
    'MagicDuck/grug-far.nvim',
    config = true,
  },
  -- {
  --   'brooth/far.vim',
  -- },
  -- }}}

  -- neogit {{{
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "nvim-telescope/telescope.nvim", -- optional
      "sindrets/diffview.nvim",        -- optional
    },
    config = true
  },
  -- }}}

  -- git conflicts {{{
  {
    'akinsho/git-conflict.nvim',
    version = "*",
    config = true
  },
  -- }}}

  -- Git Signs{{{
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
      require "extensions.gitsigns"
    end
  },
  -- }}}

  -- sorting {{{
  {
    'sQVe/sort.nvim',
    config = true,
  },
  -- }}}

  -- Trouble {{{
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require "extensions.trouble"
    end,
  },
  -- }}}

  -- toggle terminal {{{
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
      require "extensions.toggleterm"
    end
  },
  -- }}}

  -- TreeSitter {{{
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require "extensions.treesitter"
    end
  },
  -- }}}

  -- vimwiki {{{
  {
    'vimwiki/vimwiki',
    init = function()
      require "extensions.vimwiki"
    end
  },
  --}}}

  -- lualine {{{
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'ecthelionvi/NeoComposer.nvim',
    },
    config = function()
      require "extensions.lualine"
    end
  },
  -- }}}

  -- incline - floating statusline {{{
  {
    'b0o/incline.nvim',
    config = function ()
      require "extensions.incline"
    end,
    event = 'VeryLazy',
  },
  -- }}}

  -- bufferline {{{
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require "extensions.bufferline"
    end
  },
  -- }}}

  -- bufdel {{{
  {
    "ojroques/nvim-bufdel",
    config = function()
      require "extensions.bufdel"
    end
  },
  --}}}

  -- devicons {{{
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    config = function()
      require "extensions.devicons"
    end
  },
  -- }}}

  -- mini.icons {{{
  { 'echasnovski/mini.icons', version = false },
  -- }}}

  -- preview colors {{{
  {
    "norcalli/nvim-colorizer.lua",
  },
  -- }}}

  -- which key {{{
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require "extensions.which-key"
    end
  },
  --}}}

  -- neophyte (config for wgpu-based neovim frontend) (DISABLED breaks neovim 0.10) {{{
  -- {
  --   'tim-harding/neophyte',
  --   tag = '0.2.2',
  --   event = 'VeryLazy',
  --   config = function()
  --     require "extensions.neophyte"
  --   end
  -- },
  -- }}}

  -- org-mode {{{
  {
    'nvim-orgmode/orgmode',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', lazy = true },
    },
    config = function()
      require "extensions.orgmode"
    end
  },

  {
    'akinsho/org-bullets.nvim',
    config = function()
      require('org-bullets').setup()
    end
  },
  -- }}}

  -- language: nu (DISABLED breaks 0.10) {{{
  -- {
  --   "LhKipp/nvim-nu",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --     "zioroboco/nu-ls.nvim",
  --   },
  --   config = function()
  --     require("nu").setup({})
  --   end
  -- },
  -- }}}

  -- language: slint {{{
  {
    "slint-ui/vim-slint"
  },
  -- }}}

  -- crates.nvim - a plugin to work with crates.io - DISABLED - too slow for big projects {{{
  -- {
  --   'saecki/crates.nvim',
  --   tag = 'stable',
  --   config = function()
  --     require('crates').setup()
  --   end,
  -- },
  -- }}}

  -- markdown preview {{{
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown',                                                       -- Only needed if you have another plugin named markdown.nvim
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    config = function()
      require('render-markdown').setup({})
    end,
  },
  -- }}}

  -- WGSL syntax highlighting {{{
  {
    "DingDean/wgsl.vim",
  },
  -- }}}

  -- twilight: dim innactive code (DISABLED) {{{
  {
    "folke/twilight.nvim",
    enabled = false,
    config = function()
      require "extensions.twilight"
      cmd("TwilightEnable")
    end
  },
  -- }}}

  -- color themes {{{
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      require "extensions.colorscheme.catppuccin"
      -- cmd("color catppuccin-frappe")
    end
  },

  {
    -- DEFAULT
    'mcchrish/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim'
    },
    lazy = false,
    priority = 1000,
    config = function()
      cmd("color zenwritten")
      -- cmd("color nordbones")
      -- cmd("color tokyobones")
    end
  },

  {
    "nyoom-engineering/oxocarbon.nvim",
    priority = 1000,
    -- config = function()
    --   vim.opt.background = 'dark'
    --   cmd("color oxocarbon")
    -- end
  },

  {
    "pbrisbin/vim-colors-off",
    priority = 1000,
    -- config = function()
    --   vim.opt.background = 'dark'
    --   cmd("color off")
    -- end
  },

  {
    "ales-tsurko/paramount-ng.nvim",
    priority = 1000,
    dependencies = {
      "rktjmp/lush.nvim"
    },
    -- config = function()
    --   vim.opt.background = 'dark'
    --   cmd("color paramount-ng")
    -- end
  },

  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- require 'nordic'.load()
    end
  },

  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- cmd("color onedarkpro")
    end
  },
  -- }}}
}

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0
