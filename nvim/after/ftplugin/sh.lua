function RunBashInPopup()
  local file_path = vim.fn.expand("%")

  -- Make sure the file has execute permissions
  vim.fn.system("chmod +x " .. vim.fn.shellescape(file_path))

  -- Create a new buffer and open it in a floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = math.floor(vim.o.columns * 0.8),
    height = math.floor(vim.o.lines * 0.6),
    row = math.floor(vim.o.lines * 0.2),
    col = math.floor(vim.o.columns * 0.1),
    style = "minimal",
    border = "rounded",
  })

  -- Open the terminal and run the file
  vim.fn.termopen("bash " .. vim.fn.shellescape(file_path))

  -- Make sure we enter insert mode for interaction
  vim.cmd("startinsert")

  -- Bind <leader>x to close the terminal buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "<leader>x", ":bd<CR>", { noremap = true, silent = true })
  
  -- Prevent terminal buffer from closing on any key press by manually starting insert mode
  -- Set the terminal buffer to interactively handle inputs without closing
  vim.api.nvim_buf_set_option(buf, 'buftype', 'terminal')
  vim.api.nvim_buf_set_option(buf, 'filetype', 'bash')
end

vim.api.nvim_set_keymap("n", "<leader>r", ":lua RunBashInPopup()<CR>", { noremap = true, silent = true })
