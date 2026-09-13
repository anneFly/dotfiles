local lsp_formatting = vim.api.nvim_create_augroup("LspFormatting", {})
local on_attach = function(_, bufnr)
	vim.api.nvim_create_autocmd('BufWritePre',	{ group = lsp_formatting, buffer = bufnr, callback = function() vim.lsp.buf.format() end })
end

-- pip install python-lsp-server
-- pip install python-lsp-ruff
-- pip install pylsp-mypy

vim.lsp.config("pylsp", {
  on_attach = on_attach,
  settings = {
    pylsp = {
      plugins = {
        pylsp_mypy = {
          enabled = true,
          live_mode = false,
          dmypy = true,
          report_progress = true,
        },
        ruff = {
          enabled = true,
          formatEnabled = true
        },
        pyflakes = {
          enabled = false
        },
        pycodestyle = {
          enabled = false,
        }
      }
    }
  }
})

-- npm install -g typescript typescript-language-server
vim.lsp.config("ts_ls", {})

-- spell checker
vim.lsp.config("harper_ls", {
  settings = {
    ["harper-ls"] = {
      linters = {
        SentenceCapitalization = false,
      },
    }
  }
})

vim.lsp.enable({ "pylsp", "ts_ls", "harper_ls" })

-- openapi linting
vim.filetype.add {
  pattern = {
    ['openapi.*%.ya?ml'] = 'yaml.openapi',
    ['openapi.*%.json'] = 'json.openapi',
  },
}
--require('lspconfig').vacuum.setup({
--  cmd = {
--    "vacuum", "language-server",
--    "--ruleset", "./vacuum.conf.yaml"
--    }
--})
vim.lsp.enable('vacuum')


-- Mason setup must come first
-- require("mason").setup()
-- 
-- require("mason-lspconfig").setup({
--   ensure_installed = {
--     "pylsp",           
--     "ruff",            
--     "ts_ls",           
--   },
--   automatic_installation = true,
-- })
-- 
-- local pylsp = require("mason-registry").get_package("python-lsp-server")
-- 
-- pylsp:on("install:success", function ()
--   vim.fn.system({
--         "~/.local/share/nvim/mason/packages/python-lsp-server/venv/bin/python",
--         "-m",
--         "pip",
--         "install",
--         "pylsp-mypy",
--         "python-lsp-ruff",
--     })
-- end)
-- 
-- 
-- -- Shared on_attach: keymaps available in any LSP buffer
-- local on_attach = function(_, bufnr)
--   local opts = { buffer = bufnr, noremap = true, silent = true }
--   vim.keymap.set("n", "gd",         vim.lsp.buf.definition,   opts)
--   vim.keymap.set("n", "K",          vim.lsp.buf.hover,        opts)
--   vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,       opts)
--   vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,  opts)
--   vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev, opts)
--   vim.keymap.set("n", "]d",         vim.diagnostic.goto_next, opts)
-- end
-- 
-- -- Python
-- -- pip install python-lsp-server
-- -- pip install python-lsp-ruff
-- -- pip install pylsp-mypy
-- vim.lsp.config("pylsp", {
--   on_attach = on_attach,
--   settings = {
--     pylsp = {
--       plugins = {
--         pylsp_mypy = {
--           enabled = true,
--           live_mode = false,
--           dmypy = true,
--           report_progress = true,
--         },
--         ruff = {
--           enabled = true,
--           formatEnabled = true
--         },
--         pyflakes = {
--           enabled = false
--         },
--         pycodestyle = {
--           enabled = false,
--         }
--       }
--     }
--   }
-- })
-- 
-- -- TypeScript / JavaScript
-- vim.lsp.config("ts_ls", {
--   on_attach = on_attach,
-- })
-- 
-- -- kotlin language server
-- vim.lsp.config("kotlin_language_server", {
--   filetypes = { "kotlin" , "kt", "kts"},
--   cmd = { os.getenv( "HOME" ) .. "/lsps/kotlin-language-server/server/build/install/server/bin/kotlin-language-server" },
-- })
-- 
-- 
-- -- spell checker
-- vim.lsp.config("harper_ls", {
--   settings = {
--     ["harper-ls"] = {
--       linters = {
--         SentenceCapitalization = false,
--       },
--     }
--   }
-- })
-- 
-- vim.lsp.enable({ "pylsp", "ts_ls", "harper_ls", "kotlin_language_server" })
