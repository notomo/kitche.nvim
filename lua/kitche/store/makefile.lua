local util = require "kitche/util"

local M = {}

local Store = function(id)
  local _load = function(path)
    local lines = {}
    local file_name = vim.fn.fnamemodify(path, ":t")

    local f = io.open(path, "r")
    for line in f:lines() do
      local target = vim.fn.matchstr(line, "\\v^\\zs\\S*\\ze:[^=]*$")
      if not (target == "" or target == ".PHONY" or target:find(":") ~= nil) then
        local cmd = string.format("make -f %s %s", file_name, target)
        table.insert(lines, cmd)
      end
    end
    lines = vim.fn.uniq(lines)
    return lines
  end

  return {
    id = id,
    name = "makefile",
    load = function()
      local lines = {}
      local dir_path = vim.fn.fnamemodify(id, ":h")
      local paths = vim.fn.glob(dir_path .. "/*.mk", false, true)
      local match = vim.fn.match(paths, "^" .. id .. "$")
      if match ~= -1 then
        table.remove(paths, match + 1)
      end

      for _, path in ipairs(vim.list_extend({id}, paths)) do
        lines = vim.list_extend(lines, _load(path))
      end
      return lines
    end,
    serve = function(line)
      vim.api.nvim_command("tabedit")
      vim.fn.termopen(line, {cwd = vim.fn.fnamemodify(id, ":h")})
    end,
    look = function(line)
      vim.api.nvim_command("tab drop" .. id)
      local target = vim.fn.matchstr(line, "\\vmake\\s+-f\\s+\\S+\\s+\\zs\\S+\\ze\\s*")
      if target == "" then
        return
      end
      local pattern = string.format("^%s:", target)
      vim.fn.search(pattern, "w")
    end
  }
end

local search_makefile = function()
  if vim.bo.filetype == "make" then
    return vim.fn.expand("%:p")
  end
  return util.search_parent_recursive("Makefile", "./")
end

M.find = function()
  local makefile_path = search_makefile()
  if makefile_path == "" then
    return nil
  end
  return Store(makefile_path)
end

return M
