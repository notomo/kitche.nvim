local helper = require "test.helper"
local assert = helper.assert
local command = helper.command

describe("plugin.kitche", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open_and_serve", function()
    command("KitcheOpen makefile")

    assert.window_count(2)
    assert.filetype('kitche-makefile')
    assert.file_name('Makefile')
    assert.current_line('make -f Makefile start')
    assert.found('make -f test.mk build')
    assert.not_found('make -f Makefile invalid')
    assert.not_found('make -f Makefile .PHONY')
    assert.not_found('make -f Makefile TEST')

    command("KitcheServe")

    assert.window_count(1)
    assert.buftype('terminal')
  end)

  it("file_option", function()
    command("edit ./test.mk")

    command("KitcheOpen makefile")

    assert.current_line('make -f test.mk build')
    assert.not_found('make -f Makefile start')
    assert.line_count(1)
  end)

  it("open_many_times", function()
    command("KitcheOpen makefile")
    command("KitcheOpen makefile")

    assert.window_count(2)
    assert.filetype('kitche-makefile')
    assert.current_line('make -f Makefile start')

    helper.search('make -f Makefile test')

    command("quit")
    command("KitcheOpen makefile")

    assert.current_line('make -f Makefile test')
  end)

  it("reload", function()
    command("KitcheOpen makefile")

    assert.current_line('make -f Makefile start')

    command("edit!")

    assert.current_line('make -f Makefile start')
  end)

  it("look", function()
    command("KitcheOpen makefile")
    helper.search('make -f Makefile test')

    command("KitcheLook")

    assert.window_count(1)
    assert.tab_count(1)
    assert.file_name('Makefile')
    assert.current_line('test:')

    command("KitcheOpen makefile")
    command("KitcheLook")

    assert.tab_count(1)
    assert.current_line('test:')
  end)

  it("open_package_json", function()
    command("KitcheOpen packagejson")

    assert.filetype('kitche-packagejson')
    assert.file_name('package.json')
    assert.found('npm run start')
    assert.found('npm run build')

    command("KitcheServe")

    assert.window_count(1)
    assert.buftype('terminal')
  end)

  it("look_package_json", function()
    command("KitcheOpen packagejson")
    helper.search('npm run star')

    command("KitcheLook")

    assert.window_count(1)
    assert.tab_count(1)
    assert.file_name('package.json')
    assert.current_line('    "start": "echo start",')

    command("KitcheOpen packagejson")
    command("KitcheLook")

    assert.tab_count(1)
    assert.current_line('    "start": "echo start",')
  end)

  it("more_targets", function()
    command("KitcheOpen notfound packagejson")
    assert.file_name('package.json')
  end)
end)
