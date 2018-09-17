ILR.Models ?= {}
class ILR.Models.App extends Backbone.Model
  helpText: 'about'

  defaults:
    path: null
    showAbout: false

  currentApp: ->
    @get('currentApp')

  currentNamespace: ->
    path  = @get('path')
    if path?
      klass = path[0].toCapitalCamel()
      ILR[klass]

  initialize: =>
    @on 'change:path', @handlePath

  handlePath: (model, path) =>
    if path?
      if path[0] is 'about'
        @set showAbout: true
      else if path[0] isnt @currentApp()?.name
        AppModel = @currentNamespace().Models.App
        @set
          showAbout: false
          currentApp: new AppModel path: path.slice(1)
      else
        @currentApp()?.set path: path.slice(1)
        @set showAbout: false
    else
      @set currentApp: null
      @set showAbout: false
