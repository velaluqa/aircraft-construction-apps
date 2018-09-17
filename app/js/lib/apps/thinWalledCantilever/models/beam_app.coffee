ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Models ?= {}
class ILR.ThinWalledCantilever.Models.BeamApp extends ILR.Models.BaseApp
  name: 'thinWalledCantileverBeam'
  path: 'thinWalledCantilever/beam'

  initialize: (options) ->
    @parentApp = options.parentApp

    @initCurves [
      @loadCurveSettings 'beam',
        subcurves:
          h_outline: {}
          v_outline: {}
          h_grid: { lineWidth: 1, lineDash: [5, 5] }
          v_grid: { lineWidth: 1, lineDash: [5, 5] }
      @loadCurveSettings 'slice',
        subcurves:
          h_outline: {}
          v_outline: {}
          h_grid: { lineWidth: 1, lineDash: [5, 5] }
          v_grid: { lineWidth: 1, lineDash: [5, 5] }
    ],
      limit: 2

    @displayParams = new Backbone.Model()
    calc = @parentApp.calc
    @set calculators: [calc]

    @listenTo calc, 'change:I', => @parentApp.set I: calc.I()
    @listenTo calc, 'change:G', => @parentApp.set G: calc.G()

    super
