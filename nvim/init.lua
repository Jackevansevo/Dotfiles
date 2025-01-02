local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })
local add = MiniDeps.add

add({
  source = 'nvim-treesitter/nvim-treesitter',
  -- Use 'master' while monitoring updates in 'main'
  checkout = 'master',
  monitor = 'main',
  -- Perform action after every checkout
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
add('neovim/nvim-lspconfig')
add('radenling/vim-dispatch-neovim')
add('tartansandal/vim-compiler-pytest')
add('tpope/vim-dispatch')
add('tpope/vim-fireplace')
add('tpope/vim-fugitive')
add('tpope/vim-rhubarb')
add('catppuccin/nvim')
add('lewis6991/gitsigns.nvim')
add('janet-lang/janet.vim')

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'vimdoc', 'python' },
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<M-o>",
      node_incremental = "<M-o>",
      node_decremental = "<M-i>",
    },
  },
})

vim.opt.exrc = true

vim.cmd([[
  let g:dispatch_no_job_make = 1
  let g:dispatch_no_tmux_make = 1
]])

require('gitsigns').setup()

require('mini.ai').setup()
require('mini.basics').setup({options = {extra_ui = true}})
require('mini.bracketed').setup()
require('mini.completion').setup()
require('mini.icons').setup()
require('mini.jump').setup()
require('mini.jump2d').setup()
require('mini.misc').setup()
require('mini.move').setup()
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.starter').setup()
require('mini.statusline').setup()
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.trailspace').setup()

misc = require('mini.misc')
misc.setup_restore_cursor()
misc.setup_termbg_sync()

require("catppuccin").setup({ no_italic = true })

vim.cmd.colorscheme "catppuccin"

-- vim.o.number = false
vim.o.laststatus = 3

require('mini.hipatterns').setup({
  highlighters = {
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    hack  = { pattern = 'HACK',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = 'TODO',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = 'NOTE',  group = 'MiniHipatternsNote'  },
  }
})

local pick = require('mini.pick')
pick.setup()

local files = require('mini.files')
files.setup()

vim.keymap.set("n", "-", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

vim.keymap.set("n", "<leader>f",  pick.builtin.files, { noremap = true })
vim.keymap.set("n", "<leader>b",  pick.builtin.buffers, { noremap = true })
vim.keymap.set("n", "<leader>/",  pick.builtin.grep, { noremap = true })
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })


vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "L", "g_", { noremap = true, silent = true })
vim.keymap.set("v", "gy", '"+y', { noremap = true, silent = true })

local bufremove = require('mini.bufremove')
bufremove.setup()

-- bc 'buffer close' variant of :bd deletes the buffer without closing the window
vim.api.nvim_create_user_command('BC', function() bufremove.delete(0, true) end, {})
vim.cmd('cnoreabbrev bc BC')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
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

vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

local lspconfig = require('lspconfig')
lspconfig.jedi_language_server.setup{ init_options = { diagnostics =  { enabled = false }, completion = { disableSnippets = true }}}
lspconfig.ruff.setup{}

-- vim.api.nvim_create_autocmd('FileType', {
--   -- This handler will fire when the buffer's 'filetype' is "python"
--   pattern = 'python',
--   callback = function(args)
--     vim.lsp.start({
--       cmd = { "mypy-lsp-wrapper" },
--       root_dir = vim.fn.getcwd(),
--     })
--   end,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.py",
  callback = function()
    vim.lsp.buf.code_action({
      context = {
        only = {
          "source.fixAll.ruff"
        },
      },
      apply = true,
    })
    vim.lsp.buf.format({ async = false })
  end,
})
