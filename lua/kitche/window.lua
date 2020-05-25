local buffers = require "kitche/buffer".buffers

local M = {}

M.open = function(bufnr)
  local width = 80
  local height = 20
  local row = vim.o.lines / 2 - (height / 2)
  local col = vim.o.columns / 2 - (width / 2)
  local id =
    vim.api.nvim_open_win(
    bufnr,
    true,
    {
      relative = "editor",
      width = width,
      height = height,
      row = row,
      col = col,
      anchor = "NW",
      focusable = true,
      external = false
    }
  )
  vim.api.nvim_win_set_option(id, "cursorline", true)
  vim.api.nvim_win_set_option(id, "winhighlight", "CursorLine:KitcheCursorLine")
end

local close_window = function(id)
  if id == "" then
    return
  end
  if not vim.api.nvim_win_is_valid(id) then
    return
  end
  vim.api.nvim_win_close(id, true)
end

M.close = function()
  local ids = vim.api.nvim_tabpage_list_wins(0)
  for _, id in ipairs(ids) do
    local bufnr = vim.fn.winbufnr(id)
    if buffers.exists(bufnr) then
      close_window(id)
    end
  end
end

return M
