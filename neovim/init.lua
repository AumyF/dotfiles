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
  use 'xiyaowong/nvim-transparent'

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
  use {
    'phaazon/hop.nvim',
    branch = 'v2',
  }

  use 'windwp/nvim-autopairs'
  use 'windwp/nvim-ts-autotag'

  use {
    'nvim-neo-tree/neo-tree.nvim',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      }
  }

  use 'akinsho/toggleterm.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require'lualine'.setup()
    end
  }

  use {
    'akinsho/bufferline.nvim',
    tag = 'v3.*',
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()
      require'bufferline'.setup {}
    end
  }

  use 'ionide/Ionide-vim'
 
  use 'lukas-reineke/indent-blankline.nvim'
end)

vim.cmd([[let g:neo_tree_remove_legacy_commands = 1]])

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost init.lua source <afile> | PackerCompile
  augroup end
]])


-- Autopairs
require'nvim-autopairs'.setup {
  check_ts = true,
  enable_check_bracket_line = false,
}


-- Neo-tree
require'neo-tree'.setup({
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
  },
})


-- Toggleterm
require'toggleterm'.setup()
local Terminal = require'toggleterm.terminal'.Terminal
local lazygit = Terminal:new({
  cmd = 'lazygit',
  direction = 'float',
  hidden = true
})

vim.keymap.set('n', '<Space>g', function() lazygit:toggle() end)



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

-- TeleScope
vim.keymap.set('n', '<Space>tt', '<cmd>Telescope<CR>')
vim.keymap.set('n', '<Space>tf', '<cmd>Telescope fd<CR>')
vim.keymap.set('n', '<Space>tg', '<cmd>Telescope live_grep<CR>')

vim.keymap.set('n', '<Space>f', '<cmd>Neotree reveal<CR>')

-- Move focus
vim.keymap.set('n', '<Space>j', '<C-w>w')
vim.keymap.set('n', '<Space>k', '<C-w>W')

-- Hop.nvim
local hop = require('hop')
hop.setup {}

function hopword()
  local jump_target = require'hop.jump_target'

  local generator = jump_target.jump_targets_by_scanning_lines

  hop.hint_with(
    generator(jump_target.regex_by_searching([[\<\k\{-}\>]])),
    hop.opts
  )
end

vim.keymap.set('n', '<Space>hw', hopword)
vim.keymap.set('n', '<Space>hc', '<cmd>HopChar1<CR>')

-- Language servers

local lsp_set_keymap = function(client, bufnr)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<Space>lca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<Space>lrn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<Space>lf', vim.lsp.buf.formatting, opts)
end

local servers = { 'rust_analyzer', 'ocamllsp', 'eslint', 'prismals', 'pyright', 'rnix', 'dhall_lsp_server', 'astro', 'elmls' }
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
      client.server_capabilities.document_formatting = false
    end,
  }
end


-- Lua
require 'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT"
      },
      diagnostics = { globals = { 'vim' } }
    },
    workspace = { library = vim.api.nvim_get_runtime_file('', true) },
    telemetry = { enable = false }
  }
}


-- SATySFi
vim.cmd("autocmd BufNewFile,BufRead *.saty set filetype=satysfi")

-- F#
vim.g['fsharp#fsautocomplete_command'] = {
  'dotnet',
  'fsautocomplete',
}

vim.g['fsharp#lsp_auto_setup'] = 0

require('ionide').setup {
  on_attach = function(client, bufnr)
    lsp_set_keymap(client, bufnr)
  end,
}

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
local parser_config = require'nvim-treesitter.parsers'.get_parser_configs()
parser_config.satysfi = {
  install_info = {
    url = "https://github.com/monaqa/tree-sitter-satysfi",
    files = {"src/parser.c", "src/scanner.c"}
  },
  filetype = "satysfi"
}

require'nvim-treesitter.configs'.setup {
  autotag = {
    enable = true,
  },
  indent = {
    enable = true,
  },
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
    'astro',
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
    'satysfi',
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

require'transparent'.setup {
  enable = true
}

-- Indent guide

require'indent_blankline'.setup {
  show_current_context = true,
  show_current_context_start = true,
}

-- General configurations

vim.wo.number = true
vim.wo.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 0

-- Move cursor by display line

vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('n', '<Down>', 'gj')
vim.keymap.set('n', '<Up>', 'gk')
vim.keymap.set('i', '<Down>', '<C-o>gj')
vim.keymap.set('i', '<Up>', '<C-o>gk')

-- Cursor line highlight
vim.cmd('set cursorline')
vim.cmd('set cursorcolumn')

-- Open terminal in insert mode
vim.cmd('autocmd TermOpen * startinsert')
