vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

gitsigns_config = {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

require("lazy").setup({
  "HiPhish/rainbow-delimiters.nvim",
  {
    "lewis6991/gitsigns.nvim",
    opts = gitsigns_config,
  },
  "neovim/nvim-lspconfig",
  "nvim-treesitter/nvim-treesitter",
  "radenling/vim-dispatch-neovim",
  "romainl/vim-qf",
  "tartansandal/vim-compiler-pytest",
  "tpope/vim-dispatch",
  "tpope/vim-fireplace",
  "tpope/vim-fugitive",
  "echasnovski/mini.nvim"
})

require('mini.ai').setup({})
require('mini.align').setup({})
require('mini.basics').setup({
  options = {
    basic = true,
    extra_ui = true,
    win_borders = 'single',
  }
})
require('mini.bracketed').setup({})
require('mini.bufremove').setup({})
require('mini.comment').setup({})
require('mini.completion').setup({})
require('mini.cursorword').setup({})
require('mini.files').setup({})
require('mini.jump').setup({})
require('mini.jump2d').setup({})
require('mini.move').setup({})
require('mini.operators').setup({})
require('mini.pairs').setup({})
require('mini.sessions').setup({})
require('mini.splitjoin').setup({})
require('mini.starter').setup({})
require('mini.statusline').setup({ set_vim_settings = false })
require('mini.surround').setup({})
require('mini.tabline').setup({})
require('mini.test').setup({})
require('mini.trailspace').setup({})

vim.opt.exrc = true
vim.opt.number = false
vim.opt.laststatus = 3

vim.opt.background = "light"
vim.cmd("colorscheme macvim")

vim.cmd ([[ set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case ]])

vim.cmd([[
    let g:loaded_ruby_provider = 0
    let g:loaded_node_provider = 0
    let g:loaded_perl_provider = 0
    let g:python3_host_prog = '$PYENV_ROOT/versions/py3nvim/bin/python'
]])

vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true })
vim.keymap.set("v", "L", "g_", { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

vim.cmd([[ command! -nargs=+ Grep execute 'silent grep! <args>' | copen ]])

vim.cmd([[ cnoreabbrev <expr> bc 'lua MiniBufremove.delete()' ]])

vim.keymap.set('n', '<leader>f', ':find ', {})
vim.keymap.set('n', '<leader>/', ':Grep ', {})
vim.keymap.set('n', '-', ':lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>', {})

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
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})


require'nvim-treesitter.configs'.setup {
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
