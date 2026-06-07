-- Serendipity Serendipity Sunset for Neovim
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end
vim.g.colors_name = 'serendipity-sunset'

local M = {}
function M.setup()
  vim.cmd('hi Normal guifg=#dee0ef guibg=#202231')
  vim.cmd('hi Cursor guifg=#d1918f guibg=#202231')
  vim.cmd('hi Visual guifg=#dee0ef guibg=#6B6D7C26')
  vim.cmd('hi LineNr guifg=#6b6d7c guibg=#202231')
  vim.cmd('hi CursorLineNr guifg=#dee0ef guibg=#202231 gui=bold')
  vim.cmd('hi CursorLine guibg=#6b6d7c1a')
  vim.cmd('hi Comment guifg=#8d8f9e gui=italic')
  vim.cmd('hi Constant guifg=#709bbd')
  vim.cmd('hi String guifg=#a392dc')
  vim.cmd('hi Identifier guifg=#d6b4b4 gui=italic')
  vim.cmd('hi Function guifg=#d1918f gui=italic')
  vim.cmd('hi Statement guifg=#709bbd')
  vim.cmd('hi Keyword guifg=#709bbd')
  vim.cmd('hi Operator guifg=#6b6d7c')
  vim.cmd('hi Type guifg=#a0b6e8')
  vim.cmd('hi Error guifg=#d1918f')
  vim.cmd('hi StatusLine guifg=#dee0ef guibg=#272938')
  vim.cmd('hi StatusLineNC guifg=#6b6d7c guibg=#202231')
  vim.cmd('hi Pmenu guifg=#dee0ef guibg=#272938')
  vim.cmd('hi PmenuSel guifg=#dee0ef guibg=#6B6D7C26')
  vim.cmd('hi @variable guifg=#d6b4b4 gui=italic')
  vim.cmd('hi @function guifg=#d1918f gui=italic')
  vim.cmd('hi @keyword guifg=#709bbd')
  vim.cmd('hi @type guifg=#a0b6e8')
  vim.cmd('hi @string guifg=#a392dc')
  vim.cmd('hi @comment guifg=#8d8f9e gui=italic')
end

M.setup()
return M
