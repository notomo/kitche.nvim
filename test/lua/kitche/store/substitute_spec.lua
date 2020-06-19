local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("kitche for substitute", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open and serve", function()
    helper.set_lines([[

hoge

foo]])

    command("Kitche open substitute")
    helper.search("remove_new_line")

    command("Kitche serve")

    assert.lines([[hoge
foo]])
  end)

  it("can open and serve with range", function()
    helper.set_lines([[
hoge
foo
bar]])

    command("1,2Kitche open substitute")
    helper.search("surround_by_double_quote")

    command("Kitche serve")

    assert.lines([[
"hoge"
"foo"
bar]])
  end)

end)
