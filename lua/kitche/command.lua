local stores = require "kitche/store".stores
local buffers = require "kitche/buffer".buffers
local window = require "kitche/window"
local messenger = require "kitche/messenger"

local M = {}

local cmds = {
  open = function(...)
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
  end,
  serve = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buffer = buffers.find(bufnr)
    if buffer == nil then
      return messenger.warn("not kitche buffer")
    end

    local line = vim.api.nvim_get_current_line()
    local store = buffer.store

    window.close()

    return store.serve(line)
  end,
  look = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local buffer = buffers.find(bufnr)
    if buffer == nil then
      return messenger.warn("not kitche buffer")
    end

    local line = vim.api.nvim_get_current_line()
    local store = buffer.store

    window.close()

    return store.look(line)
  end
}

local slice = function(tbl, first, last)
  local result = {}
  for i = first or 1, last or #tbl, 1 do
    result[#result + 1] = tbl[i]
  end
  return result
end

M.main = function(...)
  local args = {...}

  local name = args[1]
  local cmd = cmds[name]
  if cmd == nil then
    return messenger.warn("not found command: args=" .. vim.inspect(args))
  end

  local cmd_args = slice(args, 2)
  cmd(unpack(cmd_args))
end

return M