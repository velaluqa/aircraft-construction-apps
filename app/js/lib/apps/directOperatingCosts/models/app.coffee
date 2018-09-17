ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Models ?= {}
class ILR.DirectOperatingCosts.Models.App extends ILR.Models.BaseApp
  name: 'directOperatingCosts'
  path: 'directOperatingCosts'

  defaults: ->
    @loadAppSettings
      # Select which value at range to display.
      valueAtRange: 0

      # Determines which labels the axis should show.
      # Typically the value is one of the currently selected curves.
      axisLabelingForCurve: null

      # Limited to a length of 2
      airplanes: []

      # Limited to a length of 3
      curves: []

      # Updates with airplanes
      calculators: []

  # Load persistent custom airplanes into the collection of available airplanes.
  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'holdingTime'
      @loadFormFieldSettings 'diversionRange'
      @loadFormFieldSettings 'fuelReserve'
    ]

    @costs ||= []
    @costs[0] = new ILR.DirectOperatingCosts.Models.Costs()
    @costs[1] = new ILR.DirectOperatingCosts.Models.Costs()

    @displayParams = new Backbone.Model()

    @initCurves [
      @loadCurveSettings 'm_PL'
      @loadCurveSettings 'm_F'
      @loadCurveSettings 'm_RF'
      @loadCurveSettings 'm_TO'
      @loadCurveSettings 'flights'
      @loadCurveSettings 'fh'
      @loadCurveSettings 'fhPA'
      @loadCurveSettings 'C'
      @loadCurveSettings 'C_cap'
      @loadCurveSettings 'C_crew'
      @loadCurveSettings 'MC_af_mat'
      @loadCurveSettings 'MC_af_per'
      @loadCurveSettings 'MC_eng'
      @loadCurveSettings 'MC'
      @loadCurveSettings 'tko'
      @loadCurveSettings 'sko'
    ], limit: 3

    @airplanes = new ILR.DirectOperatingCosts.Collections.Airplanes(
      ILR.settings[@name].airplanes
    )
    try
      customAirplanes = JSON.parse(ILR.store.get('customAirplanes'))
      @airplanes.add(airplane) for airplane in customAirplanes
    @airplanes.at(0)?.select()
    @airplanes.at(1)?.select()

    @set axisLabelingForCurve: @curves.getOldest()

    # Bind events
    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()
    @airplanes.on 'change:selected', @createCalculators

    @createCalculators()

    super

  createCalculators: =>
    calc.stopListening() for calc in @get('calculators')
    @set calculators: for airplane, i in @airplanes.history
      new ILR.DirectOperatingCosts.Models.Calculator
        doc: this
        airplane: airplane
        costs: @costs[i]

  # Gather the attributes of all custom airplanes and put those
  # into persistent browser storage.
  persistCustomAirplanes: ->
    customAirplanes = @airplanes.where(predefined: false)
    customAirplanes = _.map customAirplanes, (airplane) ->
      _.defaults({ selected: false }, airplane.attributes)
    ILR.store.set('customAirplanes', JSON.stringify(customAirplanes))

  # Adds an airplane to the collection of available airplanes.
  # BackboneJS handled duplicates for us, so the airplane gets
  # replaced if it already exists. Afterwards the collection of custom
  # airplanes gets saved to the persistent storage.
  addAirplane: (airplane) ->
    airplane.set(saved: true)
    @airplanes.add(airplane)
    @persistCustomAirplanes()

  # Creates a new airplane class and sets `editAirplane`.
  createAirplane: =>
    @set editAirplane: new ILR.DirectOperatingCosts.Models.Airplane()

  copyAirplane: (model) =>
    airplane = model.clone()
    airplane.set
      name: "Copy of #{airplane.get('name')}"
      engine: 'Custom Engine'
      reference: 'No Reference'
      predefined: false
      selected: false
      saved: false
    @set editAirplane: airplane

  editAirplane: (airplane) =>
    @set editAirplane: airplane

  removeAirplane: (model) =>
    @airplanes.remove(model)
    @persistCustomAirplanes()
