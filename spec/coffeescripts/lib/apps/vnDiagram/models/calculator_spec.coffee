describe 'ILR.VnDiagram.Models.Calculator', ->
  beforeEach ->
    @model = new Backbone.Model
      vdvc60: 'no'
      designSpeed: 235
      aspectRatio: 9.0
      taperRatio: 0.30
      takeOffMass: 25
      maxSurfaceLoad: 500
      fuelFactor: 0.40
      wingSweep: 23
      maxLiftCoefficient: 1.4
      minLiftCoefficient: -0.8
      maxStartLiftCoefficient: 2
      maxLandingLiftCoefficient: 2.5
      altitude: 11
    @calc = new ILR.VnDiagram.Models.Calculator
      model: @model
    @calc.accuracy = 11

  describe 'model attributes', ->
    describe '#vdvc60', ->
      it 'should return the correct value', ->
        expect(@calc.vdvc60()).toEqual('no')
    describe '#designSpeed', ->
      it 'should return the correct value', ->
        expect(@calc.designSpeed()).toEqual(235)
    describe '#aspectRatio', ->
      it 'should return the correct value', ->
        expect(@calc.aspectRatio()).toEqual(9.0)
    describe '#taperRatio', ->
      it 'should return the correct value', ->
        expect(@calc.taperRatio()).toEqual(0.30)
    describe '#takeOffMass', ->
      it 'should return the correct value', ->
        expect(@calc.takeOffMass()).toEqual(25)
    describe '#maxSurfaceLoad', ->
      it 'should return the correct value', ->
        expect(@calc.maxSurfaceLoad()).toEqual(500)
    describe '#fuelFactor', ->
      it 'should return the correct value', ->
        expect(@calc.fuelFactor()).toEqual(0.40)
    describe '#wingSweep', ->
      it 'should return the correct value', ->
        expect(@calc.wingSweep()).toEqual(23)
    describe '#maxLiftCoefficient', ->
      it 'should return the correct value', ->
        expect(@calc.maxLiftCoefficient()).toEqual(1.4)
    describe '#minLiftCoefficient', ->
      it 'should return the correct value', ->
        expect(@calc.minLiftCoefficient()).toEqual(-0.8)
    describe '#maxStartLiftCoefficient', ->
      it 'should return the correct value', ->
        expect(@calc.maxStartLiftCoefficient()).toEqual(2)
    describe '#maxLandingLiftCoefficient', ->
      it 'should return the correct value', ->
        expect(@calc.maxLandingLiftCoefficient()).toEqual(2.5)
    describe '#altitude', ->
      it 'should return the correct value', ->
        expect(@calc.altitude()).toEqual(11)

  describe '#liftIncrease', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.liftIncrease(), 2).toEqual(6.53)

  describe '#planeMassRatio', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.planeMassRatio(), 2).toEqual(52.96)

  describe '#blastReductionRatio', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.blastReductionRatio(), 2).toEqual(0.80)

  describe '#vA', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.vA(), 0).toEqual(120)

  describe '#vB', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.vB(), 0).toEqual(114)

  describe '#vC', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.vC(), 0).toEqual(235)

  describe '#vH', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.vH(), 0).toEqual(100)

  describe '#vD', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.vD(), 0).toEqual(307)
      @model.set vdvc60: 'yes'
      expectRounded(@calc.vD(), 0).toEqual(266)

  describe '#maxLoadFactor', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.maxLoadFactor(), 2).toEqual(2.5)

  describe '#minLoadFactor', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.minLoadFactor(), 2).toEqual(-1)

  describe '#vFS', ->
    it 'should return the correct value', ->
      expectRounded(@calc.vFS(), 1).toEqual(89.4)

  describe '#vFCS', ->
    it 'should return the correct value', ->
      expectRounded(@calc.vFCS(), 1).toEqual(143.1)

  describe '#landingSurfaceLoad', ->
    it 'should return the correct value', ->
      expectRounded(@calc.landingSurfaceLoad(), 1).toEqual(400)

  describe '#vFL', ->
    it 'should return the correct value', ->
      expectRounded(@calc.vFL(), 1).toEqual(71.6)

  describe '#vFCL', ->
    it 'should return the correct value', ->
      expectRounded(@calc.vFCL(), 1).toEqual(128.8)

  describe '#uB', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.uB(), 2).toEqual(15.55)

  describe '#uC', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.uC(), 2).toEqual(11.15)

  describe '#uD', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.uD(), 2).toEqual(5.58)

  describe '#nFTS_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.nFTS_value(0.00),  2).toBe(0.00)
      expectRounded(@calc.nFTS_value(8.13),  2).toBe(0.02)
      expectRounded(@calc.nFTS_value(16.26), 2).toBe(0.07)
      expectRounded(@calc.nFTS_value(24.39), 2).toBe(0.15)
      expectRounded(@calc.nFTS_value(32.52), 2).toBe(0.26)
      expectRounded(@calc.nFTS_value(40.66), 2).toBe(0.41)
      expectRounded(@calc.nFTS_value(48.79), 2).toBe(0.60)
      expectRounded(@calc.nFTS_value(56.92), 2).toBe(0.81)
      expectRounded(@calc.nFTS_value(65.05), 2).toBe(1.06)
      expectRounded(@calc.nFTS_value(73.18), 2).toBe(1.34)
      expectRounded(@calc.nFTS_value(81.31), 2).toBe(1.65)
      expectRounded(@calc.nFTS_value(89.44), 2).toBe(2.00)
      expectRounded(@calc.nFTS_value(143.1), 2).toBe(2.00)

  describe '#nFTS', ->
    beforeEach ->
      @result = @calc.nFTS()

    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 2).toEqual [
        0.00,   0.00,
        8.13,   0.02,
        16.26,  0.07,
        24.39,  0.15,
        32.52,  0.26,
        40.66,  0.41,
        48.79,  0.60,
        56.92,  0.81,
        65.05,  1.06,
        73.18,  1.34,
        81.31,  1.65,
        89.44,  2.00,
        143.11, 2.00,
        143.11, 0.00
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(2)

  describe '#nFTL_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.nFTL_value(0.00),   2).toBe(0.00)
      expectRounded(@calc.nFTL_value(6.50),   2).toBe(0.02)
      expectRounded(@calc.nFTL_value(13.01),  2).toBe(0.07)
      expectRounded(@calc.nFTL_value(19.51),  2).toBe(0.15)
      expectRounded(@calc.nFTL_value(26.02),  2).toBe(0.26)
      expectRounded(@calc.nFTL_value(32.52),  2).toBe(0.41)
      expectRounded(@calc.nFTL_value(39.03),  2).toBe(0.60)
      expectRounded(@calc.nFTL_value(45.53),  2).toBe(0.81)
      expectRounded(@calc.nFTL_value(52.04),  2).toBe(1.06)
      expectRounded(@calc.nFTL_value(58.54),  2).toBe(1.34)
      expectRounded(@calc.nFTL_value(65.05),  2).toBe(1.65)
      expectRounded(@calc.nFTL_value(71.55),  2).toBe(2.00)
      expectRounded(@calc.nFTL_value(128.79), 2).toBe(2.00)

  describe '#nFTL', ->
    beforeEach ->
      @result = @calc.nFTL()

    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 2).toEqual [
        0.00,   0.00,
        6.50,   0.02,
        13.01,  0.07,
        19.51,  0.15,
        26.02,  0.26,
        32.52,  0.41,
        39.03,  0.60,
        45.53,  0.81,
        52.04,  1.06,
        58.54,  1.34,
        65.05,  1.65,
        71.55,  2.00,
        71.55,  2.00,
        128.80, 2.00,
        128.80, 0.00
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(2)

  describe '#nFmax_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.nFmax_value(0.0),   2).toBe(0.00)
      expectRounded(@calc.nFmax_value(10.9),  2).toBe(0.02)
      expectRounded(@calc.nFmax_value(21.7),  2).toBe(0.08)
      expectRounded(@calc.nFmax_value(32.6),  2).toBe(0.19)
      expectRounded(@calc.nFmax_value(43.5),  2).toBe(0.33)
      expectRounded(@calc.nFmax_value(54.3),  2).toBe(0.52)
      expectRounded(@calc.nFmax_value(65.2),  2).toBe(0.74)
      expectRounded(@calc.nFmax_value(76.1),  2).toBe(1.01)
      expectRounded(@calc.nFmax_value(86.9),  2).toBe(1.32)
      expectRounded(@calc.nFmax_value(97.8),  2).toBe(1.67)
      expectRounded(@calc.nFmax_value(108.7), 2).toBe(2.07)
      expectRounded(@calc.nFmax_value(119.5), 2).toBe(2.50)
      expectRounded(@calc.nFmax_value(235.0), 2).toBe(2.50)
      expectRounded(@calc.nFmax_value(306.8), 2).toBe(2.50)
      expect(@calc.nFmax_value(307)).toBe(undefined)

    it 'should handle max limit (vD) well', ->
      expectRounded(@calc.nFmax_value(@calc.vD()), 2).toBe(2.50)

  describe '#nFmax', ->
    beforeEach ->
      @result = @calc.nFmax()

    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 2).toEqual [
        0.00,   0.00,
        10.87,  0.02,
        21.73,  0.08,
        32.60,  0.19,
        43.46,  0.33,
        54.33,  0.52,
        65.19,  0.74,
        76.06,  1.01,
        86.93,  1.32,
        97.79,  1.67,
        108.66, 2.07,
        119.52, 2.50,
        119.52, 2.50,
        306.78, 2.50,
        306.78, 0.00
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(3)

  describe '#nFmin_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.nFmin_value(0.00), 2).toBe(0.00)
      expectRounded(@calc.nFmin_value(9.09), 2).toBe(-0.01)
      expectRounded(@calc.nFmin_value(18.18), 2).toBe(-0.03)
      expectRounded(@calc.nFmin_value(27.27), 2).toBe(-0.07)
      expectRounded(@calc.nFmin_value(36.36), 2).toBe(-0.13)
      expectRounded(@calc.nFmin_value(45.45), 2).toBe(-0.21)
      expectRounded(@calc.nFmin_value(54.55), 2).toBe(-0.30)
      expectRounded(@calc.nFmin_value(63.64), 2).toBe(-0.41)
      expectRounded(@calc.nFmin_value(72.73), 2).toBe(-0.53)
      expectRounded(@calc.nFmin_value(81.82), 2).toBe(-0.67)
      expectRounded(@calc.nFmin_value(90.91), 2).toBe(-0.83)
      expectRounded(@calc.nFmin_value(100.00), 2).toBe(-1.00)
      expectRounded(@calc.nFmin_value(235.00), 2).toBe(-1.00)
      expectRounded(@calc.nFmin_value(306.78), 2).toBe(0.00)
      expectRounded(@calc.nFmin_value(306.78), 2).toBe(0.00)

    it 'should handle max limit (vD) well', ->
      expectRounded(@calc.nFmin_value(@calc.vD()), 2).toBe(0)

  describe '#nFmin', ->
    beforeEach ->
      @result = @calc.nFmin()

    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 2).toEqual [
        0.00, 0.00,
        9.09, -0.01,
        18.18, -0.03,
        27.27, -0.07,
        36.36, -0.13,
        45.45, -0.21,
        54.55, -0.30,
        63.64, -0.40,
        72.73, -0.53,
        81.82, -0.67,
        90.91, -0.83,
        100.00, -1.00,
        235.00, -1.00,
        306.78, 0.00
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(-1)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(0)

  describe '#nGmax_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.nGmax_value(0.00), 2).toBe(null)
      expectRounded(@calc.nGmax_value(10.38), 2).toBe(null)
      expectRounded(@calc.nGmax_value(20.75), 2).toBe(null)
      expectRounded(@calc.nGmax_value(31.13), 2).toBe(null)
      expectRounded(@calc.nGmax_value(41.51), 2).toBe(null)
      expectRounded(@calc.nGmax_value(51.88), 2).toBe(null)
      expectRounded(@calc.nGmax_value(62.26), 2).toBe(0.68)
      expectRounded(@calc.nGmax_value(72.64), 2).toBe(0.92)
      expectRounded(@calc.nGmax_value(83.02), 2).toBe(1.21)
      expectRounded(@calc.nGmax_value(93.39), 2).toBe(1.53)
      expectRounded(@calc.nGmax_value(103.77), 2).toBe(1.88)
      expectRounded(@calc.nGmax_value(114.15), 2).toBe(2.28)
      expectRounded(@calc.nGmax_value(175.00), 2).toBe(2.50)
      expectRounded(@calc.nGmax_value(235.00), 2).toBe(2.71)
      expectRounded(@calc.nGmax_value(260.50), 2).toBe(2.50)
      expectRounded(@calc.nGmax_value(306.78), 2).toBe(2.12)

    it 'should handle max limit (vD) well', ->
      expectRounded(@calc.nGmax_value(@calc.vD()), 2).toBe(2.12)

  describe '#nGmax', ->
    beforeEach ->
      @result = @calc.nGmax()

    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 2).toEqual [
        51.95, 0.47,
        62.33, 0.68,
        72.70, 0.93,
        83.08, 1.21,
        93.46, 1.53,
        103.84, 1.89,
        114.15, 2.28,
        235.00, 2.71,
        306.78, 2.12,
        306.78, 0.00,
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(3)

  describe '#nGmin_value', ->
    describe 'with limit being less than vB', ->
      it 'should return the correct value', ->
        limit = @calc.nGmin_limit()
        expectRounded(limit).toBe(51.9512)
        expectRounded(@calc.nGmin_value(0.00), 2).toBe(null) # edge
        expectRounded(@calc.nGmin_value(Math.floor(limit)), 2).toBe(null) # inbetween
        expectRounded(@calc.nGmin_value(114.15), 2).toBe(-0.16) # edge
        expectRounded(@calc.nGmin_value(188.00), 2).toBe(-0.50) # inbetween
        expectRounded(@calc.nGmin_value(235.00), 2).toBe(-0.71) # edge
        expectRounded(@calc.nGmin_value(260.50), 2).toBe(-0.50) # inbetween
        expectRounded(@calc.nGmin_value(306.78), 2).toBe(-0.12) # edge

      it 'should handle max limit (vD) well', ->
        expectRounded(@calc.nGmin_value(@calc.vD()), 2).toBe(-0.12)

    describe 'with limit being larger than vB', ->
      beforeEach ->
        @model.set maxLiftCoefficient: 0.3

      it 'should return the correct value', ->
        limit = @calc.nGmin_limit()
        expectRounded(limit).toBe(61.5148)
        expectRounded(@calc.nGmin_value(50), 2).toBe(null) # < limit
        expectRounded(@calc.nGmin_value(limit), 2).toBe(0.49) # edge
        expectRounded(@calc.nGmin_value(188.00), 2).toBe(-0.39) # inbetween
        expectRounded(@calc.nGmin_value(235.00), 2).toBe(-0.71) # edge
        expectRounded(@calc.nGmin_value(260.50), 2).toBe(-0.50) # inbetween
        expectRounded(@calc.nGmin_value(306.78), 2).toBe(-0.12) # edge

      it 'should handle max limit (vD) well', ->
        expectRounded(@calc.nGmin_value(@calc.vD()), 2).toBe(-0.12)

  describe '#nGmin', ->
    describe 'with limit being less than vB', ->
      beforeEach ->
        @result = @calc.nGmin()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 2).toEqual [
            51.95,   0.47,
            114.15, -0.16,
            235,    -0.71,
            306.78, -0.12,
            306.78, 0.00
          ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 2).toEqual(-0.71)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 2).toEqual(0.47)

    describe 'with limit being larger than vB', ->
      beforeEach ->
        @model.set maxLiftCoefficient: 0.3
        @result = @calc.nGmin()

      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 2).toEqual [
          61.51,   0.49,
          235,    -0.71,
          306.78, -0.12,
          306.78, 0.00
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 2).toEqual(-0.71)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 2).toEqual(0.49)
