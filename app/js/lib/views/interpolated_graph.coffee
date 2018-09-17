ILR.Views ?= {}
class ILR.Views.InterpolatedGraph extends ILR.Views.BaseGraph
  initialize: (options = {}) ->
    super

    @bindCalculatorEvents()

    @model.curves.on 'change:selected', =>
      @bindCalculatorEvents()
      @requestRepaint()

    @model.on 'change:calculators', =>
      @calculateRanges()
      @bindCalculatorEvents()
      @requestRepaint()

    if attr = @params.get('valueAtRangeAttribute')
      @model.on "change:#{attr}", @requestRepaint
    @model.on 'change:axisLabelingForCurve', @requestRepaint

  bindCalculatorEvents: ->
    # Remove current callbacks, add new ones for each curve
    @stopListening()
    for calc in @model.get('calculators')
      for curve in @model.curves.history
        @listenTo calc, "change:#{curve.get('function')}", @requestRepaint

      @listenTo calc, 'change:maxX change:xRange', @calculateRangeX
      @listenTo calc, 'change:maxY change:yRange', @calculateRangeY
      # TODO: Add dynamic dependencies to calculator, so that we can
      # actually only listen to maxY changes and recalculate ranges.
      oldestCurve = @model.curves.history[0]
      if oldestCurve?
        @listenTo calc, "change:#{oldestCurve.get('function')}", @calculateRanges

  maxRangeX: (func, xScale = @params.get('xScale')) =>
    func = @model.get('axisLabelingForCurve')?.get('function') unless func?
    ranges = (calc.xRange(func) for calc in @model.get('calculators'))
    Math.max.apply(Math, ranges) * xScale

  maxRangeY: (func, yScale = @params.get('yScale')) =>
    func = @model.get('axisLabelingForCurve')?.get('function') unless func?
    ranges = (calc.yRange(func) for calc in @model.get('calculators'))
    Math.max.apply(Math, ranges) * yScale

  xAxisValueLabel: (val, stepsize) ->
    @axisLabel(val, stepsize)

  yAxisValueLabel: (val, stepsize) ->
    curve = @model.get('axisLabelingForCurve')
    val = @Present(curve).unitValue(val) if curve?
    @axisLabel(val - @params.get('yOffset'), stepsize)

  genericAxisLabel: (axis) ->
    axisLabel = @params.get("#{axis}AxisLabel")
    return axisLabel.call(this) if axisLabel? and _.isFunction(axisLabel)
    return axisLabel if axisLabel?

    axisLabelLocale = @params.get("#{axis}AxisLabelLocale")
    return @loadLocale(axisLabelLocale) if axisLabelLocale?

    curve = @model.get('axisLabelingForCurve')
    if curve?
      return @Present(curve).fullXAxisLabel() if axis is 'x'
      return @Present(curve).fullYAxisLabel() if axis is 'y'

    @loadLocale("graph.#{axis}AxisLabel", defaultValue: '')

  xAxisLabel: -> @genericAxisLabel('x')
  yAxisLabel: -> @genericAxisLabel('y')

  getControlPoints: (x0, y0, x1, y1, x2, y2, tension) ->
    d01 = Math.sqrt(Math.pow(x1 - x0, 2) + Math.pow(y1 - y0, 2))
    d12 = Math.sqrt(Math.pow(x2 - x1, 2) + Math.pow(y2 - y1, 2))
    fa = tension * d01 / (d01 + d12)
    fb = tension - fa
    p1x = x1 + fa * (x0 - x2)
    p1y = y1 + fa * (y0 - y2)
    p2x = x1 - fb * (x0 - x2)
    p2y = y1 - fb * (y0 - y2)
    [p1x, p1y, p2x, p2y]

  drawSpline: (points, t, closed, xPos = ((x) -> x), yPos = ((y) -> y)) ->
    if points.length <= 4
      @context.moveTo(xPos(points[0]), yPos(points[1]))
      @context.lineTo(xPos(points[2]), yPos(points[3]))
    else
      cp = []
      n = points.length
      points = _.clone(points)
      if closed
        points.push points[0], points[1], points[2], points[3]
        points.unshift points[n - 1]
        points.unshift points[n - 1]
        for i in [0..n] by 2
          cp = cp.concat(@getControlPoints(points[i], points[i+1], points[i+2], points[i+3], points[i+4], points[i+5], t))
        cp = cp.concat(cp[0], cp[1])
        for i in [0..n] by 2
          @context.moveTo(xPos(points[i]), yPos(points[i+1]))
          @context.bezierCurveTo(xPos(cp[2*i-2]), yPos(cp[2*i-1]), xPos(cp[2*i]), yPos(cp[2*i+1]), xPos(points[i+2]), yPos(points[i+3]))
      else
        for i in [0..(n-4)] by 2
          cp = cp.concat(@getControlPoints(points[i], points[i+1], points[i+2], points[i+3], points[i+4], points[i+5], t))

        @context.moveTo(xPos(points[0]), yPos(points[1]))
        @context.quadraticCurveTo(xPos(cp[0]), yPos(cp[1]), xPos(points[2]), yPos(points[3]))
        for i in [2..(n-3)] by 2
          @context.moveTo(xPos(points[i]), yPos(points[i+1]))
          @context.bezierCurveTo(xPos(cp[2*i-2]), yPos(cp[2*i-1]), xPos(cp[2*i]), yPos(cp[2*i+1]), xPos(points[i+2]), yPos(points[i+3]))
        @context.moveTo(xPos(points[n-2]), yPos(points[n-1]))
        @context.quadraticCurveTo(xPos(cp[2*n-10]), yPos(cp[2*n-9]), xPos(points[n-4]), yPos(points[n-3]))

  drawCurve: (points, tension = 0, closed = false, xPos = ((x) -> x), yPos = ((y) -> y)) ->
    if tension is 0
      beginning = true
      for i in [0..points.length] by 2
        if beginning
          beginning = false
          @context.moveTo(xPos(points[i]), yPos(points[i+1]))
        else
          @context.lineTo(xPos(points[i]), yPos(points[i+1]))
    else
      @drawSpline(points, tension, closed, xPos, yPos)

  _sortedCurves: ->
    _.sortBy @model.curves.history, (c) ->
      c.attributes.zIndex

  beforeRenderCurves: (resultCurves) ->
  afterRenderCurves: (resultCurves) ->

  renderCurves: ->
    resultCurves = []
    for calc, i in @model.get('calculators')
      for curve, j in @_sortedCurves()

        func = curve.get('function')
        resultCurves.push
          curve: curve
          result: calc[func](@xMin, @xMax)
          yRange: @maxRangeY(func)
          xRange: @maxRangeX(func)

    @beforeRenderCurves(resultCurves)

    for resultCurve in resultCurves
      curve = resultCurve.curve
      result = resultCurve.result
      yRange = resultCurve.yRange
      xRange = resultCurve.xRange
      if _.isObject(result)
        xPos = (x) => @xOrigin + x * @width / xRange
        yPos = (y) => @yOrigin - (y + @yOffset) * @height / yRange

        if curve.hasSubcurves()
          for name, subcurve of curve.subcurves()
            if result[name].points?
              @renderCurve(subcurve, result[name], xPos, yPos)
            else if result[name].radius?
              @renderCircle(subcurve, result[name], xPos, yPos)
        else
          if result.points?
            @renderCurve(curve, result, xPos, yPos)
          else if result.radius?
            @renderCircle(curve, result, xPos, yPos)

    @afterRenderCurves(resultCurves)

  renderCircle: (curve, result, xPos, yPos) ->
    func = curve.get('function')
    yRange = @maxRangeY(func)
    @context.beginPath()
    width  = Math.abs(xPos(2*result.radius) - @xOrigin)
    height = Math.abs(yPos(2*result.radius) - @yOrigin)
    centerX = xPos(result.center[0])
    centerY = yPos(result.center[1])

    aX = centerX - width/2
    aY = centerY - height/2
    hB = (width / 2) * .5522848
    vB = (height / 2) * .5522848
    eX = aX + width
    eY = aY + height
    mX = aX + width / 2
    mY = aY + height / 2
    @context.moveTo(aX, mY);
    @context.bezierCurveTo(aX, mY - vB, mX - hB, aY, mX, aY);
    @context.bezierCurveTo(mX + hB, aY, eX, mY - vB, eX, mY);
    @context.bezierCurveTo(eX, mY + vB, mX + hB, eY, mX, eY);
    @context.bezierCurveTo(mX - hB, eY, aX, mY + vB, aX, mY);

    @context.setLineDash(curve.get('lineDash'))
    if curve.strokeStyle()
      @context.lineWidth = curve.get('lineWidth')
      @context.strokeStyle = curve.strokeStyle()
      @context.stroke()
    if fillStyle = curve.get('fillStyle')
      @context.fillStyle = fillStyle
      @context.fill()
    @context.closePath()

  renderCurve: (curve, result, xPos, yPos) ->
    @context.beginPath()
    @context.setLineDash(curve.get('lineDash'))
    if result.multiplePaths
      for setOfPoints, i in result.points
        @drawCurve(setOfPoints, result.tension, false, xPos, yPos)
    else
      @drawCurve(result.points, result.tension, false, xPos, yPos)
    if curve.strokeStyle()
      @context.lineWidth = curve.get('lineWidth')
      @context.strokeStyle = curve.strokeStyle()
      @context.stroke()
    if fillStyle = curve.get('fillStyle')
      @context.fillStyle = fillStyle
      @context.fill()
    @context.closePath()

  renderRangeIndicator: ->
    if @params.get('valueAtRangeAttribute') and (valueAtPoint = @model.get(@params.get('valueAtRangeAttribute')))?
      @context.beginPath()
      @context.setLineDash []
      @context.strokeStyle = '#999999'
      @context.lineWidth = 2

      # Border below legend
      @context.moveTo(@width, 0)
      @context.lineTo(0, 0)

      if (axis = @params.get('valueAtRangeAxis')) is 'x'
        # Border next to range handler
        @context.moveTo(0, @height)
        @context.lineTo(@width, @height)
        @context.lineTo(@width, @height-10)

        # Range handler line
        xPos = @xOrigin + valueAtPoint * @width / @xRange
        @context.moveTo(xPos, 0)
        @context.lineTo(xPos, @height)
      else
        # Border next to range handler
        @context.lineTo(0, @height)

        # Range handler line
        yPos = - valueAtPoint * @height / @yRange + @yOrigin
        @context.moveTo(0, yPos)
        @context.lineTo(@width, yPos)
      @context.stroke()
      @context.closePath()

      @context.beginPath()
      # The fillStyle of the triangle should match the color of the
      # background set for the legend and range handler in screen.styl:
      @context.fillStyle = "#f2f2f2"
      @context.lineWidth = 1

      if axis is 'x'
        @context.moveTo(xPos + 8, 0)
        @context.lineTo(xPos, 8)
        @context.lineTo(xPos - 8, 0)
        @context.moveTo(xPos - 8, @height)
        @context.lineTo(xPos, @height - 8)
        @context.lineTo(xPos + 8, @height)
      else
        @context.moveTo(0, yPos - 8)
        @context.lineTo(8, yPos)
        @context.lineTo(0, yPos + 8)
        @context.moveTo(@width, yPos - 8)
        @context.lineTo(@width - 8, yPos)
        @context.lineTo(@width, yPos + 8)
      @context.stroke()
      @context.fill()
      @context.closePath()

  render: =>
    super
    @renderRangeIndicator()
    this
