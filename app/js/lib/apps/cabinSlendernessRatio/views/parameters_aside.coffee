ILR.CabinSlendernessRatio ?= {}
ILR.CabinSlendernessRatio.Views ?= {}
class ILR.CabinSlendernessRatio.Views.ParametersAside extends ILR.Views.BaseAside
  render: =>
    @$el.addClass('scroll-y')
    subview = @subviews.form = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      group:
        by: 'group'
        collapsible: true
        collapsed: (g) -> g isnt 'abreast'
      localePrefix: @model.localePrefix()
    @$el.html(subview.render().el)

    this
