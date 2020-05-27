local util = require "kitche/util"

local Store = function(id)
  return {
    id = id,
    name = "packagejson",
    load = function()
      local f = io.open(id, "r")
      local loaded = vim.fn.json_decode(f:read("*all"))
      local scripts = loaded["scripts"]
      if scripts == nil then
        return {}
      end

      local lines = {}
      for key in pairs(scripts) do
        local cmd = string.format("npm run %s", key)
        table.insert(lines, cmd)
      end

      return lines
    end,
    serve = function(line)
      vim.api.nvim_command("tabedit")
      vim.fn.termopen(line, {cwd = vim.fn.fnamemodify(id, ":h")})
    end,
    look = function(line)
      vim.api.nvim_command("tab drop" .. id)
      local target = vim.fn.matchstr(line, "\\vnpm\\s+run\\s+\\zs\\S+\\ze\\s*")
      if target == "" then
        return
      end
      local pattern = string.format('"%s":', target)
      vim.fn.search(pattern, "w")
    end
  }
end

return function()
  local path = util.search_parent_recursive("package.json", "./")
  if path == "" then
    return nil
  end
  return Store(path)
end
