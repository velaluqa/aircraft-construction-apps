ILR.Views ?= {}
class ILR.Views.CurvesListItem extends Backbone.Poised.List.SelectableItem
  labelParameters: ->
    label: @Present(@model).label()
