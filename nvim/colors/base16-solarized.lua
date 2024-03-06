local palette

if vim.o.background == "light" then
  palette = {
    base00 = "#fdf6e3",
    base01 = "#eee8d5",
    base02 = "#93a1a1",
    base03 = "#839496",
    base04 = "#657b83",
    base05 = "#586e75",
    base06 = "#073642",
    base07 = "#002b36",
    base08 = "#dc322f",
    base09 = "#cb4b16",
    base0A = "#b58900",
    base0B = "#859900",
    base0C = "#2aa198",
    base0D = "#268bd2",
    base0E = "#6c71c4",
    base0F = "#d33682",
  }
end

if vim.o.background == "dark" then
  palette = {
    base00 = "#002b36",
    base01 = "#073642",
    base02 = "#586e75",
    base03 = "#657b83",
    base04 = "#839496",
    base05 = "#93a1a1",
    base06 = "#eee8d5",
    base07 = "#fdf6e3",
    base08 = "#dc322f",
    base09 = "#cb4b16",
    base0A = "#b58900",
    base0B = "#859900",
    base0C = "#2aa198",
    base0D = "#268bd2",
    base0E = "#6c71c4",
    base0F = "#d33682",
  }
end

if palette then
  require('mini.base16').setup({ palette = palette })
  vim.g.colors_name = 'base16-solarized'
  vim.cmd [[ highlight WinSeparator guibg=None ]]
end
