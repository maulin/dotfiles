vim.keymap.set('n', '<leader>w', ':set invwrap<cr>')
vim.keymap.set('n', '<leader>p', ':set invpaste<cr>')

-- Move between splits

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Move between tabs

vim.keymap.set('n', '<S-l>',  'gt')
vim.keymap.set('n', '<S-h>', 'gT')

-- Resize window splits

vim.keymap.set('n', '<Up>',    '3<C-w>+')
vim.keymap.set('n', '<Down>',  '3<C-w>-')
vim.keymap.set('n', '<Left>',  '3<C-w>>')
vim.keymap.set('n', '<Right>', '3<C-w><')

-- Telescope

local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fw', telescope.grep_string, { desc = 'Telescope grep string' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescope.oldfiles, { desc = 'Telescope history' })

-- NerdTree

vim.NERDTreeShowHidden = 1
vim.keymap.set('n', '<C-g>', ':NERDTreeToggle<cr>')
vim.keymap.set('n', '<C-f>', ':NERDTreeFind<cr>')

vim.keymap.set('v', 's', ':sort!<cr>')
vim.keymap.set('n', ',,', '<C-^>')

-- Set a mark and come back to it after J so the cursor doesn't move
vim.keymap.set('n', 'J', 'mzJ`z')

-- Move lines that are visually selected
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Indent current buffer
vim.keymap.set('n', '<Space>fi', 'mmgg=G`m', opts)

-- Remove trailing whitespace when a buffer is written
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = "%s/\\s\\+$//e"
})
