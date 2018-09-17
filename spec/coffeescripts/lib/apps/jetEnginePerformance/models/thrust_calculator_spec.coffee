describe 'ILR.JetEnginePerformance.Models.ThrustCalculator', ->
  beforeEach ->
    @thrustApp = new Backbone.Model
      height: 0
      mu: 0
      deltaP: 0.02
      D: 1.0
    @calc = new ILR.JetEnginePerformance.Models.ThrustCalculator
      thrustApp: @thrustApp

  describe 'model parameter', ->
    describe '#height', ->
      it  'should return the correct value', ->
        expect(@calc.height()).toEqual(0)
    describe '#mu', ->
      it  'should return the correct value', ->
        expect(@calc.mu()).toEqual(0)
    describe '#deltaP', ->
      it  'should return the correct value', ->
        expect(@calc.deltaP()).toEqual(0.02)
    describe '#D', ->
      it  'should return the correct value', ->
        expect(@calc.D()).toEqual(1.0)

  describe '#t', ->
    it 'should return correct value for height 0km', ->
      @thrustApp.set height: 0
      expect(@calc.t()).toEqual(288.15)
    it 'should return correct value for height 1km', ->
      @thrustApp.set height: 1
      expectRounded(@calc.t()).toEqual(281.65)
    it 'should return correct value for height of 12km', ->
      @thrustApp.set height: 12
      expectRounded(@calc.t(), 11).toEqual(216.65)

  describe '#p_p0', ->
    it 'should return correct value for height 0km', ->
      @thrustApp.set height: 0
      expect(@calc.p_p0()).toEqual(1)
    it 'should return correct value for height 1km', ->
      @thrustApp.set height: 1
      expectRounded(@calc.p_p0()).toEqual(0.887)
    # it 'should return correct value for height of 12km', ->
    #   @thrustApp.set height: 12
    #   expectRounded(@calc.p_p0(), 11).toEqual(0.99999996478)

  describe '#rho_rho0', ->
    it 'should return correct value for height 0km', ->
      @thrustApp.set height: 0
      expect(@calc.rho_rho0()).toEqual(1)
    it 'should return correct value for height 1km', ->
      @thrustApp.set height: 1
      expectRounded(@calc.rho_rho0()).toEqual(0.9075)
    # it 'should return correct value for height of 12km', ->
    #   @thrustApp.set height: 12
    #   expectRounded(@calc.rho_rho0()).toEqual(0.2971)

  describe '#SS0', ->
    describe 'with bypass ratio = 0', ->
      describe 'and height = 0km', ->
        it 'should return correct value', ->
          @thrustApp.set height: 0
          expectRounded(@calc.SS0(0, 0.00)).toEqual(0.974)
          expectRounded(@calc.SS0(0, 0.25)).toEqual(0.974)
          expectRounded(@calc.SS0(0, 0.50)).toEqual(0.974)
          expectRounded(@calc.SS0(0, 0.75)).toEqual(0.974)
          expectRounded(@calc.SS0(0, 1.00)).toEqual(0.974)

      describe 'and height = 1km', ->
        it 'should return correct value', ->
          @thrustApp.set height: 1
          expectRounded(@calc.SS0(0, 0.00)).toEqual(0.8839)
          expectRounded(@calc.SS0(0, 0.25)).toEqual(0.8839)
          expectRounded(@calc.SS0(0, 0.50)).toEqual(0.8839)
          expectRounded(@calc.SS0(0, 0.75)).toEqual(0.8839)
          expectRounded(@calc.SS0(0, 1.00)).toEqual(0.8839)

      describe 'and height = 12km', ->
        it 'should return correct values', ->
          @thrustApp.set height: 12
          expectRounded(@calc.SS0(0, 0.00)).toEqual(0.2465)
          expectRounded(@calc.SS0(0, 0.25)).toEqual(0.2465)
          expectRounded(@calc.SS0(0, 0.50)).toEqual(0.2465)
          expectRounded(@calc.SS0(0, 0.75)).toEqual(0.2465)
          expectRounded(@calc.SS0(0, 1.00)).toEqual(0.2465)

    describe 'with bypass ratio = 6', ->
      describe 'and height = 0km', ->
        it 'should return correct value', ->
          @thrustApp.set height: 0
          expectRounded(@calc.SS0(6, 0.00), 3).toEqual(0.944)
          expectRounded(@calc.SS0(6, 0.25), 3).toEqual(0.762)
          expectRounded(@calc.SS0(6, 0.50), 3).toEqual(0.615)
          expectRounded(@calc.SS0(6, 0.75), 3).toEqual(0.496)
          expectRounded(@calc.SS0(6, 1.00), 3).toEqual(0.401)

      describe 'and height = 1km', ->
        it 'should return correct value', ->
          @thrustApp.set height: 1
          expectRounded(@calc.SS0(6, 0.00), 3).toEqual(0.857)
          expectRounded(@calc.SS0(6, 0.25), 3).toEqual(0.708)
          expectRounded(@calc.SS0(6, 0.50), 3).toEqual(0.586)
          expectRounded(@calc.SS0(6, 0.75), 3).toEqual(0.484)
          expectRounded(@calc.SS0(6, 1.00), 3).toEqual(0.4)

      describe 'and height = 12km', ->
        it 'should return correct values', ->
          @thrustApp.set height: 12
          expectRounded(@calc.SS0(6, 0.00), 3).toEqual(0.239)
          expectRounded(@calc.SS0(6, 0.25), 3).toEqual(0.229)
          expectRounded(@calc.SS0(6, 0.50), 3).toEqual(0.22)
          expectRounded(@calc.SS0(6, 0.75), 3).toEqual(0.211)
          expectRounded(@calc.SS0(6, 1.00), 3).toEqual(0.203)
