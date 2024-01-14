vim.opt.exrc = true

vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0

vim.opt.cursorline = true
vim.opt.termguicolors = true

vim.opt.laststatus = 3
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.wrap = false

vim.opt.background = 'light'
vim.cmd.colorscheme "lunaperche"
vim.cmd [[ :set statusline=%<%f\ %h%m%r%{FugitiveStatusline()}%=%-14.(%l,%c%V%)\ %P ]]
vim.opt.winbar = "%n) %t"

vim.cmd ([[ set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case ]])

vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "L", "g_", { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.cmd([[ command! -nargs=+ Grep execute 'silent grep! <args>' | copen ]])

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>f",  ":find ", { noremap = true })
vim.keymap.set("n", "<leader>/",  ":Grep ", { noremap = true })

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})


require'nvim-treesitter.configs'.setup {
  enable = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },

  ensure_installed = "python",

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<A-o>",
      node_incremental = "<A-o>",
      node_decremental = "<A-i>",
    },
  },
}

vim.cmd([[ au TextYankPost * silent! lua vim.highlight.on_yank() ]])
