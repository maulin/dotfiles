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
    vim.cmd('botright terminal')

    vim.bo[0].modifiable = false
    vim.wo.number = false
    terminal_chan = vim.bo.channel
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

vim.keymap.set('n', '<CR>', open_terminal_split)
vim.keymap.set('n', '<leader>t', run_current_test_file)
