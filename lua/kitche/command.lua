local stores = require "kitche/store".stores
local buffers = require "kitche/buffer".buffers
local window = require "kitche/window"
local messenger = require "kitche/messenger"

local M = {}

M.open = function(...)
  local store = nil
  for _, target in ipairs({...}) do
    store = stores.find(target)
    if store ~= nil then
      break
    end
  end

  if store == nil then
    return messenger.warn("not found store for target: " .. vim.inspect({...}))
  end

  window.close()

  local buffer = buffers.get_or_create(store)
  buffer:render()

  window.open(buffer.bufnr)
end

M.serve = function()
  local bufnr = vim.fn.bufnr("%")
  local buffer = buffers.find(bufnr)
  if buffer == nil then
    return messenger.warn("not kitche buffer")
  end

  local line = vim.fn.getline(".")
  local store = buffer.store

  window.close()

  return store.serve(line)
end

M.look = function()
  local bufnr = vim.fn.bufnr("%")
  local buffer = buffers.find(bufnr)
  if buffer == nil then
    return messenger.warn("not kitche buffer")
  end

  local line = vim.fn.getline(".")
  local store = buffer.store

  window.close()

  return store.look(line)
end

return M
