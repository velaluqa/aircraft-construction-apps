ILR.LaminateDeformation ?= {}
ILR.LaminateDeformation.Views ?= {}
class ILR.LaminateDeformation.Views.Graph extends ILR.Views.ThreeGraph
  AXIS_OVERLAP: 10
  AXIS_LABEL_FONT_SIZE: 8
  SHEAR_LOAD_ARROW_DISTANCE: 5
  SHEAR_LOAD_ARROW_LENGTH: 8
  SHEAR_LOAD_ARROW_WIDTH: 3

  PSF: 100

  start:
    rotation:
      x: 1.9
      y: 0
      z: 2.4

  events: _.defaults
    'pan': 'pan',
    'panstart': 'panstart'
  , ILR.Views.ThreeGraph::events

  hammerjs:
    recognizers: [
      [Hammer.Rotate, { enable: false }],
      [Hammer.Pinch, {}, ['rotate']],
      [Hammer.Swipe,{ enable: false }],
      [Hammer.Pan, { direction: Hammer.DIRECTION_ALL, threshold: 1 }, ['swipe']],
      [Hammer.Tap, { threshold: 5 }],
      [Hammer.Tap, { event: 'doubletap', taps: 2, posThreshold: 20, threshold: 5 }, ['tap']],
      [Hammer.Press, { enable: false }]
    ]

  initialize: ->
    super
    @calc = @model.get('calculators')[0]
    @initializeScene()
    @resetCanvas()
    @model.get('calculators')[0].on 'change:laminate', @updateLaminate
    @model.on 'change:material', @updateLaminate

    if @params.get('width') / @params.get('height') > 1.2
      @camera.zoom = 1
    else
      @camera.zoom = 0.5
    @camera.updateProjectionMatrix()

  initializeScene: ->
    @initializeLaminate()
    @drawNormalLoadArrows()
    @drawShearLoadArrows()
    @drawAxes()
    @updateLaminate()

  initializeLaminate: ->
    @laminateSurfaceMaterial = new THREE.MeshBasicMaterial
      side: THREE.DoubleSide
      color: 0x000000

    @laminateLineMaterial = new THREE.LineBasicMaterial
      color: 0x000000

    @laminate = new THREE.Object3D()
    @laminate.matrixAutoUpdate = @laminate.rotationAutoUpdate = false
    @scene.add(@laminate)
    @laminateMeshes = []

  updateLaminate: =>
    @laminate.remove.apply(@laminate, @laminateMeshes)
    for laminateMesh in @laminateMeshes
      laminateMesh.geometry.dispose()
    @laminateMeshes = []

    # Draw laminate
    quadrants = @calc.laminate()
    if @model.get('material') is 'surface'
      for vertices in quadrants
        geometry = new THREE.Geometry()

        stacks = vertices.length - 1
        sliceCount = vertices[0].length
        slices = sliceCount - 1

        for stack in vertices
          for vertice in stack
            geometry.vertices.push(new THREE.Vector3(vertice[0] * @PSF, vertice[1] * @PSF, vertice[2] * @PSF))

        for i in [0...stacks]
          for j in [0...slices]
            a = i * sliceCount + j
            b = i * sliceCount + j + 1
            c = ( i + 1 ) * sliceCount + j + 1
            d = ( i + 1 ) * sliceCount + j
            geometry.faces.push(new THREE.Face3( a, b, d ))
            geometry.faces.push(new THREE.Face3( b, c, d ))

        mesh = new THREE.Mesh(geometry, @laminateSurfaceMaterial)
        mesh.matrixAutoUpdate = mesh.rotationAutoUpdate = false
        @laminateMeshes.push(mesh)
    else
      for vertices in quadrants

        yLines = []
        for stack in vertices
          geometry = new THREE.Geometry()
          yPoints = for vertice in stack
            new THREE.Vector3(vertice[0] * @PSF, vertice[1] * @PSF, vertice[2] * @PSF)
          yLines.push(yPoints)
          geometry.vertices = yPoints
          lineObject = new THREE.Line(geometry, @laminateLineMaterial)
          lineObject.matrixAutoUpdate = lineObject.rotationAutoUpdate =  false
          @laminateMeshes.push(lineObject)

        for xPoints in _.zip.apply(null, yLines)
          geometry = new THREE.Geometry()
          geometry.vertices = xPoints
          lineObject = new THREE.Line(geometry, @laminateLineMaterial)
          lineObject.matrixAutoUpdate = lineObject.rotationAutoUpdate = false
          @laminateMeshes.push(lineObject)

    @laminate.add.apply(@laminate, @laminateMeshes)

    # Update normal load arrows
    pxMax = _.last(quadrants[0])[0]
    nxMax = _.last(quadrants[1])[0]

    xLoad = @calc.xLoad()
    xLength = @loadToLength(xLoad)
    if @pxLoadArrow.visible = @nxLoadArrow.visible = xLoad isnt 0
      xOffset = if xLoad < 0 then xLength else 0
      @pxLoadArrow.position.set(pxMax[0] * @PSF + xOffset, pxMax[1] * @PSF, pxMax[2] * @PSF)
      @nxLoadArrow.position.set(nxMax[0] * @PSF - xOffset, nxMax[1] * @PSF, nxMax[2] * @PSF)
      @nxLoadArrow.rotation.y = @pxLoadArrow.rotation.y = if xLoad < 0 then Math.PI else 0
      @pxLoadArrow.updateMatrix()
      @nxLoadArrow.updateMatrix()
      @pxLoadArrow.setLength(xLength)
      @nxLoadArrow.setLength(xLength)

    pyMax = _.last(quadrants[0][0])
    nyMax = _.last(quadrants[3][0])

    yLoad = @calc.yLoad()
    yLength = @loadToLength(yLoad)
    if @pyLoadArrow.visible = @nyLoadArrow.visible = yLoad isnt 0
      yOffset = if yLoad < 0 then yLength else 0
      @pyLoadArrow.position.set(pyMax[0] * @PSF, pyMax[1] * @PSF + yOffset, pyMax[2] * @PSF)
      @nyLoadArrow.position.set(nyMax[0] * @PSF, nyMax[1] * @PSF - yOffset, nyMax[2] * @PSF)
      @nyLoadArrow.rotation.z = @pyLoadArrow.rotation.z = if yLoad < 0 then Math.PI else 0
      @pyLoadArrow.updateMatrix()
      @nyLoadArrow.updateMatrix()
      @pyLoadArrow.setLength(yLength)
      @nyLoadArrow.setLength(yLength)

    # Update axes
    edge1 = _.last(_.last(quadrants[0]))
    edge2 = _.last(_.last(quadrants[1]))
    edge3 = _.last(_.last(quadrants[2]))
    edge4 = _.last(_.last(quadrants[3]))
    origin = quadrants[0][0][0]
    xMin = Math.min(edge1[0], edge2[0], edge3[0], edge4[0])
    xMax = Math.max(edge1[0], edge2[0], edge3[0], edge4[0])
    yMin = Math.min(edge1[1], edge2[1], edge3[1], edge4[1])
    yMax = Math.max(edge1[1], edge2[1], edge3[1], edge4[1])
    zMin = Math.min(edge1[2], edge2[2], edge3[2], edge4[2], pxMax[2], nxMax[2], pyMax[2], nyMax[2], origin[2])
    zMax = Math.max(edge1[2], edge2[2], edge3[2], edge4[2], pxMax[2], nxMax[2], pyMax[2], nyMax[2], origin[2])

    @xAxisGeometry.vertices[0].x = xMin * @PSF - @AXIS_OVERLAP
    @xAxisGeometry.vertices[1].x = xMax * @PSF + @AXIS_OVERLAP
    @xCone.position.x = @xAxisGeometry.vertices[1].x + 3
    @yAxisGeometry.vertices[0].y = yMin * @PSF - @AXIS_OVERLAP
    @yAxisGeometry.vertices[1].y = yMax * @PSF + @AXIS_OVERLAP
    @yCone.position.y = @yAxisGeometry.vertices[1].y + 3
    @zAxisGeometry.vertices[0].z = zMin * @PSF - @AXIS_OVERLAP
    @zAxisGeometry.vertices[1].z = zMax * @PSF + @AXIS_OVERLAP
    @zCone.position.z = @zAxisGeometry.vertices[1].z + 3
    @xAxisGeometry.verticesNeedUpdate = @yAxisGeometry.verticesNeedUpdate = @zAxisGeometry.verticesNeedUpdate = true
    @xCone.updateMatrix()
    @yCone.updateMatrix()
    @zCone.updateMatrix()

    @updateAxisLabelRotation()

    # Update shear load arrows
    shearLoad = @calc.shearLoad()
    shearLength = @loadToLength(shearLoad)
    if shearLoad > 0
      stripe = _.last(quadrants[0])
      @updateShearLoadArrow(@shearLoadArrows.px, shearLength, edge1, stripe[stripe.length - 2])
      stripe = _.last(quadrants[2])
      @updateShearLoadArrow(@shearLoadArrows.nx, shearLength, edge3, stripe[stripe.length - 2])
      @updateShearLoadArrow(@shearLoadArrows.py, shearLength, edge1, _.last(quadrants[0][quadrants[0].length - 2]))
      @updateShearLoadArrow(@shearLoadArrows.ny, shearLength, edge3, _.last(quadrants[2][quadrants[2].length - 2]))
    else if shearLoad < 0
      stripe = _.last(quadrants[3])
      @updateShearLoadArrow(@shearLoadArrows.px, shearLength, edge4, stripe[stripe.length - 2])
      stripe = _.last(quadrants[1])
      @updateShearLoadArrow(@shearLoadArrows.nx, shearLength, edge2, stripe[stripe.length - 2])
      @updateShearLoadArrow(@shearLoadArrows.py, shearLength, edge2, _.last(quadrants[1][quadrants[0].length - 2]))
      @updateShearLoadArrow(@shearLoadArrows.ny, shearLength, edge4, _.last(quadrants[3][quadrants[3].length - 2]))
    else
      for side in ['px', 'nx', 'py', 'ny']
        @shearLoadArrows[side].line.visible = @shearLoadArrows[side].triangle.visible = false

    @requestRepaint()

  updateAxisLabelRotation: =>
    @xAxisLabel.position.copy(@xCone.position)
    @xAxisLabel.position.x += @AXIS_OVERLAP
    @laminate.localToWorld(@xAxisLabel.position)
    @xAxisLabel.updateMatrix()

    @yAxisLabel.position.copy(@yCone.position)
    @yAxisLabel.position.y += @AXIS_OVERLAP
    @laminate.localToWorld(@yAxisLabel.position)
    @yAxisLabel.updateMatrix()

    @zAxisLabel.position.copy(@zCone.position)
    @zAxisLabel.position.z += @AXIS_OVERLAP
    @laminate.localToWorld(@zAxisLabel.position)
    @zAxisLabel.updateMatrix()

  drawNormalLoadArrows: ->
    origin = new THREE.Vector3(0, 0, 0)

    # THREE.ArrowHelper(direction, origin, length, hex)
    xLoadColor = @model.curves.find(function: 'xLoad').strokeStyle()
    @pxLoadArrow = new THREE.ArrowHelper(new THREE.Vector3(1, 0, 0), origin, 1, xLoadColor)
    @pxLoadArrow.matrixAutoUpdate = @pxLoadArrow.rotationAutoUpdate = false
    @nxLoadArrow = new THREE.ArrowHelper(new THREE.Vector3(-1, 0, 0), origin, 1, xLoadColor)
    @nxLoadArrow.matrixAutoUpdate = @nxLoadArrow.rotationAutoUpdate = false

    yLoadColor = @model.curves.find(function: 'yLoad').strokeStyle()
    @pyLoadArrow = new THREE.ArrowHelper(new THREE.Vector3(0, 1, 0), origin, 1, yLoadColor)
    @pyLoadArrow.matrixAutoUpdate = @pyLoadArrow.rotationAutoUpdate = false
    @nyLoadArrow = new THREE.ArrowHelper(new THREE.Vector3(0, -1, 0), origin, 1, yLoadColor)
    @nyLoadArrow.matrixAutoUpdate = @nyLoadArrow.rotationAutoUpdate = false
    @laminate.add(@pxLoadArrow, @nxLoadArrow, @pyLoadArrow, @nyLoadArrow)

  drawShearLoadArrows: ->
    color = @model.curves.find(function: 'shearLoad').strokeStyle()
    lineMaterial = new THREE.LineBasicMaterial
      color: color
      linewidth: 2

    triangleMaterial = new THREE.MeshBasicMaterial
      color: color
      side: THREE.DoubleSide

    @shearLoadArrows = {}

    pxLineGeometry = new THREE.Geometry()
    pxLineGeometry.vertices.push(
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
    )
    pxTriangleGeometry = new THREE.Geometry()
    pxTriangleGeometry.vertices.push(
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
    )
    pxTriangleGeometry.faces.push(new THREE.Face3(0, 1, 2))

    @shearLoadArrows.px =
      line:     new THREE.Line(pxLineGeometry, lineMaterial)
      triangle: new THREE.Mesh(pxTriangleGeometry, triangleMaterial)
      distance: { axis: 'x', value: @SHEAR_LOAD_ARROW_DISTANCE }
    @shearLoadArrows.px.line.matrixAutoUpdate = @shearLoadArrows.px.line.rotationAutoUpdate = false
    @shearLoadArrows.px.triangle.matrixAutoUpdate = @shearLoadArrows.px.triangle.rotationAutoUpdate = false
    @laminate.add(@shearLoadArrows.px.line, @shearLoadArrows.px.triangle)

    for side in ['nx', 'py', 'ny']
      @shearLoadArrows[side] =
        line:     new THREE.Line(pxLineGeometry.clone(), lineMaterial)
        triangle: new THREE.Mesh(pxTriangleGeometry.clone(), triangleMaterial)
      @shearLoadArrows[side].line.matrixAutoUpdate = \
      @shearLoadArrows[side].line.rotationAutoUpdate = \
      @shearLoadArrows[side].triangle.matrixAutoUpdate = \
      @shearLoadArrows[side].triangle.rotationAutoUpdate = false
      @laminate.add(@shearLoadArrows[side].line, @shearLoadArrows[side].triangle)

    @shearLoadArrows.nx.distance = { axis: 'x', value: -@SHEAR_LOAD_ARROW_DISTANCE }
    @shearLoadArrows.py.distance = { axis: 'y', value: @SHEAR_LOAD_ARROW_DISTANCE }
    @shearLoadArrows.ny.distance = { axis: 'y', value: -@SHEAR_LOAD_ARROW_DISTANCE }

  updateShearLoadArrow: (arrow, shearLength, edgeVertice, lastVerticeBeforeEdge) ->
    arrow.line.visible = true
    arrow.triangle.visible = true

    lineVertices = arrow.line.geometry.vertices
    triangleVertices = arrow.triangle.geometry.vertices

    # line starts at the edge with some offset
    lineVertices[0].x = edgeVertice[0] * @PSF
    lineVertices[0].y = edgeVertice[1] * @PSF
    lineVertices[0].z = edgeVertice[2] * @PSF
    lineVertices[0][arrow.distance.axis] += arrow.distance.value

    # triangle starts at the same point
    triangleVertices[0].copy(lineVertices[0])

    # calculate direction of line
    direction = new THREE.Vector3(
      lastVerticeBeforeEdge[0] - edgeVertice[0]
      lastVerticeBeforeEdge[1] - edgeVertice[1]
      lastVerticeBeforeEdge[2] - edgeVertice[2]
    )
    direction.normalize()

    triangleVertices[1].copy(lineVertices[0])
    triangleVertices[1].addScaledVector(direction, @SHEAR_LOAD_ARROW_LENGTH)
    triangleVertices[2].copy(triangleVertices[1])
    triangleVertices[2][arrow.distance.axis] += arrow.distance.value

    lineVertices[1].copy(lineVertices[0])
    lineVertices[1].addScaledVector(direction, shearLength)

    arrow.line.geometry.verticesNeedUpdate = arrow.triangle.geometry.verticesNeedUpdate = true

  drawAxes: ->
    color = @model.curves.find(function: 'axes').strokeStyle()
    lineMaterial = new THREE.LineBasicMaterial
      color: color
      linewidth: 2

    coneMaterial = new THREE.MeshBasicMaterial
      color: color

    labelMaterial = new THREE.MeshBasicMaterial(color: color, fog: false)

    # CylinderGeometry(radiusTop, radiusBottom, height, radiusSegments, heightSegments, openEnded, thetaStart, thetaLength)
    coneGeometry = new THREE.CylinderGeometry(0, 1.25, 6, 10, 1)
    @xCone = new THREE.Mesh(coneGeometry, coneMaterial)
    @xCone.matrixAutoUpdate = @xCone.rotationAutoUpdate = false
    @yCone = @xCone.clone()
    @zCone = @xCone.clone()

    @xAxisGeometry = new THREE.Geometry()
    @xAxisGeometry.vertices.push(
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
    )
    xAxis = new THREE.Line(@xAxisGeometry, lineMaterial)
    xAxis.matrixAutoUpdate = xAxis.rotationAutoUpdate = false
    @xCone.rotation.z = Math.PI * 1.5

    @yAxisGeometry = new THREE.Geometry()
    @yAxisGeometry.vertices.push(
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
    )
    yAxis = new THREE.Line(@yAxisGeometry, lineMaterial)
    yAxis.matrixAutoUpdate = yAxis.rotationAutoUpdate = false
    @yCone.rotation.y = Math.PI * 1.5

    @zAxisGeometry = new THREE.Geometry()
    @zAxisGeometry.vertices.push(
      new THREE.Vector3(0, 0, 0)
      new THREE.Vector3(0, 0, 0)
    )
    zAxis = new THREE.Line(@zAxisGeometry, lineMaterial)
    zAxis.matrixAutoUpdate = zAxis.rotationAutoUpdate = false
    @zCone.rotation.x = Math.PI * 0.5

    # Axis labels
    xAxisLabelGeometry = new THREE.TextGeometry 'x',
      size: @AXIS_LABEL_FONT_SIZE
      height: 1
      font: 'droid sans'
    xAxisLabelGeometry.center()
    @xAxisLabel = new THREE.Mesh(xAxisLabelGeometry, labelMaterial)
    @xAxisLabel.matrixAutoUpdate = @xAxisLabel.rotationAutoUpdate = false

    yAxisLabelGeometry = new THREE.TextGeometry 'y',
      size: @AXIS_LABEL_FONT_SIZE
      height: 1
      font: 'droid sans'
    yAxisLabelGeometry.center()
    @yAxisLabel = new THREE.Mesh(yAxisLabelGeometry, labelMaterial)
    @yAxisLabel.matrixAutoUpdate = @yAxisLabel.rotationAutoUpdate = false

    zAxisLabelGeometry = new THREE.TextGeometry 'z',
      size: @AXIS_LABEL_FONT_SIZE
      height: 1
      font: 'droid sans'
    zAxisLabelGeometry.center()
    @zAxisLabel = new THREE.Mesh(zAxisLabelGeometry, labelMaterial)
    @zAxisLabel.matrixAutoUpdate = @zAxisLabel.rotationAutoUpdate = false

    @laminate.add(xAxis, @xCone, yAxis, @yCone, zAxis, @zCone)
    @scene.add(@xAxisLabel, @yAxisLabel, @zAxisLabel)

  panstart: =>
    @start.delta = { x: 0, y: 0}

  pan: (e) =>
    ya = (e.gesture.deltaX - @start.delta.x) / 100
    xa = (e.gesture.deltaY - @start.delta.y) / 100
    a = new THREE.Vector3(xa, ya, 0)
    l = a.length()
    a.normalize()
    @laminate.worldToLocal(a)
    @laminate.rotateOnAxis(a, l)
    @laminate.updateMatrix()
    @laminate.updateMatrixWorld()
    @updateAxisLabelRotation()
    @start.delta.x = e.gesture.deltaX
    @start.delta.y = e.gesture.deltaY
    @requestRepaint()

  pinchstart: (e) =>
    @start.delta = { x: 0, y: 0, z: 0 }
    super(e)

  pinch: (e) =>
    ya = (e.gesture.deltaX - @start.delta.x) / 100
    xa = (e.gesture.deltaY - @start.delta.y) / 100
    za = (@start.delta.z - e.gesture.rotation) / 90 * Math.PI
    a = new THREE.Vector3(xa, ya, za)
    l = a.length()
    a.normalize()
    @laminate.worldToLocal(a)
    @laminate.rotateOnAxis(a, l)
    @laminate.updateMatrix()
    @laminate.updateMatrixWorld()
    @updateAxisLabelRotation()
    @start.delta.x = e.gesture.deltaX
    @start.delta.y = e.gesture.deltaY
    @start.delta.z = e.gesture.rotation
    super(e)

  resetCanvas: =>
    @laminate.rotation.set(@start.rotation.x, @start.rotation.y, @start.rotation.z)
    @laminate.updateMatrix()
    @laminate.updateMatrixWorld()
    @updateAxisLabelRotation()
    if @params.get('width') / @params.get('height') > 1.2
      @camera.zoom = 1
    else
      @camera.zoom = 0.5
    @camera.updateProjectionMatrix()
    @requestRepaint()

  mousewheel: (e) =>
    if window.keys.x or window.keys.y or window.keys.z
      x = if window.keys.x then 1 else 0
      y = if window.keys.y then 1 else 0
      z = if window.keys.z then 1 else 0
      a = new THREE.Vector3(x, y, z)
      a.normalize()
      @laminate.worldToLocal(a)
      if e.originalEvent.wheelDelta > 0 or e.originalEvent.detail < 0
        rotation = 0.06
      else
        rotation = -0.06
      @laminate.rotateOnAxis(a, rotation)
      @laminate.updateMatrix()
      @requestRepaint()
    else
      super(e)

  loadToLength: (load) ->
    Math.sqrt(Math.sqrt(Math.abs(load))) * 20
