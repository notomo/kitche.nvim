local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("kitche for makefile", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open and serve", function()
    command("Kitche open makefile")

    assert.window_count(2)
    assert.filetype('kitche-makefile')
    assert.file_name('Makefile')
    assert.current_line('make -f Makefile start')
    assert.found('make -f test.mk build')
    assert.not_found('make -f Makefile invalid')
    assert.not_found('make -f Makefile .PHONY')
    assert.not_found('make -f Makefile TEST')

    command("Kitche serve")

    assert.window_count(1)
    assert.buftype('terminal')
  end)

  it("can open for current makefile", function()
    command("edit ./test.mk")

    command("Kitche open makefile")

    assert.current_line('make -f test.mk build')
    assert.not_found('make -f Makefile start')
    assert.line_count(1)
  end)

  it("can be opend once", function()
    command("Kitche open makefile")
    command("Kitche open makefile")

    assert.window_count(2)
    assert.filetype('kitche-makefile')
    assert.current_line('make -f Makefile start')

    helper.search('make -f Makefile test')

    command("quit")
    command("Kitche open makefile")

    assert.current_line('make -f Makefile test')
  end)

  it("can reload", function()
    command("Kitche open makefile")

    assert.current_line('make -f Makefile start')

    command("edit!")

    assert.current_line('make -f Makefile start')
  end)

  it("can open and look", function()
    command("Kitche open makefile")
    helper.search('make -f Makefile test')

    command("Kitche look")

    assert.window_count(1)
    assert.tab_count(1)
    assert.file_name('Makefile')
    assert.current_line('test:')

    command("Kitche open makefile")
    command("Kitche look")

    assert.tab_count(1)
    assert.current_line('test:')
  end)
end)
