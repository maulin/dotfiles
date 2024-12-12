local terminal_chan = nil

vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      terminal_chan = nil
    end
  end,
})

local function open_terminal_split()
  if (terminal_chan == nil) then
    local total_lines = vim.api.nvim_win_get_height(0)
    local terminal_height = math.floor(total_lines * 30 / 100)
    vim.cmd('botright ' .. terminal_height .. 'split | terminal')

    local bufnr = vim.api.nvim_get_current_buf()
    terminal_chan = vim.bo.channel

    vim.bo[bufnr].modifiable = false
    vim.wo.number = false
    vim.wo.relativenumber = false
  end
end

local function run_current_test_file()
  local path = vim.fn.expand('%')
  local filename = vim.fn.expand('%:t')
  local is_test_file = string.match(filename, ".+_test%.rb") or
    string.match(filename, ".+_test%.ts") or
    string.match(filename, ".+_test%.js")
  local command = "dev test " .. path .. "\n"
  local current_window = vim.api.nvim_get_current_win()

  open_terminal_split()
  vim.api.nvim_set_current_win(current_window)

  if (is_test_file == nil) then
    vim.api.nvim_chan_send(terminal_chan, "#you are not in a test file\n")
    return
  end

  vim.api.nvim_chan_send(terminal_chan, command)
end

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<CR>', open_terminal_split)
vim.keymap.set('n', '<leader>t', run_current_test_file)
