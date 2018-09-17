class ILR.Router extends Backbone.Router
  routes:
    '': 'index'
    '(app/)*path': 'load'

  initialize: ->
    ILR.store = new Persist.Store('ilr_app')
    ILR.app = new ILR.Models.App()
    ILR.view = new ILR.Views.App
      model: ILR.app
      el: $('#app')
    ILR.view.render()

  index: =>
    ILR.app.set path: null

  load: (path) =>
    ILR.app.set path: path.split('/')
