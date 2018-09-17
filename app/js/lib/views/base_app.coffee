ILR.Views ?= {}
class ILR.Views.BaseApp extends Backbone.Poised.View
  template: JST['general/app']

  id: -> @model.name.toDash()
  tagName: 'section'
  className: 'active'

  # Typically in a subclass we override the list of asides. This may
  # be a list of classes inheriting from ILR.Views.BaseAside or an
  # object with `name` and `klass` attributes.
  asideViews: []

  legendView: null

  graphView: null
  graphDefaults: {}

  rangeHandlerView: null

  # TODO: Rename valueAtRange name pattern to something like selectValue
  # TODO: use correct attribute in every app instead of generic valueAtRange
  valueAtRange: null
  valueAtRangeAxis: 'x'
  valueAtRangeAttribute: 'valueAtRange'
  valueAtRangePrecision: null

  legendValueAtRange: null
  legendValueAtRangeAxis: null
  legendValueAtRangeAttribute: null

  useHeadup: false

  events:
    'tap header .overview.icon': 'backToOverview'
    'tap header .help.icon': 'showHelp'
    'tap header .icon[data-toggle-aside]': 'setCurrentAside'
    'tap header .poised.subapps.select': 'viewSubappOptions'
    'tap header .poised.subapps.select .option': 'openSubapp'
    'tap article.graph:has(~ aside.active)': 'hideAsides'
    'tap section:has(.subapps.select.view)': 'hideSubappOptions'

  hammerjs: true

  remove: =>
    @$el.afterTransitionForRemovingClass 'active', => super

  initialize: ->
    @listenTo @model, 'change:currentAside', @toggleAside
    @listenTo @model, 'change:showHelp', @renderHelp
    if @useHeadup
      @on 'controlLiveChangeStart', @liveChangeStart
      @on 'controlLiveChangeEnd', @liveChangeEnd

  viewSubappOptions: (e) =>
    @$('.subapps.select').toggleClass('view')
    e.stopPropagation()

  hideSubappOptions: =>
    @$('.subapps.select').toggleClass('view', false)

  openSubapp: (e) =>
    $target = $(e.target)
    ILR.router.navigate("app/#{$target.data('path')}", trigger: true)

  showHelp: =>
    ILR.router.navigate("app/#{@model.path}/help", trigger: true)

  setCurrentAside: (e) =>
    asideToToggle = $(e.currentTarget).data('toggle-aside')
    currentAside = @model.get('currentAside')
    if currentAside is asideToToggle
      @model.set currentAside: null
    else
      @model.set currentAside: asideToToggle

  hideAsides: =>
    @model.set currentAside: null

  backToOverview: =>
    ILR.router.navigate('/', trigger: true)

  toggleAside: (model, value) =>
    previous = model.previousAttributes().currentAside
    if previous?
      @$("header .#{previous}.aside.icon").toggleClass('active', false)
      @$("aside.#{previous}").toggleClass('active', false)
    if value?
      @$("header .#{value}.aside.icon").toggleClass('active', true)
      @$("aside.#{value}").toggleClass('active', true)

  liveChangeStart: (slider) =>
    if $(window).width() <= 768
      @$('aside.active').addClass('hidden')
      @subviews.headup.activate(slider)

  liveChangeEnd: =>
    if $(window).width() <= 768
      @$('aside.active').removeClass('hidden')
      @subviews.headup.deactivate()

  setActive: (active) =>
    @$el.toggleClass('active', active)

  activate: =>
    @$el.toggleClass('active', true)

  deactivate: =>
    @$el.toggleClass('active', false)

  relatedApps: =>
    @model.parentApp?.subappInfo() or []

  renderHelp: =>
    showHelp = @model.get('showHelp')
    if showHelp and not @subviews.help?
      @subviews.help = view = new ILR.Views.Help
        model: @model
      @$el.append(view.render().el)

    delay =>
      @subviews.help?.setActive(showHelp)
      @$app.toggleClass('active', not showHelp)

  render: =>
    @$el.html @template
      name: @model.name
      path: @model.path
      hasHelpText: @model.hasHelpText
      asideViews: @asideViews
      legendView: @legendView?
      graphView: @graphView?
      rangeHandlerView: @rangeHandlerView?
      useHeadup: @useHeadup
      relatedApps: @relatedApps()
      currentPath: @model.path

    @$app = @$('section.app')
    for aside in @asideViews
      AsideView = aside.view.toFunction()
      view = @subviews[aside.name] = new AsideView
        model: @model
        parentView: this
        name: aside.name
        localePrefix: @model.localePrefix()
      @$app.append(view.render().el)

    if @legendView? and not @subviews.legend
      @$legend = @$('article .legend')
      LegendView = @legendView.toFunction()
      @subviews.legend = view = new LegendView
        model: @model
        parentView: this
        el: @$legend
        useValueAtRange: @legendValueAtRange or @valueAtRange or @rangeHandlerView?
        valueAtRangeAxis: @legendValueAtRangeAxis or @valueAtRangeAxis
        valueAtRangeAttribute: @legendValueAtRangeAttribute or @valueAtRangeAttribute
        localePrefix: @model.localePrefix()
      view.render()

    if @rangeHandlerView? and not @subviews.rangeHandler?
      @$rangeHandler = @$('article .range-handler')
      RangeHandlerView = @rangeHandlerView.toFunction()
      @subviews.rangeHandler = view = new RangeHandlerView
        model: @model
        parentView: this
        el: @$rangeHandler
        axis: @valueAtRangeAxis
        attribute: @valueAtRangeAttribute
        precision: @valueAtRangePrecision
        localePrefix: @model.localePrefix()
      view.render()

    if @useHeadup and not @subviews.headup?
      @$headup = @$('aside.headup')
      @subviews.headup = new ILR.Views.Headup
        el: @$headup
        localePrefix: @model.localePrefix()

    delay =>
      if @graphView? and not @subviews.graph
        @$graph = @$('article .graph')
        GraphView = @graphView.toFunction()
        @subviews.graph = view = new GraphView
          model: @model
          parentView: this
          params: @model.displayParams
          defaults: _.defaults
            width: @$graph.width()
            height: @$graph.height()
            valueAtRangeAxis: @valueAtRangeAxis
            valueAtRangeAttribute: @valueAtRangeAttribute
          , @graphDefaults
          localePrefix: @model.localePrefix()
        @$graph.html(view.render().el)

    @renderHelp()
    @toggleAside(@model, @model.get('currentAside'))

    this
