local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}

vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.format({ async = true })]]

