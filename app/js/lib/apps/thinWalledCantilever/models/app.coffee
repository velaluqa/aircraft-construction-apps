ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Models ?= {}
class ILR.ThinWalledCantilever.Models.App extends ILR.Models.BaseSubappContainer
  name: 'thinWalledCantilever'
  path: 'thinWalledCantilever'

  subapps:
    beam:
      model: 'ILR.ThinWalledCantilever.Models.BeamApp'
      view:  'ILR.ThinWalledCantilever.Views.BeamApp'
    intermediates:
      model: 'ILR.ThinWalledCantilever.Models.IntermediatesApp'
      view:  'ILR.ThinWalledCantilever.Views.IntermediatesApp'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'load'
      @loadFormFieldSettings 'length'
      @loadFormFieldSettings 'height'
      @loadFormFieldSettings 'thickness'
      @loadFormFieldSettings 'E'
      @loadFormFieldSettings 'nue'
      @loadFormFieldSettings 'I', type: 'value'
      @loadFormFieldSettings 'G', type: 'value'
      @loadFormFieldSettings 'continuous', options: ['yes', 'no']
    ]

    @calc = new ILR.ThinWalledCantilever.Models.Calculator(model: this)
    @set
      I: @calc.I()
      G: @calc.G()

    super
