local palette

if vim.o.background == "light" then
  palette = {
    base00 = "#efecf4",
    base01 = "#e2dfe7",
    base02 = "#8b8792",
    base03 = "#7e7887",
    base04 = "#655f6d",
    base05 = "#585260",
    base06 = "#26232a",
    base07 = "#19171c",
    base08 = "#be4678",
    base09 = "#aa573c",
    base0A = "#a06e3b",
    base0B = "#2a9292",
    base0C = "#398bc6",
    base0D = "#576ddb",
    base0E = "#955ae7",
    base0F = "#bf40bf",
  }
end

if vim.o.background == "dark" then
  palette = {
    base00 = "#19171c",
    base01 = "#26232a",
    base02 = "#585260",
    base03 = "#655f6d",
    base04 = "#7e7887",
    base05 = "#8b8792",
    base06 = "#e2dfe7",
    base07 = "#efecf4",
    base08 = "#be4678",
    base09 = "#aa573c",
    base0A = "#a06e3b",
    base0B = "#2a9292",
    base0C = "#398bc6",
    base0D = "#576ddb",
    base0E = "#955ae7",
    base0F = "#bf40bf",
  }
end

if palette then
  require('mini.base16').setup({ palette = palette })
  vim.g.colors_name = 'base16-atelier-cave'
  vim.cmd [[ highlight WinSeparator guibg=None ]]
end
