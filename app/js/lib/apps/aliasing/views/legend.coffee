ILR.Aliasing ?= {}
ILR.Aliasing.Views ?= {}
class ILR.Aliasing.Views.Legend extends Backbone.View
  template: JST['aliasing/legend']

  initialize: =>
    @listenTo @model, 'change:frequency', @updateOriginalLabel
    @listenTo @model, 'change:samplingRate', @updateAliasLabel

  updateOriginalLabel: =>
    @$('.curve.original label').html(t("#{@model.name}.legend.original", value: @model.get('frequency')))

  updateAliasLabel: =>
    @$('.curve.alias label').html(t("#{@model.name}.legend.alias", value: @model.get('samplingRate')))

  render: =>
    @$el.html @template
      frequency: @model.get('frequency')
      samplingRate: @model.get('samplingRate')
      phase: @model.get('phase')
    @updateOriginalLabel()
    @updateAliasLabel()
    this
