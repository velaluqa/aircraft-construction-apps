angleDeg = (x1, y1, x2, y2) ->
  dX = x2 - x1
  dY = y2 - y1
  angle = Math.atan(dX / dY) * 180 / Math.PI
  if angle > 0
    if y1 < y2
      angle
    else
      180 + angle
  else
    if x1 < x2
      180 + angle
    else
      360 + angle

ILR.VnDiagram ?= {}
ILR.VnDiagram.Views ?= {}
class ILR.VnDiagram.Views.Graph extends ILR.Views.InterpolatedGraph
  renderAnnotation: (options = {}) ->
    options.angle ||= 0
    @context.save()
    @context.translate(Math.floor(options.x), Math.floor(options.y))
    @context.rotate(-options.angle * Math.PI / 180)
    @context.textBaseline = options.textBaseline or 'bottom'
    @context.textAlign = options.textAlign or 'center'
    @context.translate(0, -5)
    @context.font = options.font or ILR.settings.vnDiagram?.graphAnnotations?.font or '10pt Roboto'
    @context.fillStyle = options.fillStyle or ILR.settings.vnDiagram?.graphAnnotations?.fillStyle or 'black'
    MarkupText.render(@context, options.text)
    @context.restore()

  renderSpeedAnnotations: (resultCurve, resultCurves) ->
    curve = resultCurve.curve
    result = resultCurve.result
    yRange = resultCurve.yRange

    xPos = (x) => @xOrigin + x * @width / @xRange
    yPos = (y) => @yOrigin - (y + @yOffset) * @height / yRange

    # We know there is no other calculator for this app:
    calc = @model.get('calculators')[0]

    funcs = for resultCurve in resultCurves
      resultCurve.curve.get('function')

    speedAnnotationStroke = (x1, y1, x2, y2) =>
      @context.moveTo(xPos(x1), yPos(y1))
      @context.lineTo(xPos(x2), yPos(y2))

    @context.beginPath()
    @context.setLineDash(curve.get('lineDash'))
    if curve.strokeStyle()
      @context.lineWidth = curve.get('lineWidth')
      @context.strokeStyle = curve.strokeStyle()
    fontStyle = curve.get('font')
    @context.font = fontStyle if fontStyle?

    vFL = calc.vFL()
    vFS = calc.vFS()
    vB = calc.vB()
    vC = calc.vC()
    vD = calc.vD()
    vStall = calc.vStall()
    yPos1 = yPos(1)

    containsGustHull = _.contains(funcs, 'gustHull')
    containsNF = _.contains(funcs, 'nF')
    containsNG = _.contains(funcs, 'nG')

    if containsGustHull or containsNF or containsNG
      speedAnnotationStroke(0, 1, vD, 1)

    if _.containsAny(funcs, 'nFTS')
      speedAnnotationStroke(vFS, 0, vFS, calc.nFTS_value(vFS))
      @renderAnnotation
        text: @loadLocale('graphAnnotations.vFS')
        x: xPos(vFS)
        y: yPos(1)
        angle: 90

    if _.containsAny(funcs, 'nFTL')
      speedAnnotationStroke(vFL, 0, vFL, calc.nFTL_value(vFL))
      @renderAnnotation
        text: @loadLocale('graphAnnotations.vFL')
        x: xPos(vFL)
        y: yPos(1)
        angle: 90

    # v{A,H}
    if containsGustHull or containsNF
      vA = calc.vA()
      speedAnnotationStroke(vA, calc.nFmin_value(vA), vA, calc.nFmax_value(vA))
      @renderAnnotation text: @loadLocale('graphAnnotations.vA'), x: xPos(vA), y: yPos1, angle: 90
      vH = calc.vH()
      speedAnnotationStroke(vH, calc.nFmin_value(vH), vH, calc.nFmax_value(vH))
      @renderAnnotation text: @loadLocale('graphAnnotations.vH'), x: xPos(vH), y: yPos1, angle: 90

    # v{B,C,D}
    vBYMin = vBYMax = vCYMin = vCYMax = vDYMin = vDYMax = vStallYMin = undefined
    if containsGustHull or containsNF and containsNG
      vBYMin = Math.min(calc.nFmin_value(vB), calc.nGmin_value(vB))
      vBYMax = Math.max(calc.nFmax_value(vB), calc.nGmax_value(vB))
      vCYMin = Math.min(calc.nFmin_value(vC), calc.nGmin_value(vC))
      vCYMax = Math.max(calc.nFmax_value(vC), calc.nGmax_value(vC))
      vDYMin = Math.min(calc.nFmin_value(vD), calc.nGmin_value(vD))
      vDYMax = Math.max(calc.nFmax_value(vD), calc.nGmax_value(vD))
      vStallYMin = Math.min(calc.nFmin_value(vStall), calc.nGmin_value(vStall))
    else if containsNF
      [vBYMin, vBYMax] = calc.nF_value(vB)
      [vCYMin, vCYMax] = calc.nF_value(vC)
      [vDYMin, vDYMax] = calc.nF_value(vD)
      vStallYMin = calc.nFmin_value(vStall)
    else if containsNG
      [vBYMin, vBYMax] = calc.nG_value(vB)
      [vCYMin, vCYMax] = calc.nG_value(vC)
      [vDYMin, vDYMax] = calc.nG_value(vD)
      vStallYMin = calc.nGmin_value(vStall)
    if vBYMin? and vBYMax?
      speedAnnotationStroke(vB, vBYMin, vB, vBYMax)
      @renderAnnotation text: @loadLocale('graphAnnotations.vB'), x: xPos(vB), y: yPos1, angle: 90
    if vCYMin? and vCYMax?
      speedAnnotationStroke(vC, vCYMin, vC, vCYMax)
      @renderAnnotation text: @loadLocale('graphAnnotations.vC'), x: xPos(vC), y: yPos1, angle: 90
    if vDYMin? and vDYMax?
      speedAnnotationStroke(vD, vDYMin, vD, vDYMax)
      @renderAnnotation text: @loadLocale('graphAnnotations.vD'), x: xPos(vD), y: yPos1, angle: 90
    if vStallYMin?
      speedAnnotationStroke(vStall, 1, vStall, vStallYMin)
      @renderAnnotation text: @loadLocale('graphAnnotations.vStall'), x: xPos(vStall), y: (yPos1 + yPos(vStallYMin)) / 2, angle: 90

    @context.stroke()
    @context.closePath()

  renderGustLineAnnotations: (resultCurve) ->
    curve = resultCurve.curve
    result = resultCurve.result
    yRange = resultCurve.yRange

    xPos = (x) => @xOrigin + x * @width / @xRange
    yPos = (y) => @yOrigin - (y + @yOffset) * @height / yRange

    for subcurve, value of result
      p = value.points

      dX = p[2] - p[0]
      dY = p[3] - p[1]
      angle = angleDeg(xPos(p[0]), yPos(p[1]), xPos(p[2]), yPos(p[3])) + 270

      x = (dX / 2) + p[0]
      y = (dY / 2) + p[1]

      @renderAnnotation
        text: @Present(curve).subcurveLabel(subcurve)
        x: xPos(x)
        y: yPos(y)
        angle: angle

  renderGustHull: (curve) ->
    # We know there is no other calculator for this app:
    calc = @model.get('calculators')[0]

    func = curve.get('function')
    result = calc[func](@xMin, @xMax)
    yRange = @maxRangeY(func)

    xPos = (x) => @xOrigin + x * @width / @xRange
    yPos = (y) => @yOrigin - (y + @yOffset) * @height / yRange

    @context.save()
    @context.beginPath()
    for x, i in result.nFmax when i % 2 is 0
      y = result.nFmax[i + 1]
      if i is 0
        @context.moveTo(xPos(x), yPos(y))
      else
        @context.lineTo(xPos(x), yPos(y))

    points = result.nFmin.slice().reverse()
    for y, i in points when i % 2 is 0
      @context.lineTo(xPos(points[i + 1]), yPos(y))

    @context.closePath()
    @context.fillStyle = ILR.settings.vnDiagram?.curves?.gustHull?.strokeStyle or '#cfcfff'
    @context.fill()
    @context.beginPath()

    for x, i in result.nGmax when i % 2 is 0
      y = result.nGmax[i + 1]
      if i is 0
        @context.moveTo(xPos(x), yPos(y))
      else
        @context.lineTo(xPos(x), yPos(y))

    points = result.nGmin.slice().reverse()
    for y, i in points when i % 2 is 0
      @context.lineTo(xPos(points[i + 1]), yPos(y))

    @context.closePath()

    @context.fillStyle = ILR.settings.vnDiagram?.curves?.gustHull?.strokeStyle or '#cfcfff'
    @context.fill()
    @context.restore()

  # Invoked while rendering after all curves have been drawn.
  #
  # @param [Array] results for each curve
  afterRenderCurves: (resultCurves) ->
    for resultCurve in resultCurves
      if resultCurve.curve.get('function') is 'gustLines'
        @renderGustLineAnnotations(resultCurve)
      if resultCurve.curve.get('function') is 'speedAnnotations'
        @renderSpeedAnnotations(resultCurve, resultCurves)

  beforeRender: ->
    for curve in @model.curves.history when curve.get('function') is 'gustHull'
      @renderGustHull(curve)
