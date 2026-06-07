-- Serendipity Serendipity Midnight for Neovim
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'serendipity-midnight'

local M = {}
function M.setup()
  vim.cmd('hi Normal guifg=#dee0ef guibg=#151726')
  vim.cmd('hi Cursor guifg=#d1918f guibg=#151726')
  vim.cmd('hi Visual guifg=#dee0ef guibg=#6B6D7C33')
  vim.cmd('hi LineNr guifg=#8d8f9e guibg=#151726')
  vim.cmd('hi CursorLineNr guifg=#dee0ef guibg=#151726 gui=bold')
  vim.cmd('hi CursorLine guibg=#8d8f9e1a')
  vim.cmd('hi Comment guifg=#6b6d7c gui=italic')
  vim.cmd('hi Constant guifg=#5ba2d0')
  vim.cmd('hi String guifg=#a78bfa')
  vim.cmd('hi Identifier guifg=#f8d2c9 gui=italic')
  vim.cmd('hi Function guifg=#ee8679 gui=italic')
  vim.cmd('hi Statement guifg=#5ba2d0')
  vim.cmd('hi Keyword guifg=#5ba2d0')
  vim.cmd('hi Operator guifg=#8d8f9e')
  vim.cmd('hi Type guifg=#94b8ff')
  vim.cmd('hi Error guifg=#ee8679')
  vim.cmd('hi StatusLine guifg=#dee0ef guibg=#1c1e2d')
  vim.cmd('hi StatusLineNC guifg=#8d8f9e guibg=#151726')
  vim.cmd('hi Pmenu guifg=#dee0ef guibg=#1c1e2d')
  vim.cmd('hi PmenuSel guifg=#dee0ef guibg=#6B6D7C33')
  vim.cmd('hi @variable guifg=#f8d2c9 gui=italic')
  vim.cmd('hi @function guifg=#ee8679 gui=italic')
  vim.cmd('hi @keyword guifg=#5ba2d0')
  vim.cmd('hi @type guifg=#94b8ff')
  vim.cmd('hi @string guifg=#a78bfa')
  vim.cmd('hi @comment guifg=#6b6d7c gui=italic')
end

M.setup()
return M
