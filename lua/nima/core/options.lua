vim.cmd("let g:netrw_liststyle = 3")
local opt = vim.opt
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.relativenumber = true
opt.autoindent = true
opt.expandtab = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.termguicolors = true
opt.background = "dark"
opt.clipboard:append("unnamedplus")
opt.splitright = true
opt.splitbelow = true
opt.completeopt = {'menuone', 'noselect', 'noinsert'}
opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

