ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Models ?= {}
class ILR.DirectOperatingCosts.Models.Airplane extends Backbone.Model
  defaults: -> ILR.settings.directOperatingCosts.airplane.defaults

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'name'
      @loadFormFieldSettings 'maxTakeOffMass'
      @loadFormFieldSettings 'maxFuelMass'
      @loadFormFieldSettings 'operationEmptyMass'
      @loadFormFieldSettings 'maxPayload'
      @loadFormFieldSettings 'ldRatio'
      @loadFormFieldSettings 'sfc'
      @loadFormFieldSettings 'speed'
      @loadFormFieldSettings 'engineCount'
      @loadFormFieldSettings 'slst'
    ]

  loadFormFieldSettings: (attribute, defaults = {}) ->
    defaults.attribute = attribute
    $.extend ILR.settings.directOperatingCosts.airplane.formFields[attribute], defaults

  validation:
    name:
      required: true

  isNew: ->
    not @get('saved')

  deselect: => @set(selected: false)
  select: => @set(selected: true)
