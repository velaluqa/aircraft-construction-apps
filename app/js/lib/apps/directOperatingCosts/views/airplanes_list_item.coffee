ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Views ?= {}
class ILR.DirectOperatingCosts.Views.AirplanesListItem extends Backbone.Poised.List.SelectableItem
  events: _.defaults {
    'tap .edit.icon': 'editAirplane'
    'tap .copy.icon': 'copyAirplane'
    'tap .trash.icon': 'deleteAirplane'
  }, Backbone.Poised.List.SelectableItem.prototype.events

  editAirplane: (e) =>
    e.stopPropagation()
    @trigger('edit', @model)

  copyAirplane: (e) =>
    e.stopPropagation()
    @trigger('copy', @model)

  deleteAirplane: (e) =>
    e.stopPropagation()
    delay =>
      t_confirmation = t 'directOperatingCosts.airplanes.deleteConfirmation',
        name: @model.get('name')
      if confirm(t_confirmation)
        @trigger('remove', @model)

  render: =>
    super

    if @model.get('predefined')
      @$buttons.prepend($('<div class="copy icon"></div>'))
    else
      @$buttons.prepend($('<div class="trash icon"></div>'))
      @$buttons.prepend($('<div class="edit icon"></div>'))
    this
