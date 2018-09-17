ILR.LaminateDeformation ?= {}
ILR.LaminateDeformation.Views ?= {}
class ILR.LaminateDeformation.Views.SceneAside extends ILR.Views.BaseAside
  render: =>
    formFieldSettings = ILR.settings[@model.name].formFields

    subview = @subviews.form = new Backbone.Poised.Form
      model: @model
      liveForm: true
      parentView: this
      localePrefix: @model.localePrefix()
      fields: [
        { attribute: 'material', options: ['surface', 'wireframe'] }
        $.extend formFieldSettings.xyPsf,
          attribute: 'xyPsf'
        $.extend formFieldSettings.zPsf,
          attribute: 'zPsf'
      ]
    @$el.html(subview.render().el)
    this
