ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Views ?= {}
class ILR.DirectOperatingCosts.Views.ParametersAside extends ILR.Views.BaseAside
  template: JST['general/tabs']

  render: =>
    @$el.html @template
      tabs: [
        { name: 'costs', label: 'Costs' }
        { name: 'misc', label: 'Misc' }
      ]
    delay -> @$('div.poised.tabs').poisedTabs()

    @$costs = @$('[data-tab=costs]')
    @subviews.costsForm = new Backbone.Poised.LinkedForm
      model1: @model.costs[0]
      model2: @model.costs[1]
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix('costs')
    @$costs.html(@subviews.costsForm.render().el)

    @$misc = @$('[data-tab=misc]')
    @subviews.miscForm = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix('misc')
    @$misc.html(@subviews.miscForm.render().el)

    this
