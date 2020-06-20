local stores = require "kitche/store".stores

local M = {}

local Buffer = function(store, bufnr)
  return {
    store = store,
    bufnr = bufnr,
    render = function(range)
      local lines = store.load(range)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, true, lines)
    end
  }
end

local buffers = {}

buffers.store_name = function(bufnr)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  return string.match(filetype, "kitche%-(%w+)")
end

buffers.exists = function(bufnr)
  return buffers.store_name(bufnr) ~= nil
end

buffers.find = function(bufnr)
  local name = buffers.store_name(bufnr)
  local store = stores.find(name)
  if store == nil then
    return nil
  end
  return Buffer(store, bufnr)
end

buffers.get_or_create = function(store)
  local filetype = ("kitche-%s"):format(store.name)
  local name = ("%s://%s"):format(filetype, store.id)

  local pattern = ("^%s$"):format(name)
  local bufnr = vim.fn.bufnr(pattern)
  if bufnr == -1 then
    bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, name)
    vim.api.nvim_buf_set_option(bufnr, "filetype", filetype)

    local on_read =
      ("autocmd BufReadCmd <buffer=%s> lua require 'kitche/buffer'.buffers.reload(%s)"):format(bufnr, bufnr)
    vim.api.nvim_command(on_read)
  end

  return Buffer(store, bufnr)
end

buffers.reload = function(bufnr)
  local buffer = buffers.find(bufnr)
  if buffer == nil then
    return
  end
  buffer.render({given = false})
end

M.buffers = buffers

return M
