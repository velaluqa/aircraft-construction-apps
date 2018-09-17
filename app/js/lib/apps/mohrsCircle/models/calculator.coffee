# coding: utf-8
ILR.MohrsCircle ?= {}
ILR.MohrsCircle.Models ?= {}
class ILR.MohrsCircle.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  xRange: (func) ->
    Math.max(Math.abs(2*@R()), Math.abs(2*@n1()), Math.abs(2*@n2()))

  yRange: (func) ->
    Math.max(Math.abs(2*@R()), Math.abs(2*@n1()), Math.abs(2*@n2()))

  nx:    @reactive 'nx',    -> @model.get('nx')
  ny:    @reactive 'ny',    -> @model.get('ny')
  nxy:   @reactive 'nxy',   -> @model.get('nxy')
  alpha: @reactive 'alpha', -> @model.get('alpha') * Math.PI/180

  nX:  @reactive 'nX',  -> @nx() * Math.pow(Math.cos(@alpha()), 2) + @ny() * Math.pow(Math.sin(@alpha()), 2) + @nxy() * Math.sin(2 * @alpha())
  nY:  @reactive 'nY',  -> @nx() * Math.pow(Math.sin(@alpha()), 2) + @ny() * Math.pow(Math.cos(@alpha()), 2) - @nxy() * Math.sin(2 * @alpha())
  nXY: @reactive 'nXY', -> - @nx() * 0.5 * Math.sin(2*@alpha()) + @ny() * 0.5 * Math.sin(2*@alpha()) + @nxy() * Math.cos(2*@alpha())
  n1:  @reactive 'n1',  -> ((@nx() + @ny())/2) + Math.sqrt((Math.pow((@nx() - @ny()), 2)/4) + Math.pow(@nxy(), 2))
  n2:  @reactive 'n2',  -> ((@nx() + @ny())/2) - Math.sqrt((Math.pow((@nx() - @ny()), 2)/4) + Math.pow(@nxy(), 2))
  x0:  @reactive 'x0',  ->  (@nx() + @ny()) / 2
  R:   @reactive 'R',   -> (@n1() - @n2()) / 2

  circle: @memoize 'circle', ->
    R = @R()
    {
      radius: R
      center: [@x0(), 0]
      minY: R
      maxY: -R
    }

  sectionForce: @memoize 'sectionForce', ->
    nx  = @nx()
    ny  = @ny()
    nxy = @nxy()
    {
      points: [
        [nx,    0, nx,  nxy],
        [nx,  nxy, ny, -nxy],
        [ny, -nxy, ny,    0]
      ]
      minY: 0
      maxY: 0
      tension: 0
      multiplePaths: true
    }

  transformedSectionForce: @memoize 'transformedSectionForce', ->
    nX  = @nX()
    nY  = @nY()
    nXY = @nXY()
    return {
      points: [
        [nX,    0, nX,  nXY],
        [nX,  nXY, nY, -nXY],
        [nY, -nXY, nY, 0]
      ]
      minY: 0
      maxY: 0
      tension: 0
      multiplePaths: true
    }
