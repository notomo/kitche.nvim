local M = {}

M.commands = {
  remove_new_line = {
    pattern = "^$\\n",
    after = ""
  },
  clean_tab_sequence = {
    pattern = "\\\\t",
    after = "    "
  },
  clean_new_line_sequence = {
    pattern = "\\\\n",
    after = "\\r"
  },
  surround_by_single_quote = {
    pattern = "^(.+)$",
    after = "'\\1'"
  },
  surround_by_double_quote = {
    pattern = "^(.+)$",
    after = '"\\1"'
  }
}

M.flags = "ge"
M.range = "%"
M.after_serve = function(_, _)
  vim.api.nvim_command("nohlsearch")
end

local Store = function(id)
  return {
    id = id,
    name = "substitute",
    load = function(range)
      local cmd_range = M.range
      if range.given then
        cmd_range = ("%d,%d"):format(range.first, range.last)
      end

      local lines = {}
      for key, command in pairs(M.commands) do
        local flags = command.flags
        if flags == nil then
          flags = M.flags
        end
        local value = ("%ss/\\v%s/%s/%s"):format(cmd_range, command.pattern, command.after, flags)
        local line = ("%s\t%s"):format(key, value)
        table.insert(lines, line)
      end
      return lines
    end,
    serve = function(line)
      local idx = line:find("\t")
      if idx == nil then
        return
      end
      local cmd = line:sub(idx + 1)
      vim.api.nvim_command(cmd)

      local key = line:sub(0, idx - 1)
      M.after_serve(key, cmd)
    end,
    look = function(_)
    end
  }
end

M.find = function()
  return Store(vim.bo.filetype)
end

return M
