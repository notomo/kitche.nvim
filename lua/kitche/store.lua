local M = {}

local stores = {}

stores.find = function(target)
  local name = ("kitche/store/%s"):format(target)
  local ok, module = pcall(require, name)
  if not ok then
    return nil
  end
  return module.find()
end

M.stores = stores

return M
