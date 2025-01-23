vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      terminal_chan = nil
    end
  end,
})

local terminal_bufnr = nil

local function open_terminal_split()
  if terminal_bufnr == nil or not vim.api.nvim_buf_is_valid(terminal_bufnr) then
    local total_lines = vim.api.nvim_win_get_height(0)
    local terminal_height = math.floor(total_lines * 30 / 100)
    vim.cmd('botright ' .. terminal_height .. 'split | terminal')

    terminal_bufnr = vim.api.nvim_get_current_buf()

    vim.bo[terminal_bufnr].modifiable = false
    vim.wo.number = false
    vim.wo.relativenumber = false
  else
    -- Check if terminal buffer is visible in the current tab
    local win_found = false
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_buf(win) == terminal_bufnr then
        win_found = true
        vim.api.nvim_set_current_win(win)
        break
      end
    end

    -- Open a split if the terminal buffer is not visible
    if not win_found then
      local total_lines = vim.api.nvim_win_get_height(0)
      local terminal_height = math.floor(total_lines * 30 / 100)
      vim.cmd('botright ' .. terminal_height .. 'split')
      vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), terminal_bufnr)
    end
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
  local chan = vim.api.nvim_buf_get_option(terminal_bufnr, 'channel')

  if (is_test_file == nil) then
    vim.api.nvim_chan_send(chan, "#you are not in a test file\n")
    return
  end

  vim.api.nvim_chan_send(chan, command)
end

vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>t', run_current_test_file)
-- Create a keymap for Enter key to open terminal split, excluding quickfix windows and NERDTree
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local buftype_is_not_quickfix = vim.bo.buftype ~= 'quickfix'
    local filetype_is_not_nerdtree = vim.bo.filetype ~= 'nerdtree'

    if buftype_is_not_quickfix and filetype_is_not_nerdtree then
      vim.keymap.set('n', '<CR>', open_terminal_split, { buffer = true })
    end
  end,
})
