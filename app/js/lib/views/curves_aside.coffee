ILR.Views ?= {}
class ILR.Views.CurvesAside extends ILR.Views.BaseAside
  initialize: ->
    unless @model.curves?
      throw new Error('Missing curves collection in model for CurvesAside')

  render: =>
    @$el.toggleClass('scroll-y', true)
    @subviews.curvesList = new Backbone.Poised.List
      collection: @model.curves
      filterAttributes: ['label']
      itemLabel: JST['general/curves_list_item_label']
      itemClass: ILR.Views.CurvesListItem
      singleSelect: true
      localePrefix: @model.localePrefix()
      group:
        by: 'group'

    @$el.html(@subviews.curvesList.render().el)
    @$el.append($('<div>', class: 'hint').text(t('generic.curvesAside.hint')))
    this
