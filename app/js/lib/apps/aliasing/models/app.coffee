ILR.Aliasing ?= {}
ILR.Aliasing.Models ?= {}

class ILR.Aliasing.Models.App extends ILR.Models.BaseApp
  name: 'aliasing'
  path: 'aliasing'
  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'frequency'
      @loadFormFieldSettings 'samplingRate'
      @loadFormFieldSettings 'phase'
    ]

    super
