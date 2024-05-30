local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
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
add('tartansandal/vim-compiler-pytest')
add('tpope/vim-fugitive')
add('tpope/vim-rhubarb')
add('github/copilot.vim')

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'vimdoc', 'python' },
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<A-o>",
      node_incremental = "<A-o>",
      node_decremental = "<A-i>",
    },
  },
})

vim.o.background = 'light'
vim.cmd 'colorscheme base16-solarized'

vim.opt.exrc = true

require('mini.ai').setup({})
require('mini.basics').setup({
  options = {
    extra_ui = true,
  },
})
require('mini.bracketed').setup()
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.diff').setup()
require('mini.jump').setup()
require('mini.jump2d').setup()
require('mini.move').setup()
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.starter').setup()
require('mini.statusline').setup({ use_icons = false })
require('mini.surround').setup()
require('mini.tabline').setup()
require('mini.trailspace').setup()

vim.opt.laststatus = 3

vim.cmd [[ highlight WinSeparator guibg=None ]]

require('mini.hipatterns').setup({
  highlighters = {
    fixme = { pattern = 'FIXME', group = 'MiniHipatternsFixme' },
    hack  = { pattern = 'HACK',  group = 'MiniHipatternsHack'  },
    todo  = { pattern = 'TODO',  group = 'MiniHipatternsTodo'  },
    note  = { pattern = 'NOTE',  group = 'MiniHipatternsNote'  },
  }
})

local pick = require('mini.pick')
pick.setup({ source = { show = pick.default_show } })

local files = require('mini.files')
files.setup({ content = { prefix = function() end } })

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

vim.cmd([[
function! s:Camelize(range) abort
  if a:range == 0
    s#\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2#g
  else
    s#\%V\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)\%V#\u\1\2#g
  endif
endfunction

function! s:Snakeize(range) abort
  if a:range == 0
    s#\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2#g
  else
    s#\%V\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)\%V#\l\1_\l\2#g
  endif
endfunction

command! -range CamelCase silent! call <SID>Camelize(<range>)
command! -range SnakeCase silent! call <SID>Snakeize(<range>)
]])
