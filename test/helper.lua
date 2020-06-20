local M = {}

M.root = vim.fn.getcwd()
M.test_data_dir = M.root .. "/test/_test_data/"

M.command = function(cmd)
  vim.api.nvim_command(cmd)
end

M.before_each = function()
  vim.api.nvim_set_current_dir(M.test_data_dir)
  M.command("filetype on")
  M.command("syntax enable")
end

M.after_each = function()
  M.command("tabedit")
  M.command("tabonly!")
  M.command("silent! %bwipeout!")
  M.command("filetype off")
  M.command("syntax off")
  print(" ")

  -- NOTE: for require("test.helper")
  vim.api.nvim_set_current_dir(M.root)
end

M.search = function(pattern)
  local result = vim.fn.search(pattern)
  if result == 0 then
    local msg = string.format("%s not found", pattern)
    assert(false, msg)
  end
  return result
end

M.set_lines = function(lines)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(lines, "\n"))
end

local assert = require("luassert")
local AM = assert

AM.window_count = function(expected)
  local actual = vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
  local msg = string.format("window count must be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.filetype = function(expected)
  local actual = vim.bo.filetype
  local msg = string.format("buffer &filetype should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.file_name = function(expected)
  local actual = vim.fn.fnamemodify(vim.fn.bufname("%"), ":t")
  local msg = string.format("file name should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.current_line = function(expected)
  local actual = vim.fn.getline(".")
  local msg = string.format("current line should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.found = function(pattern)
  local result = vim.fn.search(pattern, "nw")
  local msg = string.format('"%s" should be found, but not found', pattern)
  assert.are_not.equals(result, msg)
end

AM.not_found = function(pattern)
  local result = vim.fn.search(pattern, "nw")
  local msg = string.format('"%s" should not be found, but found at line: %s', pattern, result)
  assert.equals(0, result, msg)
end

AM.buftype = function(expected)
  local actual = vim.bo.buftype
  local msg = string.format("buftype should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.tab_count = function(expected)
  local actual = vim.fn.tabpagenr("$")
  local msg = string.format("tab count should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.line_count = function(expected)
  local actual = vim.fn.line("$")
  local msg = string.format("line count should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

AM.lines = function(expected)
  local actual = table.concat(vim.fn.getbufline("%", 0, "$"), "\n")
  local msg = string.format("lines should be %s, but actual: %s", expected, actual)
  assert.equals(expected, actual, msg)
end

M.assert = AM

return M
