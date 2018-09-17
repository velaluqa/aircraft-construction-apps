ILR.Models ?= {}
class ILR.Models.BaseApp extends ILR.Models.BaseAppModel
  hasHelpText: true

  initialize: (options = {}) ->
    @parentApp = options.parentApp

    @on 'change:path', @handlePath
    @set currentAside: @get('currentAside') or null
    @handlePath()

  handlePath: =>
    path = @get('path')?[0]
    if path is 'help'
      @set showHelp: true
    else
      @set showHelp: false

  helpTextName: =>
    @path.replace('/', '_')

  # Initialize the curves attribute with all necessary options.
  #
  # @param [Array] curves curves to add to the curves collection
  # @param [Object] options reached through to collection initialization
  initCurves: (curves, options = {}) ->
    @curves = new ILR.Collections.Curves(curves, options)
