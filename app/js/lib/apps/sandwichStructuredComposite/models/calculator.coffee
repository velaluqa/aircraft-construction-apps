ILR.SandwichStructuredComposite ?= {}
ILR.SandwichStructuredComposite.Models ?= {}
class ILR.SandwichStructuredComposite.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: (func) -> 20
  xRange: (func) -> @length()

  accuracy: 50

  width:              @reactive 'width',              -> @model.get('width')
  length:             @reactive 'length',             -> @model.get('length')
  height:             @reactive 'height',             -> @model.get('height')
  skinRatio:          @reactive 'skinRatio',          -> @model.get('skinRatio') / 100
  load:               @reactive 'load',               -> @model.get('load') / 1000
  elasticModulusSkin: @reactive 'elasticModulusSkin', -> @model.get('elasticModulusSkin') * 1000
  shearModulusCore:   @reactive 'shearModulusCore',   -> @model.get('shearModulusCore')

  w_stress_value: @reactive 'w_stress_value', (x) ->
    length = @length()
    return NaN if x < 0 or x > length
    - @load() * length * x * (length - x) / 2 / @shearModulusCore() / @width() / @height() / @height()

  w_beam_value: @reactive 'w_beam_value', (x) ->
    length = @length()
    return NaN if x < 0 or x > length
    length2 = length * length
    length3 = length2 * length
    height = @height()
    height3 = height * height * height
    x3 = x * x * x
    - @load() * length3 / 12 / @elasticModulusSkin() / @width() / @skinRatio() / height3 * (x - 2 * x3 / length2 + x3 * x / length3)

  w_total_value: @reactive 'w_total_value', (x) ->
    return NaN if x < 0 or x > @length()
    @w_stress_value(x) + @w_beam_value(x)

  w_stress: @memoize 'w_stress', (x) ->
    points = []
    length = @length()

    for i in [0..@accuracy]
      x = i / @accuracy * length
      points.push x, @w_stress_value(x)

    return {
      points: points
      tension: 0.5
    }

  w_beam: @memoize 'w_beam', (x) ->
    points = []
    length = @length()

    for i in [0..@accuracy]
      x = i / @accuracy * length
      points.push x, @w_beam_value(x)

    return {
      points: points
      tension: 0.5
    }

  w_total: @memoize 'w_total', (x) ->
    points = []
    length = @length()

    for i in [0..@accuracy]
      x = i / @accuracy * length
      points.push x, @w_total_value(x)

    return {
      points: points
      tension: 0.5
    }

  w_stress_ratio_value: @reactive 'w_stress_ratio_value', (x) ->
    @w_stress_value(x) / @w_total_value(x)

  w_stress_ratio: -> {}

  core_value_value: @reactive 'core_value_value', (x) ->
    @w_stress_value(x) / @w_beam_value(x)

  core_value: -> {}
