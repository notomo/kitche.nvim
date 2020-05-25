local M = {}

local stores = {}

stores.find = function(target)
  local name = string.format("kitche/store/%s", target)
  for _, path in ipairs(vim.split(package.path, ";")) do
    local p = path:gsub("?", name)
    if vim.fn.filereadable(p) == 1 then
      local store_func = dofile(p)
      return store_func()
    end
  end
  return nil
end

M.stores = stores

return M
