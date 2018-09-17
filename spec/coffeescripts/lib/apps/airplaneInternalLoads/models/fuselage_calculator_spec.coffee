describe 'ILR.AirplaneInternalLoads.Models.FuselageCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      loadCase: 'flight'
      fuselageMass: 5000
      fuselageLength: 20
      relFirstMainFramePosition: 50
      relSecondMainFramePosition: 70
      relGearPosition: 15
      stabilizerLoad: -16000
    @calc = new ILR.AirplaneInternalLoads.Models.FuselageCalculator
      model: @model

  describe 'model attributes', ->
    describe '#loadCase', ->
      it 'should return the correct value', ->
        expect(@calc.loadCase()).toEqual('flight')
    describe '#fuselageMass', ->
      it 'should return the correct value', ->
        expect(@calc.fuselageMass()).toEqual(5000)
    describe '#fuselageLength', ->
      it 'should return the correct value', ->
        expect(@calc.fuselageLength()).toEqual(20)
    describe '#relFirstMainFramePosition', ->
      it 'should return the correct value', ->
        expect(@calc.relFirstMainFramePosition()).toEqual(0.50)
    describe '#relSecondMainFramePosition', ->
      it 'should return the correct value', ->
        expect(@calc.relSecondMainFramePosition()).toEqual(0.70)
    describe '#relGearPosition', ->
      it 'should return the correct value', ->
        expect(@calc.relGearPosition()).toEqual(0.15)
    describe '#stabilizerLoad', ->
      it 'should return the correct value', ->
        expect(@calc.stabilizerLoad()).toEqual(-16000)

  describe '#load', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'

      it 'should return the correct value', ->
        expectRounded(@calc.load(), 0).toEqual(-2453)
    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'

      it 'should return the correct value', ->
        expectRounded(@calc.load(), 0).toEqual(-2453)

  describe '#loadA', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'

      it 'should return the correct value', ->
        expectRounded(@calc.loadA(), 0).toEqual(25050)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'

      it 'should return the correct value', ->
        expectRounded(@calc.loadA(), 0).toEqual(9109)

  describe '#loadB', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'

      it 'should return the correct value', ->
        expectRounded(@calc.loadB(), 0).toEqual(40000)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'

      it 'should return the correct value', ->
        expectRounded(@calc.loadB(), 0).toEqual(55941)

  describe '#Q_value', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'

      it 'should return the correct value', ->
        expectRounded(@calc.Q_value(0.00), 0).toBe(0)
        expectRounded(@calc.Q_value(0.05), 0).toBe(-2453)
        expectRounded(@calc.Q_value(0.10), 0).toBe(-4905)
        expectRounded(@calc.Q_value(0.15), 0).toBe(-7358)
        expectRounded(@calc.Q_value(0.20), 0).toBe(-9810)
        expectRounded(@calc.Q_value(0.25), 0).toBe(-12263)
        expectRounded(@calc.Q_value(0.30), 0).toBe(-14715)
        expectRounded(@calc.Q_value(0.35), 0).toBe(-17168)
        expectRounded(@calc.Q_value(0.40), 0).toBe(-19620)
        expectRounded(@calc.Q_value(0.45), 0).toBe(-22073)
        expectRounded(@calc.Q_value(0.50), 0).toBe(525)
        expectRounded(@calc.Q_value(0.55), 0).toBe(-1928)
        expectRounded(@calc.Q_value(0.60), 0).toBe(-4380)
        expectRounded(@calc.Q_value(0.65), 0).toBe(-6833)
        expectRounded(@calc.Q_value(0.70), 0).toBe(30715)
        expectRounded(@calc.Q_value(0.75), 0).toBe(28263)
        expectRounded(@calc.Q_value(0.80), 0).toBe(25810)
        expectRounded(@calc.Q_value(0.85), 0).toBe(23358)
        expectRounded(@calc.Q_value(0.90), 0).toBe(20905)
        expectRounded(@calc.Q_value(0.95), 0).toBe(18453)
        expectRounded(@calc.Q_value(1.00), 0).toBe(16000)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'

      it 'should return the correct value', ->
        expectRounded(@calc.Q_value(0.00), 0).toBe(0)
        expectRounded(@calc.Q_value(0.05), 0).toBe(-2453)
        expectRounded(@calc.Q_value(0.10), 0).toBe(-4905)
        expectRounded(@calc.Q_value(0.15), 0).toBe(1752)
        expectRounded(@calc.Q_value(0.20), 0).toBe(-701)
        expectRounded(@calc.Q_value(0.25), 0).toBe(-3153)
        expectRounded(@calc.Q_value(0.30), 0).toBe(-5606)
        expectRounded(@calc.Q_value(0.35), 0).toBe(-8058)
        expectRounded(@calc.Q_value(0.40), 0).toBe(-10511)
        expectRounded(@calc.Q_value(0.45), 0).toBe(-12963)
        expectRounded(@calc.Q_value(0.50), 0).toBe(-15416)
        expectRounded(@calc.Q_value(0.55), 0).toBe(-17868)
        expectRounded(@calc.Q_value(0.60), 0).toBe(-20321)
        expectRounded(@calc.Q_value(0.65), 0).toBe(-22773)
        expectRounded(@calc.Q_value(0.70), 0).toBe(30715)
        expectRounded(@calc.Q_value(0.75), 0).toBe(28263)
        expectRounded(@calc.Q_value(0.80), 0).toBe(25810)
        expectRounded(@calc.Q_value(0.85), 0).toBe(23358)
        expectRounded(@calc.Q_value(0.90), 0).toBe(20905)
        expectRounded(@calc.Q_value(0.95), 0).toBe(18453)
        expectRounded(@calc.Q_value(1.00), 0).toBe(16000)

  describe '#Q', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'
        @result = @calc.Q()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0,   0,
          0.5, -24525,
          0.5, 525,
          0.7, -9285,
          0.7, 30715,
          1,   16000
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(-24525)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual( 30715)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'
        @result = @calc.Q()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0   , 0,
          0.15, -7358,
          0.15, 1752,
          0.7 , -25226,
          0.7 , 30715,
          1   , 16000
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(-25226)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual( 30715)

  describe '#M_value', ->
    describe 'in flight', ->
      it 'should return the correct values', ->
        expectRounded(@calc.M_value(0.00), 0).toBe(0)
        expectRounded(@calc.M_value(0.05), 0).toBe(-1226)
        expectRounded(@calc.M_value(0.10), 0).toBe(-4905)
        expectRounded(@calc.M_value(0.15), 0).toBe(-11036)
        expectRounded(@calc.M_value(0.20), 0).toBe(-19620)
        expectRounded(@calc.M_value(0.25), 0).toBe(-30656)
        expectRounded(@calc.M_value(0.30), 0).toBe(-44145)
        expectRounded(@calc.M_value(0.35), 0).toBe(-60086)
        expectRounded(@calc.M_value(0.40), 0).toBe(-78480)
        expectRounded(@calc.M_value(0.45), 0).toBe(-99326)
        expectRounded(@calc.M_value(0.50), 0).toBe(-122625)
        expectRounded(@calc.M_value(0.55), 0).toBe(-123326)
        expectRounded(@calc.M_value(0.60), 0).toBe(-126480)
        expectRounded(@calc.M_value(0.65), 0).toBe(-132086)
        expectRounded(@calc.M_value(0.70), 0).toBe(-140145)
        expectRounded(@calc.M_value(0.75), 0).toBe(-110656)
        expectRounded(@calc.M_value(0.80), 0).toBe(-83620)
        expectRounded(@calc.M_value(0.85), 0).toBe(-59036)
        expectRounded(@calc.M_value(0.90), 0).toBe(-36905)
        expectRounded(@calc.M_value(0.95), 0).toBe(-17226)
        expectRounded(@calc.M_value(1.00), 0).toBe(0)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'

      it 'should return the correct value', ->
        expectRounded(@calc.M_value(0.00), 0).toBe(0)
        expectRounded(@calc.M_value(0.05), 0).toBe(-1226)
        expectRounded(@calc.M_value(0.10), 0).toBe(-4905)
        expectRounded(@calc.M_value(0.15), 0).toBe(-11036)
        expectRounded(@calc.M_value(0.20), 0).toBe(-10511)
        expectRounded(@calc.M_value(0.25), 0).toBe(-12438)
        expectRounded(@calc.M_value(0.30), 0).toBe(-16818)
        expectRounded(@calc.M_value(0.35), 0).toBe(-23650)
        expectRounded(@calc.M_value(0.40), 0).toBe(-32935)
        expectRounded(@calc.M_value(0.45), 0).toBe(-44672)
        expectRounded(@calc.M_value(0.50), 0).toBe(-58861)
        expectRounded(@calc.M_value(0.55), 0).toBe(-75504)
        expectRounded(@calc.M_value(0.60), 0).toBe(-94598)
        expectRounded(@calc.M_value(0.65), 0).toBe(-116145)
        expectRounded(@calc.M_value(0.70), 0).toBe(-140145)
        expectRounded(@calc.M_value(0.75), 0).toBe(-110656)
        expectRounded(@calc.M_value(0.80), 0).toBe(-83620)
        expectRounded(@calc.M_value(0.85), 0).toBe(-59036)
        expectRounded(@calc.M_value(0.90), 0).toBe(-36905)
        expectRounded(@calc.M_value(0.95), 0).toBe(-17226)
        expectRounded(@calc.M_value(1.00), 0).toBe(0)

  describe '#M', ->
    describe 'in flight', ->
      beforeEach ->
        @model.set loadCase: 'flight'
        @result = @calc.M()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points[0], 0, 2).toEqual [
          0   , 0,
          0.05, -1226,
          0.1 , -4905,
          0.15, -11036,
          0.2 , -19620,
          0.25, -30656,
          0.3 , -44145,
          0.35, -60086,
          0.4 , -78480,
          0.45, -99326,
          0.5 , -122625
        ]
        expectRoundedArray(@result.points[1], 0, 2).toEqual [
          0.5               , -122625,
          0.52              , -122611,
          0.54              , -122990,
          0.5599999999999999, -123761,
          0.58              , -124924,
          0.6               , -126480,
          0.62              , -128428,
          0.6399999999999999, -130769,
          0.6599999999999999, -133502,
          0.6799999999999999, -136627,
          0.7               , -140145
        ]
        expectRoundedArray(@result.points[2], 0, 2).toEqual [
          0.7               , -140145,
          0.73              , -122157,
          0.76              , -105053,
          0.7899999999999999, -88831,
          0.82              , -73492,
          0.85              , -59036,
          0.88              , -45463,
          0.91              , -32773,
          0.94              , -20966,
          0.97              , -10041,
          1                 , 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(-140145)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(0)

    describe 'at the ground', ->
      beforeEach ->
        @model.set loadCase: 'ground'
        @result = @calc.M()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points[0], 0, 2).toEqual [
          0                  , 0,
          0.015              , -110,
          0.03               , -441,
          0.045              , -993,
          0.06               , -1766,
          0.075              , -2759,
          0.09               , -3973,
          0.10500000000000001, -5408,
          0.12               , -7063,
          0.13499999999999998, -8939,
          0.15               , -11036
        ]
        expectRoundedArray(@result.points[1], 0, 2).toEqual [
          0.15               , -11036,
          0.205              , -10593,
          0.26               , -13118,
          0.31499999999999995, -18610,
          0.37               , -27069,
          0.42499999999999993, -38497,
          0.48               , -52891,
          0.5349999999999999 , -70253,
          0.59               , -90583,
          0.6449999999999999 , -113880,
          0.7                , -140145
        ]
        expectRoundedArray(@result.points[2], 0, 2).toEqual [
          0.7               , -140145,
          0.73              , -122157,
          0.76              , -105053,
          0.7899999999999999, -88831,
          0.82              , -73492,
          0.85              , -59036,
          0.88              , -45463,
          0.91              , -32773,
          0.94              , -20966,
          0.97              , -10041,
          1                 , 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(-140145)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(0)
