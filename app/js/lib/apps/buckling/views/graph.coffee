ILR.Buckling ?= {}
ILR.Buckling.Views ?= {}
class ILR.Buckling.Views.Graph extends ILR.Views.InterpolatedGraph

  beforeRenderCurves: (resultCurves) ->
    if resultCurves.length > 0
      @context.font = "12px Roboto"
      @context.strokeStyle = '#999'
      @context.textBaseline = 'middle'
      @context.lineWidth = 2
      @renderHorizontalLines(resultCurves[0].yRange)
      @renderXDecoration(resultCurves)

  _yMin: (yRange, stiffenings = @model.get('stiffenings')) =>
    n = stiffenings + 1
    k = @model.get('yx_ratio')
    if k < 0.5
      yMinVal = (4 - 4 * k) * n * n
    else
      yMinVal = n * n / k
    [yMinVal, @yOrigin - yMinVal * @height / yRange]

  renderHorizontalLines: (yRange) ->
    return if @xOrigin > @width + 30

    stiffeningsSettings = ILR.settings.buckling.formFields.stiffenings
    if stiffeningsSettings.slider?
      range = stiffeningsSettings.slider.range
    else
      range = stiffeningsSettings.range

    @context.textAlign = 'right'

    for stiffenings in [range[0]..range[1]]
      [yMinVal, yMin] = @_yMin(yRange, stiffenings)

      return if yMin < 0
      continue if yMin > @height

      # horizontal lines
      unless @xOrigin > @width
        @context.beginPath()
        @context.setLineDash [2, 2]
        @context.moveTo(@xOrigin, yMin)
        @context.lineTo(@width, yMin)
        @context.stroke()
        @context.closePath()

      continue if @xOrigin < 0

      # label
      @context.beginPath()
      @context.setLineDash []
      @context.moveTo(@xOrigin, yMin)
      @context.lineTo(@xOrigin - 5, yMin)
      yMinRound = Math.round(yMinVal * 100) / 100
      if Math.abs(yMinRound - yMinVal) < 0.0001
        yMinLabel = yMinRound
      else
        yMinLabel = "≈#{yMinRound}"
      @context.fillText(yMinLabel, @xOrigin - 10, yMin)
      @context.stroke()
      @context.closePath()

  REGEXP: /^bucklingValue_(\d+)$/
  ARROW_SIZE: 5

  renderXDecoration: (resultCurves) ->
    yRange = resultCurves[0].yRange
    [yMinVal, yMin] = @_yMin(yRange)

    @context.textAlign = 'center'

    # minimums
    for resultCurve in resultCurves
      if matchData = resultCurve.curve.get('function').match(@REGEXP)
        bucklings = parseInt(matchData[1])
        calc = @model.get('calculators')[0]
        xMinVal = calc["xMin"](bucklings)
        break if xMinVal is Infinity
        xMin = @xOrigin + xMinVal * @width / @xRange
        yVal = calc["bucklingValue_#{bucklings}_value"](xMinVal)
        y = @yOrigin - yVal * @height / yRange
        unless @yOrigin < 0
          # vertical line
          @context.beginPath()
          @context.setLineDash [2, 2]
          @context.moveTo(xMin, Math.max(Math.min(@yOrigin, @height - 25), y + 45))
          @context.lineTo(xMin, y)
          @context.stroke()
          @context.closePath()
        unless @yOrigin < -30
          # label
          @context.beginPath()
          @context.setLineDash []
          @context.moveTo(xMin, Math.max(Math.min(@yOrigin, @height - 25), y + 45))
          @context.lineTo(xMin, Math.max(Math.min(@yOrigin + 5, @height - 20), y + 50))
          @context.stroke()
          @context.closePath()
          xMinValRounded = Math.round(xMinVal * 100) / 100
          if xMinValRounded isnt xMinVal
            label = "≈#{xMinValRounded}"
          else
            label = "#{xMinValRounded}"
          @context.fillText(label, xMin, Math.max(Math.min(@yOrigin + 15, @height - 10), y + 60))

    # boundaries
    yArrow = Math.max(Math.min(@yOrigin - 25, @height - 45), yMin + 25)
    bucklingBoundaries = []

    if _.find(resultCurves, (rc) -> rc.curve.get('function') is 'festoon')
      bucklingBoundaries = [1, 2, 3, 4, 5]
    else
      for resultCurve in resultCurves
        if matchData = resultCurve.curve.get('function').match(@REGEXP)
          bucklingBoundaries.push(parseInt(matchData[1]))
      bucklingBoundaries = _.filter bucklingBoundaries, (v) ->
        bucklingBoundaries.indexOf(v+1) > -1
      return if bucklingBoundaries.length is 0
      bucklingBoundaries = bucklingBoundaries.sort()

    bucklingBoundaries = _.map bucklingBoundaries, (bucklingBoundary) ->
      bucklings: bucklingBoundary

    n = @model.get('stiffenings') + 1
    k = @model.get('yx_ratio')
    for i in [0..bucklingBoundaries.length-1]
      bucklings = bucklingBoundaries[i].bucklings
      if k is 0
        x2nVal = bucklings * (bucklings + 1)
        xVal = Math.sqrt(x2nVal) / n
      else
        xVal = @model.get('calculators')[0].xIntersection(bucklings)
      bucklingBoundaries[i].x = x = @xOrigin + xVal * @width / @xRange

      unless @yOrigin < 0
        # vertical lines
        yMaxVal = @model.get('calculators')[0]["bucklingValue_#{bucklings}_value"](xVal)
        yMax = @yOrigin - yMaxVal * @height / yRange
        continue if yMax > @height
        @context.beginPath()
        @context.setLineDash [2, 2]
        @context.moveTo(x, Math.max(Math.min(@yOrigin, @height - 25), yMin + 45))
        @context.lineTo(x, yMax)
        @context.stroke()
        @context.closePath()

        # amount of bucklings
        if i is 0
          sectionStart = @xOrigin
          if bucklings > 1
            label = "≤ #{bucklings} bucklings"
          else
            label = '1 buckling'
          x = @width if isNaN(x)
        else
          continue if isNaN(x)
          sectionStart = bucklingBoundaries[i - 1].x
          if bucklings - bucklingBoundaries[i - 1].bucklings > 1
            label = "#{bucklingBoundaries[i - 1].bucklings + 1} - #{bucklings} bucklings"
          else
            label = "#{bucklings} bucklings"
        @drawBucklingRange(label, yArrow, sectionStart, x)

      unless @yOrigin < -30
        # label
        @context.beginPath()
        @context.setLineDash []
        @context.moveTo(x, Math.max(Math.min(@yOrigin, @height - 25), yMin + 45))
        @context.lineTo(x, Math.max(Math.min(@yOrigin + 5, @height - 20), yMin + 50))
        @context.stroke()
        @context.closePath()
        if k is 0
          quotient = ''
          quotient = " / #{n}" if n > 1
          label = "√#{x2nVal}#{quotient}"
        else
          label = "≈#{Math.round(xVal * 100) / 100}"
        @context.fillText(label, x, Math.max(Math.min(@yOrigin + 15, @height - 10), yMin + 60))

    lastBucklingBoundary = bucklingBoundaries[bucklingBoundaries.length - 1]
    unless isNaN(lastBucklingBoundary.x)
      @drawBucklingRange("≥ #{lastBucklingBoundary.bucklings + 1} bucklings", yArrow, lastBucklingBoundary.x, @width)

  drawBucklingRange: (label, y, xMin, xMax) ->
    unless xMin > @width - 10
      @context.fillText(label, (xMin + xMax) / 2, y + 10)
      @context.beginPath()
      @context.setLineDash []
      @context.moveTo(xMin + 5 + @ARROW_SIZE, y - @ARROW_SIZE)
      @context.lineTo(xMin + 5, y)
      @context.lineTo(xMin + 5 + @ARROW_SIZE, y + @ARROW_SIZE)
      @context.moveTo(xMin + 5, y)
      @context.lineTo(xMax - 5, y)
      @context.lineTo(xMax - 5 - @ARROW_SIZE, y - @ARROW_SIZE)
      @context.moveTo(xMax - 5, y)
      @context.lineTo(xMax - 5 - @ARROW_SIZE, y + @ARROW_SIZE)
      @context.stroke()
      @context.closePath()
