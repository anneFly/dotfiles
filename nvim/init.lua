vim.opt.mouse = "a"

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.showmatch = true

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.wildmode = "list:longest,full"
vim.opt.completeopt = "longest,menuone"

-- fileencodings ???

vim.opt.foldmethod = "marker"
vim.opt.foldlevelstart = 99

vim.opt.tags:append(".tags")

vim.opt.undofile = true

vim.opt.clipboard = "unnamedplus"

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.cmd.syntax 'on'
vim.cmd.colorscheme 'onehalflight'

vim.cmd.filetype 'on'
vim.cmd.filetype 'plugin on'
vim.cmd.filetype 'indent on'

vim.api.nvim_create_autocmd('FileType', {pattern = 'python', command = 'setl colorcolumn=99'})
vim.api.nvim_create_autocmd('FileType', {pattern = 'python', command = ':iabbrev pdb import pdb; pdb.set_trace()'})
vim.api.nvim_create_autocmd('FileType', {pattern = 'javascript,javascriptreact,typescript,typescriptreact', command = 'setl tabstop=2 softtabstop=2 shiftwidth=2'})
vim.api.nvim_create_autocmd('FileType', {pattern = 'html,htmldjango', command = 'setl tabstop=2 softtabstop=2 shiftwidth=2'})

-- python indentation
vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'

-- diagnostics
vim.diagnostic.config({
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  }
})
vim.keymap.set('n', '<space>e', ':lua vim.diagnostic.open_float(0, {scope="line"})<CR>')

-- Plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
--Plug 'williamboman/mason.nvim'
--Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', {tag = '0.1.8'})
Plug 'preservim/nerdtree'
Plug 'neovim/nvim-lspconfig'
Plug 'prettier/vim-prettier'
Plug 'zbirenbaum/copilot.lua'
vim.call('plug#end')

-- nerdtree
vim.g.NERDTreeShowHidden = 1
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>')

-- telescope
local builtin = require('telescope.builtin')
-- file search
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
-- fuzzy search using ripgrep and telescope
vim.api.nvim_create_user_command(
  'RG',
  function(opts)
    builtin.live_grep()
  end,
  {nargs = '*'}
)
-- fuzzy search without migrations
vim.api.nvim_create_user_command(
  'RGNM',
  function(opts)
    builtin.live_grep({glob_pattern = '!migrations'})
  end,
  {nargs = '*'}
)

-- fuzzy search with glob
vim.api.nvim_create_user_command(
  'RGG',
  function(opts)
    builtin.live_grep({glob_pattern = opts.fargs[1]})
  end,
  {nargs = 1}
)

-- lspconfig
require('lsp')

-- vim-prettier
vim.api.nvim_set_var('prettier#autoformat', 0)
-- run Prettier only on defined filetypes:
vim.api.nvim_create_autocmd('BufWritePre',	{ group = Prettier, pattern = {"*.js", "*.jsx", "*.mjs", "*.cjs", "*.ts", "*.tsx", "*.css", "*.less", "*.scss", "*.json", "*.graphql", "*.gql", "*.vue", "*.svelte"}, buffer = bufnr, callback = function() vim.call('prettier#Prettier') end })

-- copilot
require('copilot').setup({
  panel = { enabled = false },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = '<C-y>',
      next = '<C-l>',
      prev = '<C-L>',
      dismiss = '<C-]>',
    },
  },
  filetypes = {
    ['*'] = true,
  },
})

-- GitHub blame
require('utils.github')

-- Harper utils
require('utils.harper')
