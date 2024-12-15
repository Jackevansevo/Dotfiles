local hues = require('mini.hues')

if vim.o.background == 'dark' then
  hues.setup({
    background = '#282c34',
    foreground = '#ffffff',
    n_hues = 8,
    saturation = 'medium',
    accent = 'bg',
  })
else
  hues.setup({
    background = '#f8f8f8',
    foreground = '#585858',
    n_hues = 8,
    saturation = 'high',
    accent = 'bg',
  })
end

vim.g.colors_name = 'default'
