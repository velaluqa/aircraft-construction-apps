ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Collections ?= {}
class ILR.DirectOperatingCosts.Collections.Airplanes extends ILR.Collections.LimitedCollection
  model: ILR.DirectOperatingCosts.Models.Airplane
  limit: 2

  constructor: (models) ->
    if typeof models is 'object'
      models = for name, attributes of models
        $.extend(attributes, name: name)
    for model in models
      model.predefined = true
    super
