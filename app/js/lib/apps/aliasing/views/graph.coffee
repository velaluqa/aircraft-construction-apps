ILR.Aliasing ?= {}
ILR.Aliasing.Views ?= {}
class ILR.Aliasing.Views.Graph extends ILR.Views.BaseGraph
  initialize: ->
    super
    @listenTo @model, 'change:frequency change:samplingRate change:phase', @requestRepaint

  maxRangeX: =>
    @params.get('xScale') * 2 * 1.2

  maxRangeY: (func) =>
    @params.get('yScale') * 2 * 1.2

  renderCurves: ->
    width = @params.get('width')
    height = @params.get('height')

    xOrigin = @params.get('xOrigin')
    yOrigin = @params.get('yOrigin')

    xRange = @params.get('xRange')
    yRange = @params.get('yRange')

    xMin = -xOrigin * xRange / width
    xMax = (width - xOrigin) * xRange / width

    yMin = -(height - yOrigin) * yRange / height
    yMax = yOrigin * yRange/height

    phase = @model.get('phase')
    frequency = @model.get('frequency')

    @context.strokeStyle = '#aa0000'
    @context.lineWidth = 3

    xPos = 0
    brokenLine = 1
    plotted = 0
    @context.beginPath()
    xPos = 0
    for xPos in [-2..(width + 3)] by 1/@pixelRatio
      x = xMin + xPos * xRange / width
      y = Math.sin(2 * Math.PI * frequency * x)
      yPos = (yMax - y) * height / yRange

      if brokenLine > 0
        if brokenLine == 1
          @context.moveTo xPos, yPos
        brokenLine -= 1
      else
        @context.lineTo(xPos, yPos)
        plotted += 1

    @context.stroke()
    @context.closePath()

    samplingRate = @model.get('samplingRate')

    samplingStepSize = 1 / samplingRate
    first = true
    samplingPoints = []

    safeSamplingMin = (Math.floor(xMin/samplingStepSize)-2)*samplingStepSize # -2 instead of -1 to ensure visibility of leftmost sampling point with maximum phase offset as well
    safeSamplingMax = (Math.ceil(xMax/samplingStepSize)+1)*samplingStepSize
    samplingStepSizePercent = samplingStepSize / 100
    for x in [safeSamplingMin..safeSamplingMax] by samplingStepSize
      x += phase * samplingStepSizePercent
      xPos = xOrigin + x * width / xRange
      y = Math.sin(2*Math.PI * frequency * (x-1))
      yPos = yOrigin - y * height / yRange
      samplingPoints.push [xPos, yPos]
      @debugCircle(@context, '#0000ff', xPos, yPos, 5);

    @context.beginPath()
    @context.strokeStyle = '#0000ff'
    @context.lineWidth = 3
    @context.moveTo(samplingPoints[0][0], samplingPoints[0][1]) if samplingPoints[0]?
    for point in samplingPoints
      @context.lineTo(point[0], point[1])

    @context.stroke()
    @context.closePath()
