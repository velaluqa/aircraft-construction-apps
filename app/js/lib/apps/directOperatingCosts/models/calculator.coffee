ILR.DirectOperatingCosts ?= {}
ILR.DirectOperatingCosts.Models ?= {}
class ILR.DirectOperatingCosts.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['doc', 'airplane', 'costs']))

  # Constants
  g0: -> 9.80665

  # Costs Model Attributes
  p_OE:   @reactive 'p_OE',   -> @costs.get('oemPrice')
  i:      @reactive 'i',      -> @costs.get('interestRate') / 100
  ap:     @reactive 'ap',     -> @costs.get('amortizationPeriod')
  r:      @reactive 'r',      -> @costs.get('residualValue') / 100
  f_Ins:  @reactive 'f_Ins',  -> @costs.get('insuranceRate') / 100
  S_FA:   @reactive 'S_FA',   -> @costs.get('avgSalaryFA')
  S_FC:   @reactive 'S_FC',   -> @costs.get('avgSalaryFC')
  CC:     @reactive 'CC',     -> @costs.get('crewComplement')
  p_F:    @reactive 'p_F',    -> @costs.get('fuelPrice')
  p_L:    @reactive 'p_L',    -> @costs.get('landingPrice')
  p_H:    @reactive 'p_H',    -> @costs.get('handlingPrice')
  B:      @reactive 'B',      -> @costs.get('costBurden')
  LR:     @reactive 'LR',     -> @costs.get('laborRate')
  p_FR:   @reactive 'p_FR',   -> @costs.get('atcPrice')
  tr:     @reactive 'tr',     -> @costs.get('transportRate')

  # Airplane Model Attributes
  predefinedAirplane: @reactive 'predefinedAirplane', -> @airplane.get('predefined')
  m_TOmax:            @reactive 'm_TOmax',            -> @airplane.get('maxTakeOffMass')
  m_Fmax:             @reactive 'm_Fmax',             -> @airplane.get('maxFuelMass')
  m_OE:               @reactive 'm_OE',               -> @airplane.get('operationEmptyMass')
  m_PLmax:            @reactive 'm_PLmax',            -> @airplane.get('maxPayload')
  ldRatio:            @reactive 'ldRatio',            -> @airplane.get('ldRatio')
  sfc:                @reactive 'sfc',                -> @airplane.get('sfc')
  maxRange:           @reactive 'maxRange',           -> @airplane.get('maxRange')
  v:                  @reactive 'v',                  -> @airplane.get('speed')
  SLST:               @reactive 'SLST',               -> @airplane.get('slst')
  N_eng:              @reactive 'N_eng',              -> @airplane.get('engineCount')

  # ---------------------------------------------------------------------------
  # DOC Model Attributes
  # ---------------------------------------------------------------------------
  # Gets the diversion range in km. The value is held as nautical
  # miles inside the model, so we multiply the factor 1,852
  R_div:  @reactive 'R_div',  -> @doc.get('diversionRange') * 1.852
  f_RFc:  @reactive 'f_RFc',  -> @doc.get('fuelReserve') / 100
  # Gets the holding range in km.
  R_hold: @reactive 'R_hold', -> @v() * @doc.get('holdingTime') / 60

  # ---------------------------------------------------------------------------
  # DOC formulas
  # ---------------------------------------------------------------------------
  tripFuel: @reactive 'tripFuel', (m_TO, m_PL) ->
    (m_TO - (m_PL + @m_OE()) * Math.exp( (@R_div() + @R_hold()) / @eta() )) / (1 + @f_RFc())

  eta: @reactive 'eta', ->
    if @predefinedAirplane()
      @maxRange() / Math.log(@m_TOmax() / (@m_TOmax() - @m_Fmax()))
    else if @ldRatio()? and @sfc()
      @v() * 10 * @ldRatio() / (@sfc() * @g0())
    else
      throw new Error('Neither SFC/ldRatio nor maxRange defined to calculate eta.')

  R_max: @reactive 'R_max', ->
    @eta() * Math.log((@m_OE() + @m_Fmax())/@m_OE())

  minX: @reactive 'minX', -> 0
  maxX: @reactive 'maxX', -> @R_max()

  # Returns the maximum value of a calculator function over a certain
  # range between minX and maxX with a given amount of sampling points.
  maxY: (func, minX, maxX, samplingPoints = 10) ->
    unless func? and _.isFunction(this[func])
      throw new Error("#{func} is not a function in calculator")
    samplingRate = (maxX - minX) / samplingPoints
    values = (val for i in [minX..maxX] by samplingRate when (val = this[func](i)) isnt undefined)
    Math.max.apply(this, values)

  minY: (func, minX, maxX, samplingPoints = 10) ->
    unless func? and _.isFunction(this[func])
      throw new Error("#{func} is not a function in calculator")
    samplingRate = (maxX - minX) / samplingPoints
    values = (val for i in [minX..maxX] by samplingRate when (val = this[func](i)) isnt undefined)
    Math.min.apply(this, values)

  # ---------------------------------------------------------------------------
  # RANGE CALCULATION
  # ---------------------------------------------------------------------------
  R: @memoize 'R', (m_TO, m_PL) ->
    @eta() * Math.log(m_TO / (m_TO - @tripFuel(m_TO, m_PL)))

  R_A: @memoize 'R_A', ->
    0

  R_B: @memoize 'R_B', ->
    m_TO = @m_TOmax()
    m_PL = @m_PLmax()
    @R(m_TO, m_PL)

  R_C: @memoize 'R_C', ->
    m_TO = @m_TOmax()
    m_PL = @m_TOmax() - @m_OE() - @m_Fmax()
    @R(m_TO, m_PL)

  R_D: @memoize 'R_D', ->
    m_TO = @m_OE() + @m_Fmax()
    m_PL = 0
    @R(m_TO, m_PL)

  m_ZFmax: @reactive 'm_ZFmax', ->
    @m_OE() + @m_PLmax()

  m_ZPmax: @reactive 'm_ZPmax', ->
    @m_OE() + @m_Fmax()

  m_PLmaxBS: @reactive 'm_PLmaxBS', ->
    @m_TOmax() - @m_OE() - @m_Fmax()

  # ---------------------------------------------------------------------------
  # CURVE CALCULATION
  # ---------------------------------------------------------------------------
  # The payload at point C, which resembles the maximum take-off mass minus
  # the operational empty mass and the maximum fuel mass.
  # Meaning the maximum payload that is possible, when the airplane
  # has the maximum fuel mass loaded.
  m_PLMaxFuel: @reactive 'm_PLMaxFuel', ->
    @m_TOmax() - @m_OE() - @m_Fmax()

  m_TF: @reactive 'm_TF', (range) ->
    if 0 <= range <= @R_D()
      (@m_TO(range) - (@m_OE() + @m_PL(range)) * Math.exp((@R_hold() + @R_div()) / @eta())) / (1 + @f_RFc())
    else null

  m_PL: @reactive 'm_PL', (range) ->
    if 0 <= range <= @R_B()
      @m_PLmax()
    else if @R_B() < range <= @R_C()
      delta = (@m_PLmax() - @m_PLMaxFuel()) / (@R_C() - @R_B())
      @m_PLmax() - (delta * (range - @R_B()))
    else if @R_C() < range <= @R_D()
      delta = - @m_PLMaxFuel() / (@R_D() - @R_C())
      @m_PLMaxFuel() + (delta * (range - @R_C()))
    else null

  m_F: @reactive 'm_F', (range) ->
    if 0 <= range <= @R_B()
      @m_TO(range) - @m_OE() - @m_PL(range)
    else if @R_B() < range <= @R_C()
      @m_TOmax() - @m_OE() - @m_PL(range)
    else if @R_C() < range <= @R_D()
      @m_Fmax()
    else null

  m_RF: @reactive 'm_RF', (range) ->
    if 0 <= range <= @R_D()
      @m_F(range) - @m_TF(range)
    else null

  m_TO: @reactive 'm_TO', (range) ->
    if 0 <= range <= @R_B()
      @m_ZFmax() * Math.exp((@R_hold() + @R_div())/@eta())/((1 + @f_RFc()) * (Math.exp(-range/@eta()) - 1) + 1)
    else if @R_B() < range <= @R_C()
      @m_TOmax()
    else if @R_C() < range <= @R_D()
      @m_OE() + @m_PL(range) + @m_Fmax()
    else null

  # productivity: @reactive 'productivity', (range) ->
  #   if 0 < range <= @R_D()
  #     @m_PL(range) * range
  #   else null

  # productivityPA: @reactive 'productivityPA', (range) ->
  #   if 0 <= range <= @R_D()
  #     @productivity(range) * @flights(range)
  #   else null

  # plFactor: @reactive 'plFactor', (range) ->
  #   if 0 <= range <= @R_D()
  #     @m_PL(range) / (@m_OE() + @m_PL(range) + @fuel(range))
  #   else null

  # meanGrossMass: @reactive 'meanGrossMass', (range) ->
  #   if 0 <= range <= @R_D()
  #     @m_TO(range) - @m_TF(range)/2
  #   else null

  flights: @reactive 'flights', (range) ->
    if 0 <= range <= @R_D()
      6011 / (range / @v() + 1.83)
    else null

  fh: @reactive 'fh', (range) ->
    if 0 <= range <= @R_D()
      range / @v()
    else null

  fhPA: @reactive 'fhPA', (range) ->
    if 0 <= range <= @R_D()
      @fh(range) * @flights(range)
    else null

  # ---------------------------------------------------------------------------
  # DOC - NEW METHOD
  # ---------------------------------------------------------------------------
  a: @reactive 'a', ->
    @i() * (1 - @r() * Math.pow((1 / (1 + @i())), @ap())) / (1 - Math.pow((1 / (1 + @i())), @ap()))

  C: @reactive 'C', (range) ->
    if 0 <= range <= @R_D()
      @C_1() + @C_2(range)
    else null

  C_cap: @reactive 'C_cap', ->
    @p_OE() * @m_OE() * (@a() + @f_Ins())

  C_crew: @reactive 'C_crew', ->
    @CC() * (@S_FA() * @m_PLmax() / 5000 + @S_FC())

  C_1: @reactive 'C_1', ->
    @C_cap() + @C_crew()

  MC_af_mat: @reactive 'MC_af_mat', (range) ->
    if 0 <= range <= @R_D()
      (@m_OE() / 1000) * (0.2 * @fh(range) + 13.7) + 57.5
    else null

  MC_af_per: @reactive 'MC_af_per', (range) ->
    if 0 <= range <= @R_D()
      @LR() * (1 + @B()) * ((0.655 + 0.01 * (@m_OE()/1000)) * @fh(range) + 0.254 + 0.01 * (@m_OE()/1000))
    else null

  MC_eng: @reactive 'MC_eng', (range) ->
    if 0 <= range <= @R_D()
      @N_eng() * (1.5 * @SLST() / 9.81 + 30.5 * @fh(range) + 10.6)
    else null

  MC: @reactive 'MC', (range) ->
    if 0 <= range <= @R_D()
      @MC_af_mat(range) + @MC_af_per(range) + @MC_eng(range)
    else null

  ATC: @reactive 'ATC', (range) ->
    @p_FR() * range * Math.sqrt(@m_TOmax() / 50000)

  C_2: @reactive 'C_2', (range) ->
    if 0 <= range <= @R_D()
      @flights(range) * (@p_F() * @m_TF(range) + @p_H() * @m_PL(range) + @p_L() * @m_TOmax() + @ATC(range) + @MC(range))
    else null

  tko: @reactive 'tko', (range) ->
    if 0 <= range <= @R_D()
      range * @m_PL(range) / 1000
    else null

  sko: @reactive 'sko', (range) ->
    tko = @tko(range)
    flights = @flights(range)
    if tko > 0 and flights > 0
      sko = @C(range) / tko / flights
      return sko if sko < 2
    null

  # ---------------------------------------------------------------------------
  # DOC - OLD METHOD
  # ---------------------------------------------------------------------------
  # ownershipCosts: @reactive 'ownershipCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @p_OE() * @m_OE() * @a() / @flights(range)
  #   else null

  # ownershipCostsPA: @reactive 'ownershipCostsPA', (range) ->
  #   if 0 <= range <= @R_D()
  #     @ownershipCosts(range) * @flights(range)
  #   else null

  # fuelCosts: @reactive 'fuelCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @p_F() * @tripFuel(range)
  #   else null

  # fuelCostsPA: @reactive 'fuelCostsPA', (range) ->
  #   if 0 <= range <= @R_D()
  #     @fuelCosts(range) * @flights(range)
  #   else null

  # mtomCosts: @reactive 'mtomCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @p_MTOM() * @m_TOmax() * @fh(range)
  #   else null

  # mtomCostsPA: @reactive 'mtomCostsPA', (range) ->
  #   if 0 <= range <= @R_D()
  #     @mtomCosts(range) * @flights(range)
  #   else null

  # plCosts: @reactive 'plCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @m_PL(range) * @p_PL()
  #   else null

  # plCostsPA: @reactive 'plCostsPA', (range) ->
  #   if 0 <= range <= @R_D()
  #     @plCosts(range) * @flights(range)
  #   else null

  # totalCosts: @reactive 'totalCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @ownershipCosts(range) + @fuelCosts(range) + @mtomCosts(range) + @plCosts(range)
  #   else null

  # totalCostsPA: @reactive '@owner', (range) ->
  #   if 0 <= range <= @R_D()
  #     @totalCosts(range) * @flights(range)
  #   else null

  # specOwnershipCosts: @reactive 'specOwnershipCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @ownershipCosts(range) / @productivity(range)
  #   else null

  # specFuelCosts: @reactive 'specFuelCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @fuelCosts(range) / @productivity(range)
  #   else null

  # specMtomCosts: @reactive 'specMtomCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @mtomCosts(range) / @productivity(range)
  #   else null

  # specPlCosts: @reactive 'specPlCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @plCosts(range) / @productivity(range)
  #   else null

  # specTotalCosts: @reactive 'specTotalCosts', (range) ->
  #   if 0 <= range <= @R_D()
  #     @totalCosts(range) / @productivity(range)
  #   else null

  # breakEvenPL: @reactive 'breakEvenPL', (range) ->
  #   if @R_A() <= range < @R_C()
  #     @specTotalCosts(range) * @m_PL(range) / @tr()
  #   else if @R_C() <= range <= @R_D()
  #     0
  #   else null
