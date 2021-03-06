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

  describe("can open and serve with range", function()
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

    it("disable hlsearch after serve", function()
      assert.is_true(vim.v.hlsearch == 0)
    end)

  end)

  it("can reload", function()
    command("Kitche open substitute")
    helper.search("remove_new_line")

    command("edit!")

    helper.search("remove_new_line")
  end)

  it("ignore pattern not found error on serve", function()
    command("Kitche open substitute")
    helper.search("surround_by_double_quote")

    command("Kitche serve")
  end)

  it("can escape", function()
    helper.set_lines([[ho/ge]])

    command("Kitche open substitute")
    helper.search("escape")

    command("Kitche serve")

    assert.lines([[ho\/ge]])
  end)

end)
