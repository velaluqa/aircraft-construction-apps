ILR.InternationalStandardAtmosphere ?= {}
ILR.InternationalStandardAtmosphere.Models ?= {}
class ILR.InternationalStandardAtmosphere.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  yRange: (func) ->
    @MID_STRATOPAUSE

  xRange: (func) ->
    switch func
      when 'pressure' then @PRESSURE_0
      when 'relativePressure' then 100
      when 'temperature' then @ISA_TEMPERATURE_0 + ILR.settings[@model.name].formFields.deltaTemperature.range[1]
      when 'relativeTemperature' then 100
      when 'density' then @density_value(0)
      when 'relativeDensity' then 100
      when 'speedOfSound' then @speedOfSound_value(0)
      when 'dynamicViscosity' then @dynamicViscosity_value(0)
      when 'kinematicViscosity' then @kinematicViscosity_value(@MID_STRATOPAUSE)

  TROPOPAUSE: 11000
  SUB_STRATOPAUSE: 20000
  MID_STRATOPAUSE: 32000
  PRESSURE_0: 101325
  GRAVITY_FORCE_0: 9.80665
  TROPOSPHERE_DELTA_TEMP: -0.0065
  MID_STRATOSPHERE_DELTA_TEMP: 0.001
  ISA_TEMPERATURE_0: 288.15

  # This value does not incorporate deltaTemperature
  # ISA_TEMPERATURE_0 - TROPOSPHERE_DELTA_TEMP * TROPOPAUSE
  STATIC_TROPOPAUSE_TEMPERATURE: 216.65

  R: 287.05287
  KAPPA: 1.4
  BETA: 0.000001458
  S: 110.4

  deltaTemperature: @reactive 'deltaTemperature', -> @model.get('deltaTemperature')

  temperature0: @reactive 'temperature0', ->
    @ISA_TEMPERATURE_0 + @deltaTemperature()

  seaLevelTemperature: @reactive 'seaLevelTemperature', ->
    @temperature0() - 273.15

  tropopauseTemperature: @memoize 'tropopauseTemperature', ->
    @temperature0() + @TROPOSPHERE_DELTA_TEMP * @TROPOPAUSE

  tropopausePressure: ->
    @pressure_value(@TROPOPAUSE)

  lowerStratopausePressure: ->
    @pressure_value(@SUB_STRATOPAUSE)

  pressure: @memoize 'pressure', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@pressure_value(altitude), altitude)
    return { points: points }

  relativePressure: @memoize 'relativePressure', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@relativePressure_value(altitude), altitude)
    return { points: points }

  density: @memoize 'density', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@density_value(altitude), altitude)
    return { points: points }

  relativeDensity: @memoize 'relativeDensity', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@relativeDensity_value(altitude), altitude)
    return { points: points }

  temperature: @memoize 'temperature', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@temperature_value(altitude), altitude)
    return { points: points }

  relativeTemperature: @memoize 'relativeTemperature', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@relativeTemperature_value(altitude), altitude)
    return { points: points }

  speedOfSound: @memoize 'speedOfSound', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@speedOfSound_value(altitude), altitude)
    return { points: points }

  dynamicViscosity: @memoize 'dynamicViscosity', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@dynamicViscosity_value(altitude), altitude)
    return { points: points }

  kinematicViscosity: @memoize 'kinematicViscosity', ->
    points = []
    for altitude in [0..@MID_STRATOPAUSE] by 1000
      points.push(@kinematicViscosity_value(altitude), altitude)
    return { points: points }

  # The temperature values used to calculate pressure do not
  # incorporate deltaTemperature - this is intentional.
  pressure_value: @reactive 'pressure_value', (altitude) ->
    if altitude <= @TROPOPAUSE
      @PRESSURE_0 * Math.pow(1 + altitude * @TROPOSPHERE_DELTA_TEMP / @ISA_TEMPERATURE_0, - @GRAVITY_FORCE_0 / @TROPOSPHERE_DELTA_TEMP / @R)
    else if altitude <= @SUB_STRATOPAUSE
      @tropopausePressure() * Math.exp(- @GRAVITY_FORCE_0 / @R / @STATIC_TROPOPAUSE_TEMPERATURE * (altitude - @TROPOPAUSE))
    else if altitude <= @MID_STRATOPAUSE
      @lowerStratopausePressure() * Math.pow(1 + @MID_STRATOSPHERE_DELTA_TEMP * (altitude - @SUB_STRATOPAUSE) / @STATIC_TROPOPAUSE_TEMPERATURE, - @GRAVITY_FORCE_0 / @MID_STRATOSPHERE_DELTA_TEMP / @R)
    else
      NaN

  relativePressure_value: @reactive 'relativePressure_value', (altitude) ->
    @pressure_value(altitude) / @PRESSURE_0 * 100

  density_value: @reactive 'density_value', (altitude) ->
    @pressure_value(altitude) / @R / @temperature_value(altitude)

  _density_value_0: @memoize '_density_value_0', ->
    @density_value(0)

  relativeDensity_value: @reactive 'relativeDensity_value', (altitude) ->
    @density_value(altitude) / @_density_value_0() * 100

  temperature_value: @reactive 'temperature_value', (altitude) ->
    if altitude <= @TROPOPAUSE
      @temperature0() + @TROPOSPHERE_DELTA_TEMP * altitude
    else if altitude <= @SUB_STRATOPAUSE
      @tropopauseTemperature()
    else if altitude <= @MID_STRATOPAUSE
      @tropopauseTemperature() + @MID_STRATOSPHERE_DELTA_TEMP * (altitude - @SUB_STRATOPAUSE)
    else
      NaN

  relativeTemperature_value: @reactive 'relativeTemperature_value', (altitude) ->
    @temperature_value(altitude) / @temperature0() * 100

  speedOfSound_value: @reactive 'speedOfSound_value', (altitude) ->
    Math.pow(@temperature_value(altitude) * @R * @KAPPA, 0.5)

  dynamicViscosity_value: @reactive 'dynamicViscosity_value', (altitude) ->
    temperature = @temperature_value(altitude)
    @BETA * Math.pow(temperature, 1.5) / (temperature + @S) * 1000000

  kinematicViscosity_value: @reactive 'kinematicViscosity_value', (altitude) ->
    @dynamicViscosity_value(altitude) / @density_value(altitude)
