ILR.ThinWalledCantilever ?= {}
ILR.ThinWalledCantilever.Views ?= {}
class ILR.ThinWalledCantilever.Views.ParametersAside extends ILR.Views.BaseAside
  render: =>
    @$el.addClass('scroll-y')
    subview = @subviews.form = new Backbone.Poised.Form
      model: @model.parentApp
      liveForm: true
      parentView: this
      localePrefix: @model.parentApp.localePrefix()
    @$el.html(subview.render().el)

    this
