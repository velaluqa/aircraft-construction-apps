ILR.Views ?= {}
class ILR.Views.ParametersAside extends ILR.Views.BaseAside
  render: =>
    @$el.addClass('scroll-y')
    subview = @subviews.form = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix()
    @$el.html(subview.render().el)

    this
