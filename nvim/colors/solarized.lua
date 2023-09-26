require('mini.base16').setup({
  palette = {
    base00 = '#fdf6e3',
    base01 = '#eee8d5',
    base02 = '#93a1a1',
    base03 = '#839496',
    base04 = '#657b83',
    base05 = '#586e75',
    base06 = '#073642',
    base07 = '#002b36',
    base08 = '#dc322f',
    base09 = '#cb4b16',
    base0A = '#b58900',
    base0B = '#859900',
    base0C = '#2aa198',
    base0D = '#268bd2',
    base0E = '#6c71c4',
    base0F = '#d33682',
  },
})


vim.cmd([[
hi WinSeparator guibg=NONE
hi StatusLine guibg=#eee8d5

hi MiniTablineCurrent guibg=#eee8d5 guifg=black gui=bold term=bold cterm=bold
hi MiniTablineVisible guibg=#eee8d5 guifg=#586e75 gui=NONE term=NONE cterm=NONE
hi MiniTablineHidden guibg=#eee8d5 guifg=#586e75 gui=NONE term=NONE cterm=NONE
hi MiniTablineModifiedCurrent guibg=#eee8d5 guifg=#586e75 gui=NONE term=NONE cterm=NONE
hi MiniTablineModifiedVisible guibg=#eee8d5 guifg=#586e75 gui=NONE term=NONE cterm=NONE
hi MiniTablineModifiedHidden guibg=#eee8d5 guifg=#586e75 gui=NONE term=NONE cterm=NONE

]])

