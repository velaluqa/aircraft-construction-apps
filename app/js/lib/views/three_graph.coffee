ILR.Views ?= {}
class ILR.Views.ThreeGraph extends ILR.Views.Canvas
  # A variable that contains temporary information about the pinch
  # or pan action that is currently performed.
  start: {}

  events:
    'pinchstart': 'pinchstart'
    'pinch': 'pinch'
    'pinchend': 'pinchend'
    'mousewheel': 'mousewheel'
    'DOMMouseScroll': 'mousewheel'
    'doubletap': 'resetCanvas'

  initialize: (options = {}) ->
    @params = new Backbone.Model(options.defaults)
    if Modernizr.webgl
      @renderer = new THREE.WebGLRenderer(canvas: @$el[0])
    else
      _.defer -> alert(t('generic.help.messages.noWebGL'))
      @renderer = new THREE.CanvasRenderer(canvas: @$el[0])
    @renderer.setClearColor(0xffffff)

    @camera = new THREE.PerspectiveCamera(45, null, 100, 1000)
    @camera.position.z = 500

    @scene = new THREE.Scene()
    fog = new THREE.Fog(0xffffff, ILR.settings.laminateDeformation.graph.fogMinimumDistance, ILR.settings.laminateDeformation.graph.fogMaximumDistance)
    @scene.fog = fog

    @setCanvasResolution()

    $(window).resize @readCanvasResolution
    @params.on 'change:width change:height', @setCanvasResolution

  readCanvasResolution: =>
    $parent = @$el.parent()
    @params.set
      width: $parent.width()
      height: $parent.height()

  setCanvasResolution: (params) =>
    @renderer.setPixelRatio((window.devicePixelRatio || 1) * 2)

    width = @params.get('width')
    height = @params.get('height')

    @renderer.setSize(width, height)
    @camera.aspect = width / height
    @camera.updateProjectionMatrix()
    @requestRepaint()

  mousewheel: (e) =>
    e.preventDefault()
    if e.originalEvent.wheelDelta > 0 or e.originalEvent.detail < 0
      @camera.zoom += 0.06
    else
      if @camera.zoom > 0.06
        @camera.zoom -= 0.06
    @camera.updateProjectionMatrix()
    @requestRepaint()

  pinchstart: (e) =>
    @start.zoom = @camera.zoom

  pinch: (e) =>
    if @camera.zoom > 0.01 or scale > 1
      @camera.zoom = @start.zoom * e.gesture.scale
    @camera.updateProjectionMatrix()
    @requestRepaint()

  pinchend: (e) =>
    # Do not call pan events on transformend
    @hammer.stop()

  resetCanvas: =>
    @camera.zoom = 1
    @camera.updateProjectionMatrix()
    @requestRepaint()

  render: =>
    @renderer.render(@scene, @camera)

    this
