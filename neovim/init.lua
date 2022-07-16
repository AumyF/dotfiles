-- Packages

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'neovim/nvim-lspconfig'

  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  use 'nvim-treesitter/nvim-treesitter'

  use 'projekt0n/github-nvim-theme'

  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/plenary.nvim'}}
  }

  use {
    'jose-elias-alvarez/null-ls.nvim',
    requires = {{'nvim-lua/plenary.nvim'}}
  }

  use 'ray-x/lsp_signature.nvim'

  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require'trouble'.setup {}
    end
  }

  use 'machakann/vim-sandwich'

  use 'windwp/nvim-autopairs'

  use {
    'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      }
  }
end)

vim.cmd([[let g:neo_tree_remove_legacy_commands = 1]])

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])


-- Autopairs
require'nvim-autopairs'.setup {}


-- Neo-tree
require'neo-tree'.setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
  },
})


-- Completions

local cmp_autopairs = require'nvim-autopairs.completion.cmp'
local cmp = require'cmp'

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done { map_char = { tex = '' } })

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  })
})


-- Ex Commands

vim.cmd('command! -nargs=* Terminal vsplit | wincmd j | vertical resize 80 | terminal <args>')


-- Keybindings

local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<Space>p', '<cmd>Telescope fd<CR>', opts)
vim.keymap.set('n', '<Space>f', '<cmd>Neotree reveal<CR>')
vim.keymap.set('n', '<Space>t', '<cmd>Terminal<CR>')

-- Move focus
vim.keymap.set('n', '<Space>j', '<C-w>w')
vim.keymap.set('n', '<Space>k', '<C-w>W')

-- Language servers

local lsp_set_keymap = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<Space>lca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Space>lrn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Space>lf', vim.lsp.buf.formatting, opts)
end

local servers = { 'rust_analyzer', 'ocamllsp', 'eslint', 'prismals', 'rnix', 'dhall_lsp_server' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = function(client, bufnr)
      lsp_set_keymap(client, bufnr)
    end,
  }
end

-- In some languages we prefer to use external formatters (i.e. Prettier) rather than ones servers provide
local formatting_disabled_servers = { 'jsonls', 'html', 'cssls', 'volar', 'graphql', 'tsserver' }
for _, lsp in pairs(formatting_disabled_servers) do
  require('lspconfig')[lsp].setup {
    on_attach = function(client, bufnr)
      lsp_set_keymap(client, bufnr)
      client.resolved_capabilities.document_formatting = false
    end,
  }
end


-- lsp_signature
require'lsp_signature'.setup {}

-- null-ls
local nullls = require'null-ls'
nullls.setup {
  sources = {
    nullls.builtins.formatting.prettier,
  },
}


-- Tree-sitter
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      node_decremental = "grm",
    },
  },
  ensure_installed = {
    'bash',
    'c',
    'clojure',
    'cpp',
    'css',
    'dockerfile',
    'go',
    'html',
    'javascript',
    'json',
    'jsonc',
    'lua',
    'make',
    'nix',
    'ocaml',
    'ocaml_interface',
    'prisma',
    'rust',
    'scheme',
    'toml',
    'typescript',
    'tsx',
    'vue',
    'yaml',
  },
}


-- Color theme

require'github-theme'.setup {
  theme_style = 'dark_default',
}

-- General configurations

vim.wo.number = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0
-- Open terminal in insert mode
vim.cmd('autocmd TermOpen * startinsert')
