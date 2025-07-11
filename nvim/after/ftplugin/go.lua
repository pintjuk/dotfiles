-- vim.keymap.set("n", "<leader>td", function()
-- 	require("dap-go").debug_test()
-- end, {
-- 	buffer = 0,
-- 	desc = '[T]est [D]ebug',
-- }) n


function UncommentBlockComment()
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  while node do
    if node:type() == 'comment' then
      local start_row, start_col, end_row, end_col = node:range()
      local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row + 1, false)

      -- Remove /* from the start, */ from the end
      if #lines > 0 then
        lines[1] = lines[1]:gsub("^%s*/%*", "", 1)          -- strip /* at start
        lines[#lines] = lines[#lines]:gsub("%*/%s*$", "", 1) -- strip */ at end
        vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, lines)
        print("Uncommented block comment")
        return
      end
    end
    node = node:parent()
  end
  print("Not inside a block comment")
end

vim.keymap.set('n', 'gc', UncommentBlockComment, { noremap = true, silent = true, desc = "Uncomment block comment if inside" })

