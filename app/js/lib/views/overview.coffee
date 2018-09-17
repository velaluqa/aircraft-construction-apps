ILR.Views ?= {}
class ILR.Views.Overview extends Backbone.Poised.View
  id: 'overview'
  tagName: 'section'
  className: 'active'

  template: JST['overview/app']

  events:
    'tap header .help.icon': 'showHelp'

  hammerjs: true

  keep: true

  apps: [
    { name: 'airplaneInternalLoads', label: 'airplaneInternalLoads', groups: ['aeroStructures'] }
    { name: 'aliasing', label: 'aliasing', groups: ['miscellaneous'] }
    { name: 'beamSectionProperties', label: 'beamSectionProperties', groups: ['aeroStructures'] }
    { name: 'buckling', label: 'buckling', groups: ['aeroStructures'] }
    { name: 'cabinSlendernessRatio', label: 'cabinSlendernessRatio', groups: ['aircraftDesign'] }
    { name: 'directOperatingCosts', label: 'directOperatingCosts', groups: ['aircraftDesign'] }
    { name: 'internationalStandardAtmosphere', label: 'internationalStandardAtmosphere', groups: ['aeroStructures', 'aircraftDesign'] }
    { name: 'jetEnginePerformance', label: 'jetEnginePerformance', groups: ['aircraftDesign'] }
    { name: 'laminateDeformation', label: 'laminateDeformation', groups: ['aeroStructures'] }
    { name: 'liftDistribution', label: 'liftDistribution', groups: ['aircraftDesign'] }
    { name: 'mohrsCircle', label: 'mohrsCircle', groups: ['aeroStructures'] }
    { name: 'sandwichStructuredComposite', label: 'sandwichStructuredComposite', groups: ['aeroStructures'] }
    { name: 'thinWalledCantilever', label: 'thinWalledCantilever', groups: ['aeroStructures'] }
    { name: 'vnDiagram', label: 'vnDiagram', groups: ['aeroStructures'] }
  ]

  initialize: ->
    $(window).resize @adjustDimensions

    # Split the apps into their respective groups for easy grouping in
    # Poised.List.
    apps = for app in @apps
      for group in app.groups
        _.chain(app)
          .omit('groups')
          .defaults(group: group)
          .value()

    @collection = new Backbone.Collection(_.flatten(apps))

  setActive: (val) ->
    @$el.toggleClass('active', val)

  activate: =>
    @$el.toggleClass('active', true)

  deactivate: =>
    @$el.toggleClass('active', false)

  showHelp: =>
    ILR.router.navigate('about', trigger: true)

  calculateTileSize: =>
    width = @$el.width() - 2 * 14
    columns = Math.ceil(width / 200)
    Math.floor(Math.min(width / columns, 200))

  adjustDimensions: =>
    size = @calculateTileSize()
    @$('.tile').each (i, elem) ->
      $(elem).css
        height: "#{size}px"
        width: "#{size}px"

  render: ->
    @$el.html(@template())

    if /Android.*Chrome/.test(navigator.userAgent)
      @$('#chrome-android-flag-hint').css display: 'block'

    @list = new Backbone.Poised.List
      filterAttributes: []
      collection: @collection
      itemClass: ILR.Views.OverviewTile
      group:
        by: 'group'
        sorting: ['aircraftDesign', 'aeroStructures', 'miscellaneous']
        collapsible: true
      localePrefix: 'overview'
    @$('article ul').replaceWith(@list.render().el)

    delay @adjustDimensions

    this
