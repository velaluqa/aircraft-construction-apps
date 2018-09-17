ILR.Views ?= {}
class ILR.Views.OverviewTile extends Backbone.Poised.List.Item
  tagName: 'li'
  className: 'tile'
  template: JST['overview/tile']

  events:
    'click': 'loadApp'

  loadApp: =>
    if App = ILR[@model.get('name').toCapitalCamel()]?.Models.App
      ILR.router.navigate("app/#{App::path}", trigger: true)
    else
      alert(t('overview.messages.not_implemented'))

  render: =>
    @$el.html @template @model.toJSON()
    this
