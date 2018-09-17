ILR.VnDiagram ?= {}
ILR.VnDiagram.Models ?= {}
class ILR.VnDiagram.Models.App extends ILR.Models.BaseApp
  name: 'vnDiagram'
  path: 'vnDiagram'

  defaults: ->
    @loadAppSettings
      axisLabelingForCurve: null
      valueAtRange: 0

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'vdvc60', options: ['yes', 'no']
      @loadFormFieldSettings 'designSpeed'
      @loadFormFieldSettings 'altitude'
      @loadFormFieldSettings 'aspectRatio'
      @loadFormFieldSettings 'taperRatio'
      @loadFormFieldSettings 'takeOffMass'
      @loadFormFieldSettings 'maxSurfaceLoad'
      @loadFormFieldSettings 'fuelFactor'
      @loadFormFieldSettings 'wingSweep'
      @loadFormFieldSettings 'maxLiftCoefficient'
      @loadFormFieldSettings 'minLiftCoefficient'
      @loadFormFieldSettings 'maxStartLiftCoefficient'
      @loadFormFieldSettings 'maxLandingLiftCoefficient'
    ]

    @initCurves [
      @loadCurveSettings 'speedAnnotations'
      @loadCurveSettings 'nF',
        subcurves:
          min: {}
          max: {}
      @loadCurveSettings 'nFTS'
      @loadCurveSettings 'nFTL'
      @loadCurveSettings 'nG',
        subcurves:
          min: {}
          max: {}
      @loadCurveSettings 'gustLines'
      @loadCurveSettings 'gustHull'
    ]

    @displayParams = new Backbone.Model()
    calc = new ILR.VnDiagram.Models.Calculator(model: this)
    @set calculators: [calc]

    @on 'change:designSpeed', (_, speed) =>
      altitudeLimit = calc._altitudeLimit(speed)
      @set altitude: altitudeLimit if @get('altitude') > altitudeLimit

    @on 'change:altitude', (_, altitude) =>
      designSpeedLimit = calc._designSpeedLimit(altitude)
      if @get('designSpeed') > designSpeedLimit
        @set designSpeed: designSpeedLimit

    super
