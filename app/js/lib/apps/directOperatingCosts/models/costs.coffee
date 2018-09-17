ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Models ?= {}
class ILR.DirectOperatingCosts.Models.Costs extends Backbone.Model
  defaults: -> ILR.settings.directOperatingCosts.costs.defaults

  initialize: ->
    super

    @formFields = [
      @loadFormFieldSettings 'oemPrice'
      @loadFormFieldSettings 'interestRate'
      @loadFormFieldSettings 'amortizationPeriod'
      @loadFormFieldSettings 'residualValue'
      @loadFormFieldSettings 'insuranceRate'
      @loadFormFieldSettings 'avgSalaryFA'
      @loadFormFieldSettings 'avgSalaryFC'
      @loadFormFieldSettings 'crewComplement'
      @loadFormFieldSettings 'fuelPrice'
      @loadFormFieldSettings 'landingPrice'
      @loadFormFieldSettings 'handlingPrice'
      @loadFormFieldSettings 'costBurden'
      @loadFormFieldSettings 'laborRate'
      @loadFormFieldSettings 'atcPrice'
      @loadFormFieldSettings 'transportRate'
    ]

  loadFormFieldSettings: (attribute, defaults = {}) ->
    defaults.attribute = attribute
    $.extend ILR.settings.directOperatingCosts.costs.formFields[attribute], defaults
