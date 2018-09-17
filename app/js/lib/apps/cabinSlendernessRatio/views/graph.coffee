ILR.CabinSlendernessRatio ?= {}
ILR.CabinSlendernessRatio.Views ?= {}
class ILR.CabinSlendernessRatio.Views.Graph extends ILR.Views.InterpolatedGraph

  REGEXP: /^wlr(?:_(\d+))?$/

  beforeRenderCurves: (resultCurves) ->
    # get topmost points for all wlr curves together with abreast
    curveTops = []
    for resultCurve in resultCurves
      if matchData = resultCurve.curve.get('function').match(@REGEXP)
        if matchData[1]
          abreast = matchData[1]
        else
          abreast = "#{@model.get('m_abreast')}"
        break if $.inArray(abreast, _.map(curveTops, (cT) -> cT.abreast)) >= 0
        points = resultCurve.result.points.length / 2
        xLast = resultCurve.result.points[points * 2 - 2]
        yLast = resultCurve.result.points[points * 2 - 1]
        curveTops.push
          abreast: abreast
          x: @xOrigin + xLast * @width / @xRange
          y: @yOrigin - (yLast + @yOffset) * @height / resultCurve.yRange

    return if curveTops.length < 1

    # sort by x value of last curve point
    curveTops = _.sortBy curveTops, (curveTop) ->
      curveTop.x

    lastX = -1000

    for curveTop, i in curveTops
      xTarget = Math.max(curveTop.x, lastX + 20)
      @context.setLineDash [2, 2]
      @context.beginPath()
      @context.moveTo(curveTop.x, curveTop.y)
      @context.lineTo(xTarget, curveTop.y - 15)
      @context.lineWidth = 1
      @context.strokeStyle = '#000'
      @context.textAlign = 'center'
      @context.textBaseline = 'bottom'
      @context.fillText(curveTop.abreast, xTarget, curveTop.y - 16)
      @context.stroke()
      @context.restore()
      @context.closePath()
      lastX = xTarget

    @context.beginPath()
    @context.textAlign = 'left'
    @context.fillText('abreast', lastX + 50, curveTop.y - 16)
    @context.restore()
    @context.closePath()
