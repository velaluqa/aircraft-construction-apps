ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Models ?= {}
class ILR.ThinWalledCantilever.Models.IntermediatesApp extends ILR.Models.BaseApp
  name: 'thinWalledCantileverIntermediates'
  path: 'thinWalledCantilever/intermediates'

  initialize: (options) ->
    @parentApp = options.parentApp

    @initCurves [
      @loadCurveSettings 'c1_dist'
      @loadCurveSettings 'd1_dist'
      @loadCurveSettings 'd2_dist'
    ],
      limit: 3

    @displayParams = new Backbone.Model()
    calc = @parentApp.calc
    @set calculators: [calc]

    super
