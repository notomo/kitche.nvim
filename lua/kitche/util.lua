local M = {}

M.search_parent_recursive = function(pattern, start_path)
  local path = vim.fn.fnamemodify(start_path, ":p")
  while path ~= "//" do
    local files = vim.fn.glob(path .. pattern, false, true)
    if next(files) ~= nil then
      local file = files[1]
      if vim.fn.isdirectory(file) == 1 then
        return file .. "/"
      end
      return file
    end
    path = vim.fn.fnamemodify(path, ":h:h") .. "/"
  end
  return ""
end

return M
