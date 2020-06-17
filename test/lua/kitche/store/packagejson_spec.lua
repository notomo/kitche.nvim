local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("kitche for packagejson", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open and serve", function()
    command("Kitche open packagejson")

    assert.filetype('kitche-packagejson')
    assert.file_name('package.json')
    assert.found('npm run start')
    assert.found('npm run build')

    command("Kitche serve")

    assert.window_count(1)
    assert.buftype('terminal')
  end)

  it("can open and look", function()
    command("Kitche open packagejson")
    helper.search('npm run start')

    command("Kitche look")

    assert.window_count(1)
    assert.tab_count(1)
    assert.file_name('package.json')
    assert.current_line('    "start": "echo start",')

    command("Kitche open packagejson")
    command("Kitche look")

    assert.tab_count(1)
    assert.current_line('    "start": "echo start",')
  end)

end)
