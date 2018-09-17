ILR.BeamSectionProperties ?= {}
ILR.BeamSectionProperties.Models ?= {}
class ILR.BeamSectionProperties.Models.UProfileApp extends ILR.Models.BaseApp
  name: 'beamSectionPropertiesUProfile'
  path: 'beamSectionProperties/uProfile'

  defaults: -> @loadAppSettings()

  initialize: ->
    @formFields = [
      @loadFormFieldSettings 'profileWidth'
      @loadFormFieldSettings 'relFlangeThickness'
      @loadFormFieldSettings 'relWebThickness'
      @loadFormFieldSettings 'relLipThickness'
      @loadFormFieldSettings 'relWebHeight'
      @loadFormFieldSettings 'relLipHeight'
      @loadFormFieldSettings 'secondMomentOfArea', type: 'value'
      @loadFormFieldSettings 'shearCenter', type: 'value'
    ]
    @initCurves [
      @loadCurveSettings 'profile'
    ]

    @displayParams = new Backbone.Model()
    calc = new ILR.BeamSectionProperties.Models.UProfileCalculator model: this
    @set calculators: [calc]

    @listenTo calc, 'change:profileWidth', =>
      @set profileWidth: calc.profileWidth()
    @listenTo calc, 'change:thrustCenterX', =>
      @set shearCenter: calc.thrustCenterX()
    @listenTo calc, 'change:inertiaIy', =>
      @set secondMomentOfArea: calc.inertiaIy()
    @set profileWidth: calc.profileWidth()
    @set shearCenter: calc.thrustCenterX()
    @set secondMomentOfArea: calc.inertiaIy()

    @on 'change:relWebThickness', =>
      tBase = @get('relWebThickness')
      tLip = @get('relLipThickness')
      if tBase + tLip > 1
        @set relLipThickness: 1 - tBase
    @on 'change:relLipThickness', =>
      tBase = @get('relWebThickness')
      tLip = @get('relLipThickness')
      if tBase + tLip > 1
        @set relWebThickness: 1 - tLip
    @on 'change:relFlangeThickness', =>
      tFlange = @get('relFlangeThickness')
      hBase   = @get('relWebHeight')
      if tFlange*2 > hBase
        @set relWebHeight: tFlange*2
    @on 'change:relWebHeight', =>
      hBase   = @get('relWebHeight')
      tFlange = @get('relFlangeThickness')
      if tFlange > hBase / 2
        @set relFlangeThickness: hBase/2

    super
