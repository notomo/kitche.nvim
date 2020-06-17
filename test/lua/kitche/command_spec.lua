local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("kitche", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open in one of arguments", function()
    command("Kitche open notfound packagejson")
    assert.file_name('package.json')
  end)
end)
