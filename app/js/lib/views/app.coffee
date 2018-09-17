ILR.Views ?= {}
class ILR.Views.App extends Backbone.View
  currentAppView: null

  initialize: ->
    @subviews = {}
    @listenTo @model, 'change:currentApp', @render
    @listenTo @model, 'change:showAbout', @renderAbout

  currentApp: -> @model.currentApp()

  activateSubviews: =>
    if @currentApp()
      @subviews.index?.deactivate()
      @subviews.app?.activate()
    else
      @subviews.index?.activate()
      @subviews.app?.deactivate()

  loadedViewName: ->
    @subviews.app?.model.name

  currentAppName: ->
    @model.currentApp()?.name

  renderAbout: =>
    showAbout = @model.get('showAbout')
    if showAbout and not @subviews.help?
      @subviews.help = view = new ILR.Views.Help
        model: @model
      @$el.append(view.render().el)

    delay =>
      @subviews.help?.setActive(showAbout)
      @subviews.index?.setActive(not showAbout)

  render: =>
    unless @subviews.index?
      @subviews.index = new ILR.Views.Overview()
      @$el.append(@subviews.index.render().el)

    if @subviews.app and @loadedViewName() isnt @currentAppName()
      @subviews.app.remove()
      delete @subviews.app

    if @model.currentApp() and not @subviews.app?
      AppView = @model.currentNamespace().Views.App
      @subviews.app = view = new AppView
        model: @model.currentApp()
      @$el.append(view.render().el)

    @renderAbout()

    delay @activateSubviews

    this
