describe 'ILR.LiftDistribution.Models.Calculator', ->
  beforeEach ->
    # create C model
    @liftDistribution = new Backbone.Model
      aspectRatio: 10
      linearTwist: 0.0
      sweep: 0.0
      taperRatio: 0.5
      liftCoefficient: 0.5
      cruisingSpeed: 0.0
      wingSpan: 420
    @calc = new ILR.LiftDistribution.Models.Calculator
      liftDistribution: @liftDistribution
    @calc.accuracy = 10

  describe '#aspectRatio', ->
    it 'should return the model attribute', ->
      expect(@calc.aspectRatio()).toEqual(10)

  describe '#linearTwist', ->
    it 'should return the model attribute', ->
      expect(@calc.linearTwist()).toEqual(0.0)

  describe '#sweep', ->
    it 'should return the model attribute', ->
      expect(@calc.sweep()).toEqual(0.0)

  describe '#taperRatio', ->
    it 'should return the model attribute', ->
      expect(@calc.taperRatio()).toEqual(0.5)

  describe '#liftCoefficient', ->
    it 'should return the model attribute', ->
      expect(@calc.liftCoefficient()).toEqual(0.5)

  describe '#cruisingSpeed', ->
    it 'should return the model attribute', ->
      expect(@calc.cruisingSpeed()).toEqual(0.0)

  describe '#sweepRad', ->
    it 'should return the sweep attribute as rad', ->
      expect(@calc.sweepRad()).toEqual(0)
      @liftDistribution.set sweep: 10
      expectRounded(@calc.sweepRad()).toEqual(0.1745)
      @liftDistribution.set sweep: -20
      expectRounded(@calc.sweepRad()).toEqual(-0.3491)

  describe '#M_Prof', ->
    it 'should return correct values', ->
      expect(@calc.M_Prof()).toEqual(0)
      @liftDistribution.set cruisingSpeed: 0.9
      expect(@calc.M_Prof()).toEqual(0.9)
      @liftDistribution.set sweep: 30
      expectRounded(@calc.M_Prof()).toEqual(0.8375)

  describe '#c_a_', ->
    it 'should return correct values', ->
      expectRounded(@calc.c_a_()).toEqual(6.2832)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.c_a_()).toEqual(14.4146)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.c_a_()).toEqual(11.4999)

  describe '#FF', ->
    it 'should return correct values', ->
      expectRounded(@calc.FF()).toEqual(10)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.FF()).toEqual(4.3589)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.FF()).toEqual(6.3089)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.FF()).toEqual(9.4634)

  describe '#k0', ->
    it 'should return correct values', ->
      expectRounded(@calc.k0()).toEqual(0.8229)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.k0()).toEqual(0.6450)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.k0()).toEqual(0.7394)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.k0()).toEqual(0.8140)

  describe '#k1', ->
    it 'should return correct values', ->
      expectRounded(@calc.k1()).toEqual(0.6849)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.k1()).toEqual(0.5058)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.k1()).toEqual(0.5778)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.k1()).toEqual(0.6717)

  describe '#C_A_', ->
    it 'should return correct values', ->
      expectRounded(@calc.C_A_()).toEqual(5.1704)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.C_A_()).toEqual(9.2980)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.C_A_()).toEqual(7.3638)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.C_A_()).toEqual(8.1068)

  describe '#c1', ->
    it 'should return correct values', ->
      expectRounded(@calc.c1()).toEqual(0.4666)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.c1()).toEqual(0.2297)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.c1()).toEqual(0.3187)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.c1()).toEqual(0.4468)

  describe '#c2', ->
    it 'should return correct values', ->
      expectRounded(@calc.c2()).toEqual(0.1741)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.c2()).toEqual(0.5731)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.c2()).toEqual(0.4156)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.c2()).toEqual(0.2046)

  describe '#c3', ->
    it 'should return correct values', ->
      expectRounded(@calc.c3()).toEqual(0.3594)
      @liftDistribution.set cruisingSpeed: 0.9
      expectRounded(@calc.c3()).toEqual(0.1967)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.c3()).toEqual(0.2660)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30, aspectRatio: 15
      expectRounded(@calc.c3()).toEqual(0.3489)

  describe '#Phi_e', ->
    it 'should return correct values', ->
      expectRounded(@calc.Phi_e()).toEqual(0)
      @liftDistribution.set sweep: 30
      expectRounded(@calc.Phi_e()).toEqual(0.5236)
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRounded(@calc.Phi_e()).toEqual(0.9241)

  describe '#cof', ->
    it 'should return correct array', ->
      expectRoundedArray(@calc.cof()).toEqual([1.2621, 0.0665, 0.3791, -5.9454, 10.4810, -6.2431])
      @liftDistribution.set sweep: 30
      expectRoundedArray(@calc.cof()).toEqual([1.2560, 0.0693, 0.5192, -6.3107, 10.8358, -6.3704])
      @liftDistribution.set cruisingSpeed: 0.9, sweep: 30
      expectRoundedArray(@calc.cof()).toEqual([1.2513, 0.0714, 0.6263, -6.5902, 11.1071, -6.4677])

  describe '#f', ->
    it 'should return correct sum', ->
      expectRounded(@calc.f(0.00)).toEqual(1.2621)
      expectRounded(@calc.f(0.25)).toEqual(1.2444)
      expectRounded(@calc.f(0.50)).toEqual(1.1069)
      expectRounded(@calc.f(0.75)).toEqual(0.8517)
      expectRounded(@calc.f(1.00)).toEqual(0.0002)

  describe '#gamma_a', ->
    it 'should return correct result', ->
      coords = @calc.gamma_a().points
      yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
      window.gamma_a = yCoords
      expectRoundedArray(yCoords).toEqual [ 1.2975, 1.2672, 1.2292, 1.1807, 1.1226, 1.0565, 0.982, 0.8942, 0.7799, 0.6131, 0.3112 ]
      expectRounded(@calc.gamma_a().minY).toEqual(0)
      expectRounded(@calc.gamma_a().maxY).toEqual(1.2975)

  describe '#epsylon', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.epsylon(0.00)).toEqual(0)
      expectRounded(@calc.epsylon(0.25)).toEqual(0)
      expectRounded(@calc.epsylon(0.50)).toEqual(0)
      expectRounded(@calc.epsylon(0.75)).toEqual(0)
      expectRounded(@calc.epsylon(1.00)).toEqual(0)
      @liftDistribution.set linearTwist: 10
      expectRounded(@calc.epsylon(0.00)).toEqual(0)
      expectRounded(@calc.epsylon(0.25)).toEqual(0.0436)
      expectRounded(@calc.epsylon(0.50)).toEqual(0.0873)
      expectRounded(@calc.epsylon(0.75)).toEqual(0.1309)
      expectRounded(@calc.epsylon(1.00)).toEqual(0.1745)

  describe '#elliptic', ->
    it 'should calculate the correct value', ->
      coords = @calc.elliptic().points
      yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
      expectRoundedArray(yCoords).toEqual [ 0.6366, 0.6334, 0.6238, 0.6073, 0.5835, 0.5513, 0.5093, 0.4546, 0.382, 0.2775, 0 ]
      expectRounded(@calc.elliptic().minY).toEqual(0)
      expectRounded(@calc.elliptic().maxY).toEqual(0.6366)

  describe '#gamma_b', ->
    it 'should return 0 when epsylon is 0', ->
      coords = @calc.gamma_b().points
      yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
      window.gamma_a = yCoords
      expectRoundedArray(yCoords).toEqual [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
      expectRounded(@calc.gamma_b().minY).toEqual(0)
      expectRounded(@calc.gamma_b().maxY).toEqual(0)

    it 'should return 0 when epsylon is 0', ->
      @liftDistribution.set linearTwist: 10
      coords = @calc.gamma_b().points
      yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
      expectRoundedArray(yCoords).toEqual [ -0.3409, -0.2546, -0.171, -0.0913, -0.0174, 0.0489, 0.1062, 0.152, 0.1807, 0.18, 0.1106 ]
      expectRounded(@calc.gamma_b().minY).toEqual(-0.3409)
      expectRounded(@calc.gamma_b().maxY).toEqual( 0.1807)

  describe '#gamma', ->
    describe 'with epsylon = 0', ->
      beforeEach ->
        @liftDistribution.set linearTwist: 0

      it 'should return correct values', ->
        coords = @calc.gamma().points
        yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
        expectRoundedArray(yCoords).toEqual [ 0.6487, 0.6336, 0.6146, 0.5904, 0.5613, 0.5282, 0.491, 0.4471, 0.3899, 0.3066, 0.1556 ]
        expectRounded(@calc.gamma().minY).toEqual(0.1556)
        expectRounded(@calc.gamma().maxY).toEqual(0.6487)

    describe 'with epsylon = 10', ->
      beforeEach ->
        @liftDistribution.set linearTwist: 10

      it 'should return correct values', ->
        coords = @calc.gamma().points
        yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
        expectRoundedArray(yCoords).toEqual [ 0.3079, 0.379, 0.4436, 0.4991, 0.5439, 0.5772, 0.5972, 0.5991, 0.5707, 0.4865, 0.2661 ]
        expectRounded(@calc.gamma().minY).toEqual(0.2661)
        expectRounded(@calc.gamma().maxY).toEqual(0.5991)

  describe '#C_a', ->
    describe 'with epsylon = 0', ->
      beforeEach ->
        @liftDistribution.set linearTwist: 0

      it 'should return correct values', ->
        coords = @calc.C_a().points
        yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
        expectRoundedArray(yCoords).toEqual [ 0.4866, 0.5002, 0.5122, 0.5209, 0.5262, 0.5282, 0.5261, 0.5159, 0.4874, 0.418, 0.2334 ]
        expectRounded(@calc.C_a().minY).toEqual(0.2334)
        expectRounded(@calc.C_a().maxY).toEqual(0.5282)

    describe 'with epsylon = 10', ->
      beforeEach ->
        @liftDistribution.set linearTwist: 10

      it 'should return correct values', ->
        coords = @calc.C_a().points
        yCoords = (coords[i+1] for i in [0..coords.length-1] by 2)
        expectRoundedArray(yCoords).toEqual [ 0.2309, 0.2992, 0.3697, 0.4404, 0.5099, 0.5772, 0.6399, 0.6912, 0.7133, 0.6635, 0.3992 ]
        expectRounded(@calc.C_a().minY).toEqual(0.2309)
        expectRounded(@calc.C_a().maxY).toEqual(0.7133)

  describe '#C_A', ->
    it 'should return correct values', ->
      expect(@calc.C_A().points).toEqual([0, @calc.C_A_(), 1.0, @calc.C_A_()])

  describe '#integral', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.integral()).toEqual(0)
      @liftDistribution.set linearTwist: 10
      expectRounded(@calc.integral()).toEqual(0.0742)

  describe 'wing geometry', ->
    describe '#l', ->
      it 'should return correct values', ->
        expectRounded(@calc.l()).toEqual(420)

    describe '#Phi_VK', ->
      it 'should return correct values', ->
        expectRounded(@calc.Phi_VK()).toEqual(1.9092)

    describe '#dya', ->
      it 'should return correct values', ->
        expectRounded(@calc.dya()).toEqual(0)

    describe '#yl', ->
      it 'should return correct values', ->
        expectRounded(@calc.yl()).toEqual(84)

    describe '#la', ->
      it 'should return correct values', ->
        expectRounded(@calc.la()).toEqual(56)

    describe '#li', ->
      it 'should return correct values', ->
        expectRounded(@calc.li()).toEqual(112)

    describe '#li', ->
      it 'should return correct values', ->
        expectRounded(@calc.li()).toEqual(112)

    describe '#wingY01', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY01()).toEqual(21)
    describe '#wingY02', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY02()).toEqual(21)

    describe '#wingX1', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingX1()).toEqual(0)
    describe '#wingY1', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY1()).toEqual(49)

    describe '#wingX2', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingX2()).toEqual(1)
    describe '#wingY2', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY2()).toEqual(35)

    describe '#wingX3', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingX3()).toEqual(0)
    describe '#wingY3', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY3()).toEqual(-63)

    describe '#wingX4', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingX4()).toEqual(1)
    describe '#wingY4', ->
      it 'should return correct values', ->
        expectRounded(@calc.wingY4()).toEqual(-21)
