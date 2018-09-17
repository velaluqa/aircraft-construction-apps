describe 'ILR.JetEnginePerformance.Models.ConsumptionCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      height: 0
      mu: 0
      deltaP: 0.02
      TET: 1500
      OAPR: 30
      eta_c: 0.85
      eta_f: 0.83
      eta_n: 0.97
      eta_t: 0.85
    @calc = new ILR.JetEnginePerformance.Models.ConsumptionCalculator
      consumptionApp: @model

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
    describe '#TET', ->
      it 'should return the correct value', ->
        expect(@calc.TET()).toEqual(1500)
    describe '#OAPR', ->
      it 'should return the correct value', ->
        expect(@calc.OAPR()).toEqual(30)
    describe '#eta_c', ->
      it 'should return the correct value', ->
        expect(@calc.eta_c()).toEqual(0.85)
    describe '#eta_f', ->
      it 'should return the correct value', ->
        expect(@calc.eta_f()).toEqual(0.83)
    describe '#eta_n', ->
      it 'should return the correct value', ->
        expect(@calc.eta_n()).toEqual(0.97)
    describe '#eta_t', ->
      it 'should return the correct value', ->
        expect(@calc.eta_t()).toEqual(0.85)

  describe '#t', ->
    it 'should return correct value for height 0km', ->
      @model.set height: 0
      expect(@calc.t()).toEqual(288.15)
    it 'should return correct value for height 1km', ->
      @model.set height: 1
      expectRounded(@calc.t()).toEqual(281.65)
    it 'should return correct value for height of 12km', ->
      @model.set height: 12
      expectRounded(@calc.t(), 11).toEqual(216.65)

  describe '#teta', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.teta(0.00), 2).toEqual(1)
      expectRounded(@calc.teta(0.25), 2).toEqual(1.01)
      expectRounded(@calc.teta(0.50), 2).toEqual(1.05)
      expectRounded(@calc.teta(0.75), 2).toEqual(1.11)
      expectRounded(@calc.teta(1.00), 2).toEqual(1.2)

  describe '#kappa', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.kappa(0.00), 2).toEqual(1.64)
      expectRounded(@calc.kappa(0.25), 2).toEqual(1.66)
      expectRounded(@calc.kappa(0.50), 2).toEqual(1.72)
      expectRounded(@calc.kappa(0.75), 2).toEqual(1.83)
      expectRounded(@calc.kappa(1.00), 2).toEqual(1.97)

  describe '#eta_intake', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.eta_intake(0), 2).toEqual(0.97)
      expectRounded(@calc.eta_intake(2), 2).toEqual(0.96)
      expectRounded(@calc.eta_intake(4), 2).toEqual(0.95)
      expectRounded(@calc.eta_intake(6), 2).toEqual(0.94)
      expectRounded(@calc.eta_intake(8), 2).toEqual(0.93)

  describe '#eta_i', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.eta_i(0, 0.00), 4).toEqual(1.0000)
      expectRounded(@calc.eta_i(0, 0.25), 4).toEqual(0.9989)
      expectRounded(@calc.eta_i(0, 0.50), 4).toEqual(0.9957)
      expectRounded(@calc.eta_i(0, 0.75), 4).toEqual(0.9908)
      expectRounded(@calc.eta_i(0, 1.00), 4).toEqual(0.9848)

  describe '#G', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.G(0, 0.00), 4).toEqual(1.0522)
      expectRounded(@calc.G(0, 0.25), 4).toEqual(1.0496)
      expectRounded(@calc.G(0, 0.50), 4).toEqual(1.0383)
      expectRounded(@calc.G(0, 0.75), 4).toEqual(1.0084)
      expectRounded(@calc.G(0, 1.00), 4).toEqual(0.9463)

  describe '#SFC_pole', ->
    describe 'with TET = 1400', ->
      beforeEach ->
        @model.set(TET: 1400)

      it 'should approximate the pole', ->
        expect(@calc.pole('SFC_unlimited')).toEqual(1)

    describe 'with TET = 1400', ->
      beforeEach ->
        @model.set(TET: 1100)

      describe 'mu = 0', ->
        beforeEach ->
          @model.set(TET: 1100)
        it 'should approximate the pole', ->
          expectRounded(@calc.pole('SFC_unlimited')).toEqual(0.4922)

      describe 'mu = 2', ->
        beforeEach ->
          @model.set(TET: 1100)
        it 'should approximate the pole', ->
          expectRounded(@calc.pole('SFC_unlimited')).toEqual(0.4922)

  describe '#_SFC', ->
    describe 'with bypass ratio = 0', ->
      describe 'and height = 0', ->
        it 'should return the correct values', ->
          @model.set(height: 0)
          expectRounded(@calc._SFC(0, 0.00), 3).toEqual(0.701)
          expectRounded(@calc._SFC(0, 0.25), 3).toEqual(0.777)
          expectRounded(@calc._SFC(0, 0.50), 3).toEqual(0.850)
          expectRounded(@calc._SFC(0, 0.75), 3).toEqual(0.927)
          expectRounded(@calc._SFC(0, 1.00), 3).toEqual(1.029)

    describe 'with bypass ratio = 0', ->
      describe 'and height = 10', ->
        it 'should return the correct values', ->
          @model.set(height: 10)
          expectRounded(@calc._SFC(0, 0.00), 3).toEqual(0.742)
          expectRounded(@calc._SFC(0, 0.25), 3).toEqual(0.797)
          expectRounded(@calc._SFC(0, 0.50), 3).toEqual(0.844)
          expectRounded(@calc._SFC(0, 0.75), 3).toEqual(0.884)
          expectRounded(@calc._SFC(0, 1.00), 3).toEqual(0.918)

    describe 'with bypass ratio = 2', ->
      describe 'and height = 0', ->
        it 'should return the correct values', ->
          @model.set(height: 0)
          expectRounded(@calc._SFC(2, 0.00), 3).toEqual(0.452)
          expectRounded(@calc._SFC(2, 0.25), 3).toEqual(0.555)
          expectRounded(@calc._SFC(2, 0.50), 3).toEqual(0.672)
          expectRounded(@calc._SFC(2, 0.75), 3).toEqual(0.811)
          expectRounded(@calc._SFC(2, 1.00), 3).toEqual(1.002)
