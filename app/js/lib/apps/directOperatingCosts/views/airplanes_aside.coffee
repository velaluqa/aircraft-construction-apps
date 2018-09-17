ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Views ?= {}
class ILR.DirectOperatingCosts.Views.AirplanesAside extends ILR.Views.BaseAside
  initialize: (options) ->
    @model.on 'change:editAirplane', @render

  render: =>
    @$el.toggleClass('scroll-y', true)
    _.invoke(@subviews, 'remove')
    @$el.scrollTop(250)
    if @model.get('editAirplane')?
      @subviews.airplaneForm = new Backbone.Poised.Form
        model: @model.get('editAirplane')
        cancelable: true
        creationTitle: t('directOperatingCosts.airplanes.creationTitle')
        editingTitle: t('directOperatingCosts.airplanes.editingTitle')
        localePrefix: @model.localePrefix('airplanes')

      @subviews.airplaneForm.on 'validSubmit', (submittedAirplane) =>
        @model.addAirplane(submittedAirplane)
        @model.set editAirplane: null

      @subviews.airplaneForm.on 'cancel', =>
        @model.set editAirplane: null

      @$el.html(@subviews.airplaneForm.render().el)
    else
      t_predefinedTitle = t('directOperatingCosts.airplanes.predefinedTitle')
      t_customTitle = t('directOperatingCosts.airplanes.customTitle')
      @subviews.airplanesList = new Backbone.Poised.List
        collection: @model.airplanes
        filterAttributes: ['name', 'engine', 'reference']
        itemLabel: JST['doc/airplanes_list_item_label']
        itemClass: ILR.DirectOperatingCosts.Views.AirplanesListItem
        group:
          by: (model) ->
            if model.attributes.predefined
              'predefined'
            else
              'custom'
          sorting: ['custom', 'predefined']
        addible: true
        addLabel: t('directOperatingCosts.airplanes.addLabel')
        localePrefix: @model.localePrefix('airplanes')

      @subviews.airplanesList.on 'add', @model.createAirplane
      @subviews.airplanesList.on 'edit', @model.editAirplane
      @subviews.airplanesList.on 'copy', @model.copyAirplane
      @subviews.airplanesList.on 'remove', @model.removeAirplane
      @$el.html(@subviews.airplanesList.render().el)
    this
