$ = require 'jquery'
fsUtils = require 'fs-utils'
path = require 'path'

xdescribe "Theme", ->
  theme = null

  beforeEach ->
    $("#jasmine-content").append $("<div class='editor'></div>")

  afterEach ->
    theme.deactivate() if theme?

  describe "when the theme is a file", ->
    it "loads and applies css", ->
      expect($(".editor").css("padding-bottom")).not.toBe "1234px"
      themePath = project.resolve('themes/theme-stylesheet.css')
      theme = new Theme(themePath)
      expect($(".editor").css("padding-top")).toBe "1234px"
      expect(theme.directoryPath).not.toBeDefined()

    it "parses, loads and applies less", ->
      expect($(".editor").css("padding-bottom")).not.toBe "1234px"
      themePath = project.resolve('themes/theme-stylesheet.less')
      theme = new Theme(themePath)
      expect($(".editor").css("padding-top")).toBe "4321px"

  describe "when the theme contains a package.json file", ->
    it "loads and applies stylesheets from package.json in the correct order", ->
      expect($(".editor").css("padding-top")).not.toBe("101px")
      expect($(".editor").css("padding-right")).not.toBe("102px")
      expect($(".editor").css("padding-bottom")).not.toBe("103px")

      themePath = project.resolve('themes/theme-with-package-file')
      theme = new Theme(themePath)
      expect(theme.directoryPath).toBe themePath
      expect($(".editor").css("padding-top")).toBe("101px")
      expect($(".editor").css("padding-right")).toBe("102px")
      expect($(".editor").css("padding-bottom")).toBe("103px")

  describe "when the theme does not contain a package.json file and is a directory", ->
    it "loads all stylesheet files in the directory", ->
      expect($(".editor").css("padding-top")).not.toBe "10px"
      expect($(".editor").css("padding-right")).not.toBe "20px"
      expect($(".editor").css("padding-bottom")).not.toBe "30px"

      themePath = project.resolve('themes/theme-without-package-file')
      theme = new Theme(themePath)
      expect(theme.directoryPath).toBe themePath
      expect($(".editor").css("padding-top")).toBe "10px"
      expect($(".editor").css("padding-right")).toBe "20px"
      expect($(".editor").css("padding-bottom")).toBe "30px"

  describe "reloading a theme", ->
    beforeEach ->
      themePath = project.resolve('themes/theme-with-package-file')
      theme = new Theme(themePath)

    it "reloads without readding to the stylesheets list", ->
      expect(theme.getStylesheetPaths().length).toBe 3
      theme.loadStylesheet(theme.getStylesheetPaths()[0])
      expect(theme.getStylesheetPaths().length).toBe 3

  describe "events", ->
    beforeEach ->
      themePath = project.resolve('themes/theme-with-package-file')
      theme = new Theme(themePath)

    it "deactivated event fires on .deactivate()", ->
      theme.on 'deactivated', spy = jasmine.createSpy()
      theme.deactivate()
      expect(spy).toHaveBeenCalled()
