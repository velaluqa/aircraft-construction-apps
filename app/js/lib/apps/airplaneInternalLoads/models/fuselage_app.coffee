ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Models ?= {}
class ILR.AirplaneInternalLoads.Models.FuselageApp extends ILR.Models.BaseApp
  name: 'airplaneFuselageInternalLoads'
  path: 'airplaneInternalLoads/fuselage'

  defaults: ->
    @loadAppSettings
      axisLabelingForCurve: null
      valueAtRange: 0

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'loadCase', options: ['flight', 'ground']
      @loadFormFieldSettings 'fuselageMass'
      @loadFormFieldSettings 'fuselageLength'
      @loadFormFieldSettings 'relFirstMainFramePosition'
      @loadFormFieldSettings 'relSecondMainFramePosition'
      @loadFormFieldSettings 'relGearPosition'
      @loadFormFieldSettings 'stabilizerLoad'
    ]

    @initCurves [
      @loadCurveSettings 'Q'
      @loadCurveSettings 'M'
    ]

    @displayParams = new Backbone.Model()
    @set calculators: [new ILR.AirplaneInternalLoads.Models.FuselageCalculator model: this]
    @set axisLabelingForCurve: @curves.at(0)

    @on 'change:relGearPosition', =>
      rGP = @get('relGearPosition')
      rFP = @get('relFirstMainFramePosition')
      rSP = @get('relSecondMainFramePosition')
      @set(relFirstMainFramePosition:  rGP) if rGP > rFP
      @set(relSecondMainFramePosition: rGP) if rGP > rSP
    @on 'change:relFirstMainFramePosition', =>
      rFP = @get('relFirstMainFramePosition')
      rSP = @get('relSecondMainFramePosition')
      rGP = @get('relGearPosition')
      @set(relGearPosition: rFP) if rFP < rGP
      @set(relSecondMainFramePosition: rFP+0.1) if rFP >= rSP
    @on 'change:relSecondMainFramePosition', =>
      rFP = @get('relFirstMainFramePosition')
      rSP = @get('relSecondMainFramePosition')
      rGP = @get('relGearPosition')
      @set(relFirstMainFramePosition: rSP-0.1) if rSP <= rFP

    @curves.on 'change:selected', =>
      unless @curves.inHistory(@get('axisLabelingForCurve'))
        @set axisLabelingForCurve: @curves.getOldest()

    super
