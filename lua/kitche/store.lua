local M = {}

local stores = {}

stores.find = function(target)
  local name = ("kitche/store/%s"):format(target)
  local ok, func = pcall(require, name)
  if not ok then
    return nil
  end
  return func()
end

M.stores = stores

return M
