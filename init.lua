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
vim.api.nvim_create_autocmd('FileType', {pattern = 'javascript,javascriptreact,typescript,typescriptreact', command = 'setl tabstop=2 softtabstop=2 shiftwidth=2'})
vim.api.nvim_create_autocmd('FileType', {pattern = 'html,htmldjango', command = 'setl tabstop=2 softtabstop=2 shiftwidth=2'})

-- python indentation
vim.g.pyindent_open_paren = 'shiftwidth()'
vim.g.pyindent_continue = 'shiftwidth()'

-- Plug
local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', {tag = '0.1.8'})
Plug 'preservim/nerdtree'
Plug 'neovim/nvim-lspconfig'
vim.call('plug#end')

-- nerdtree
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
    print(opts.fargs)
    builtin.live_grep({glob_pattern = opts.fargs[1]})
  end,
  {nargs = 1}
)

-- lspconfig
local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(_, bufnr)
	vim.api.nvim_create_autocmd('BufWritePre',	{ group = lsp_formatting, buffer = bufnr, callback = function() vim.lsp.buf.format() end })
end

-- pip install python-lsp-server
-- pip install python-lsp-ruff
-- pip install pylsp-mypy
require'lspconfig'.pylsp.setup{
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pylsp_mypy = {
          enabled = true,
          live_mode = false,
          dmypy = true,
          report_progress = true
        },
        ruff = {
          enabled = true,
          formatEnabled = true
        },
        pyflakes = {
          enabled = false
        },
        pycodestyle = {
          enabled = false
          --ignore = {'W503', 'E701', 'E704', 'E203'},
          --maxLineLength = 100
        }
      }
    }
  }
}
