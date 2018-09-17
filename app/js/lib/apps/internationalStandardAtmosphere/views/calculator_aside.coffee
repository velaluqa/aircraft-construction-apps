ILR.InternationalStandardAtmosphere ?= {}
ILR.InternationalStandardAtmosphere.Views ?= {}
class ILR.InternationalStandardAtmosphere.Views.CalculatorAside extends ILR.Views.BaseAside
  render: =>
    @$el.addClass('scroll-y')

    subview = @subviews.form = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix()
      fields: [
        @model.loadFormFieldSettings 'altitude'
        @model.loadFormFieldSettings 'deltaTemperature'
        @model.loadFormFieldSettings 'seaLevelTemperature', type: 'value'
        @model.loadFormFieldSettings 'pressure_value', type: 'value'
        @model.loadFormFieldSettings 'relativePressure_value', type: 'value'
        @model.loadFormFieldSettings 'density_value', type: 'value'
        @model.loadFormFieldSettings 'relativeDensity_value', type: 'value'
        @model.loadFormFieldSettings 'temperature_value', type: 'value'
        @model.loadFormFieldSettings 'relativeTemperature_value', type: 'value'
        @model.loadFormFieldSettings 'speedOfSound_value', type: 'value'
        @model.loadFormFieldSettings 'dynamicViscosity_value', type: 'value'
        @model.loadFormFieldSettings 'kinematicViscosity_value', type: 'value'
      ]
    @$el.html(subview.render().el)

    this
