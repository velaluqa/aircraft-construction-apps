ILR.LaminateDeformation ?= {}
ILR.LaminateDeformation.Views ?= {}
class ILR.LaminateDeformation.Views.App extends ILR.Views.BaseApp
  asideViews: [
    { name: 'scene', view: 'ILR.LaminateDeformation.Views.SceneAside' }
    { name: 'parameters', view: 'ILR.Views.ParametersAside' }
  ]

  useHeadup: true
  graphView: 'ILR.LaminateDeformation.Views.Graph'
  legendView: 'ILR.Views.Legend'
