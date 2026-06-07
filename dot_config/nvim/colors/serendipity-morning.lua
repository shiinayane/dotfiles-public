-- Serendipity Serendipity Morning for Neovim
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'serendipity-morning'

local M = {}
function M.setup()
  vim.cmd('hi Normal guifg=#3f4363 guibg=#f6f7fb')
  vim.cmd('hi Cursor guifg=#6d7296 guibg=#f6f7fb')
  vim.cmd('hi Visual guifg=#3f4363 guibg=#5a567018')
  vim.cmd('hi LineNr guifg=#505575 guibg=#f6f7fb')
  vim.cmd('hi CursorLineNr guifg=#3f4363 guibg=#f6f7fb gui=bold')
  vim.cmd('hi CursorLine guibg=#5055751a')
  vim.cmd('hi Comment guifg=#6d7296 gui=italic')
  vim.cmd('hi Constant guifg=#2f7aab')
  vim.cmd('hi String guifg=#785fd0')
  vim.cmd('hi Identifier guifg=#e58678 gui=italic')
  vim.cmd('hi Function guifg=#c25a4d gui=italic')
  vim.cmd('hi Statement guifg=#2f7aab')
  vim.cmd('hi Keyword guifg=#2f7aab')
  vim.cmd('hi Operator guifg=#505575')
  vim.cmd('hi Type guifg=#6288d8')
  vim.cmd('hi Error guifg=#c25a4d')
  vim.cmd('hi StatusLine guifg=#3f4363 guibg=#eaebee')
  vim.cmd('hi StatusLineNC guifg=#505575 guibg=#f6f7fb')
  vim.cmd('hi Pmenu guifg=#3f4363 guibg=#eaebee')
  vim.cmd('hi PmenuSel guifg=#3f4363 guibg=#5a567018')
  vim.cmd('hi @variable guifg=#e58678 gui=italic')
  vim.cmd('hi @function guifg=#c25a4d gui=italic')
  vim.cmd('hi @keyword guifg=#2f7aab')
  vim.cmd('hi @type guifg=#6288d8')
  vim.cmd('hi @string guifg=#785fd0')
  vim.cmd('hi @comment guifg=#6d7296 gui=italic')
end

M.setup()
return M
