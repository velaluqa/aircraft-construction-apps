ILR.AirplaneInternalLoads ?= {}
ILR.AirplaneInternalLoads.Views ?= {}
class ILR.AirplaneInternalLoads.Views.WingParametersAside extends ILR.Views.BaseAside
  template: JST['general/tabs']

  tabs: [
    { name: 'operational', label: 'Operational' }
    { name: 'mass', label: 'Mass' }
    { name: 'wing', label: 'Wing Geo.' }
    { name: 'misc', label: 'Misc Geo.' }
  ]

  render: =>
    @$el.html @template tabs: @tabs
    delay -> @$('div.poised.tabs').poisedTabs()

    @$operational = @$('[data-tab=operational]')
    @subviews.operationalForm = view = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix()
      fields: [
        @model.loadFormFieldSettings 'loadCase', options: ['flight', 'ground']
        @model.loadFormFieldSettings 'loadFactor', options: [1.0, 2.5, 3.75]
        @model.loadFormFieldSettings 'thrust'
      ]
    @$operational.html(view.render().el)

    @$mass = @$('[data-tab=mass]')
    @subviews.massForm = view = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix()
      fields: [
        @model.loadFormFieldSettings 'airplaneMass'
        @model.loadFormFieldSettings 'relWingMass'
        @model.loadFormFieldSettings 'relFuelMass'
        @model.loadFormFieldSettings 'relEngineMass'
        @model.loadFormFieldSettings 'relPayload'
      ]
    @$mass.html(view.render().el)

    @$wing = @$('[data-tab=wing]')
    @subviews.wingForm = view = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      fields: [
        @model.loadFormFieldSettings 'span'
        @model.loadFormFieldSettings 'aspectRatio'
        @model.loadFormFieldSettings 'taper'
        @model.loadFormFieldSettings 'wingArea', type: 'value'
        @model.loadFormFieldSettings 'innerChord', type: 'value'
        @model.loadFormFieldSettings 'outerChord', type: 'value'
        @model.loadFormFieldSettings 'mac', type: 'value'
      ]
    @$wing.html(view.render().el)

    @$misc = @$('[data-tab=misc]')
    @subviews.miscForm = view = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      fields: [
        @model.loadFormFieldSettings 'relGearPositionX'
        @model.loadFormFieldSettings 'relGearPositionY'
        @model.loadFormFieldSettings 'relTankSpan'
        @model.loadFormFieldSettings 'relShearCenter'
        @model.loadFormFieldSettings 'relEnginePositionY'
        @model.loadFormFieldSettings 'relThrustCenterZ'
      ]
    @$misc.html(view.render().el)

    this
