return function()
  for name in pairs(package.loaded) do
    if vim.startswith(name, "kitche/") then
      package.loaded[name] = nil
    end
  end
end
