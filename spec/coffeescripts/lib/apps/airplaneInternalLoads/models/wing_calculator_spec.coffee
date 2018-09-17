describe 'ILR.AirplaneInternalLoads.Models.WingCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      loadCase: 'flight'
      thrust: 300
      loadFactor: 1.0
      airplaneMass: 50000
      relWingMass: 15
      relFuelMass: 25
      relEngineMass: 10
      relPayload: 20
      span: 20
      aspectRatio: 9
      taper: 0.3
      relGearPositionX: 65
      relGearPositionY: 20
      relTankSpan: 75
      relEnginePositionY: 30
      relShearCenter: 40
      relThrustCenterZ: -100
    @calc = new ILR.AirplaneInternalLoads.Models.WingCalculator
      model: @model
    @calc.accuracy = 3

  describe 'wing load parameters', ->
    describe '#loadCase', ->
      it 'should return the correct value ', ->
        expect(@calc.loadCase()).toEqual('flight')
    describe '#thrust', ->
      it 'should return the correct value', ->
        expect(@calc.thrust()).toEqual(300000)
    describe '#loadFactor', ->
      it 'should return the correct value', ->
        expect(@calc.loadFactor()).toEqual(1.0)
    describe '#airplaneMass', ->
      it 'should return the correct value', ->
        expect(@calc.airplaneMass()).toEqual(50000)
    describe '#relWingMass', ->
      it 'should return the correct value', ->
        expect(@calc.relWingMass()).toEqual(0.15)
    describe '#relFuelMass', ->
      it 'should return the correct value', ->
        expect(@calc.relFuelMass()).toEqual(0.25)
    describe '#relEngineMass', ->
      it 'should return the correct value', ->
        expect(@calc.relEngineMass()).toEqual(0.10)
    describe '#relPayload', ->
      it 'should return the correct value', ->
        expect(@calc.relPayload()).toEqual(0.20)
    describe '#span', ->
      it 'should return the correct value', ->
        expect(@calc.span()).toEqual(20)
    describe '#aspectRatio', ->
      it 'should return the correct value', ->
        expect(@calc.aspectRatio()).toEqual(9)
    describe '#taper', ->
      it 'should return the correct value', ->
        expect(@calc.taper()).toEqual(0.3)
    describe '#relGearPositionX', ->
      it 'should return the correct value', ->
        expect(@calc.relGearPositionX()).toEqual(0.65)
    describe '#relGearPositionY', ->
      it 'should return the correct value', ->
        expect(@calc.relGearPositionY()).toEqual(0.20)
    describe '#relTankSpan', ->
      it 'should return the correct value', ->
        expect(@calc.relTankSpan()).toEqual(0.75)
    describe '#relEnginePositionY', ->
      it 'should return the correct value', ->
        expect(@calc.relEnginePositionY()).toEqual(0.30)
    describe '#relShearCenter', ->
      it 'should return the correct value', ->
        expect(@calc.relShearCenter()).toEqual(0.40)
    describe '#relThrustCenterZ', ->
      it 'should return the correct value', ->
        expect(@calc.relThrustCenterZ()).toEqual(-1)

  describe '#mac', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.mac(), 2).toEqual(2.22)
  describe '#wingArea', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.wingArea(), 1).toEqual(44.4)
  describe '#innerChord', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.innerChord(), 2).toEqual(3.42)
  describe '#outerChord', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.outerChord(), 2).toEqual(1.03)

  describe '#wingMass', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.wingMass(), 2).toEqual(7500)

  describe '#fuelMass', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.fuelMass(), 2).toEqual(12500)
  describe '#engineMass', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.engineMass(), 2).toEqual(5000)
  describe '#payloadMass', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.payloadMass(), 2).toEqual(10000)


  describe '#tankSpan', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankSpan(), 2).toEqual(15)
  describe '#tankAspectRatio', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankAspectRatio(), 2).toEqual(5.95)
  describe '#tankTaper', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankTaper(), 2).toEqual(0.48)

  describe '#tankArea', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankArea(), 2).toEqual(37.82)
  describe '#tankInnerChord', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankInnerChord(), 2).toEqual(3.42)
  describe '#tankOuterChord', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankOuterChord(), 2).toEqual(1.62)
  describe '#tankMac', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.tankMac(), 2).toEqual(2.52)


  describe '#y', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.y(0.00), 2).toEqual(0.0)
      expectRounded(@calc.y(0.25), 2).toEqual(2.5)
      expectRounded(@calc.y(0.50), 2).toEqual(5.0)
      expectRounded(@calc.y(0.75), 2).toEqual(7.5)
      expectRounded(@calc.y(1.00), 2).toEqual(10.0)

  describe '#l', ->
    it 'should calculate the correct value', ->
      expectRounded(@calc.l(0.00), 2).toEqual(3.42)
      expectRounded(@calc.l(0.25), 2).toEqual(2.82)
      expectRounded(@calc.l(0.50), 2).toEqual(2.22)
      expectRounded(@calc.l(0.75), 2).toEqual(1.62)
      expectRounded(@calc.l(1.00), 2).toEqual(1.03)

  describe '#lift', ->
    beforeEach ->
      @result = @calc.lift()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0).toEqual [
        0, 37731,
        1, 11319
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(11319)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(37731)

  describe '#structure', ->
    beforeEach ->
      @result = @calc.structure()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0).toEqual [
        0, -5660,
        1, -1698
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(-5660)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(-1698)

  describe '#fuel', ->
    beforeEach ->
      @result = @calc.fuel()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0, 2).toEqual [
        0   , -11085,
        0.75, -5265,
        0.75, 0,
        1   , 0
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(-11085)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(0)

  describe '#total', ->
    beforeEach ->
      @result = @calc.total()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0, 2).toEqual [
        0   , 20986,
        0.75, 9969,
        0.75, 15234,
        1   , 9621
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(9621)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(20986)

  describe '#Qa', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Qa(0.00), 0).toBe(245250)
      expectRounded(@calc.Qa(0.05), 0).toBe(226715)
      expectRounded(@calc.Qa(0.10), 0).toBe(208840)
      expectRounded(@calc.Qa(0.15), 0).toBe(191625)
      expectRounded(@calc.Qa(0.20), 0).toBe(175071)
      expectRounded(@calc.Qa(0.25), 0).toBe(159177)
      expectRounded(@calc.Qa(0.30), 0).toBe(143943)
      expectRounded(@calc.Qa(0.35), 0).toBe(129369)
      expectRounded(@calc.Qa(0.40), 0).toBe(115456)
      expectRounded(@calc.Qa(0.45), 0).toBe(102203)
      expectRounded(@calc.Qa(0.50), 0).toBe(89611)
      expectRounded(@calc.Qa(0.55), 0).toBe(77678)
      expectRounded(@calc.Qa(0.60), 0).toBe(66406)
      expectRounded(@calc.Qa(0.65), 0).toBe(55794)
      expectRounded(@calc.Qa(0.70), 0).toBe(45843)
      expectRounded(@calc.Qa(0.75), 0).toBe(36552)
      expectRounded(@calc.Qa(0.80), 0).toBe(27921)
      expectRounded(@calc.Qa(0.85), 0).toBe(19950)
      expectRounded(@calc.Qa(0.90), 0).toBe(12640)
      expectRounded(@calc.Qa(0.95), 0).toBe(5990)
      expectRounded(@calc.Qa(1.00), 0).toBe(0)

  describe '#Qm', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Qm(0.00), 0).toBe(-98100)
      expectRounded(@calc.Qm(0.05), 0).toBe(-89874)
      expectRounded(@calc.Qm(0.10), 0).toBe(-81942)
      expectRounded(@calc.Qm(0.15), 0).toBe(-74302)
      expectRounded(@calc.Qm(0.20), 0).toBe(-66955)
      expectRounded(@calc.Qm(0.25), 0).toBe(-59902)
      expectRounded(@calc.Qm(0.30), 0).toBe(-53141)
      expectRounded(@calc.Qm(0.35), 0).toBe(-46674)
      expectRounded(@calc.Qm(0.40), 0).toBe(-40499)
      expectRounded(@calc.Qm(0.45), 0).toBe(-34618)
      expectRounded(@calc.Qm(0.50), 0).toBe(-29030)
      expectRounded(@calc.Qm(0.55), 0).toBe(-23734)
      expectRounded(@calc.Qm(0.60), 0).toBe(-18732)
      expectRounded(@calc.Qm(0.65), 0).toBe(-14022)
      expectRounded(@calc.Qm(0.70), 0).toBe(-9606)
      expectRounded(@calc.Qm(0.75), 0).toBe(-5483)
      expectRounded(@calc.Qm(0.80), 0).toBe(-4188)
      expectRounded(@calc.Qm(0.85), 0).toBe(-2993)
      expectRounded(@calc.Qm(0.90), 0).toBe(-1896)
      expectRounded(@calc.Qm(0.95), 0).toBe(-898)
      expectRounded(@calc.Qm(1.00), 0).toBe(0)

  describe '#Q_value', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Q_value(0.00), 0).toBe(122625)
      expectRounded(@calc.Q_value(0.05), 0).toBe(112315)
      expectRounded(@calc.Q_value(0.10), 0).toBe(102373)
      expectRounded(@calc.Q_value(0.15), 0).toBe(92798)
      expectRounded(@calc.Q_value(0.20), 0).toBe(83590)
      expectRounded(@calc.Q_value(0.25), 0).toBe(74750)
      expectRounded(@calc.Q_value(0.30), 0).toBe(66276)
      expectRounded(@calc.Q_value(0.35), 0).toBe(82695)
      expectRounded(@calc.Q_value(0.40), 0).toBe(74957)
      expectRounded(@calc.Q_value(0.45), 0).toBe(67585)
      expectRounded(@calc.Q_value(0.50), 0).toBe(60581)
      expectRounded(@calc.Q_value(0.55), 0).toBe(53944)
      expectRounded(@calc.Q_value(0.60), 0).toBe(47674)
      expectRounded(@calc.Q_value(0.65), 0).toBe(41772)
      expectRounded(@calc.Q_value(0.70), 0).toBe(36237)
      expectRounded(@calc.Q_value(0.75), 0).toBe(31069)
      expectRounded(@calc.Q_value(0.80), 0).toBe(23733)
      expectRounded(@calc.Q_value(0.85), 0).toBe(16958)
      expectRounded(@calc.Q_value(0.90), 0).toBe(10744)
      expectRounded(@calc.Q_value(0.95), 0).toBe(5091)
      expectRounded(@calc.Q_value(1.00), 0).toBe(0)

  describe '#Q', ->
    beforeEach ->
      @model.set loadCase: 'flight'
      @result = @calc.Q()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0, 2).toEqual [
        0                  , 122625,
        0.09999999999999999, 102373,
        0.19999999999999998, 83590,
        0.3                , 66276,

        0.3                , 90801,
        0.44999999999999996, 67585,
        0.6                , 47674,
        0.75               , 31069,

        0.75               , 31069,
        0.8333333333333334 , 19154,
        0.9166666666666666 , 8797,
        1                  , 0
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(122625)

  describe '#M_value', ->
    it 'should return the correct values', ->
      expectRounded(@calc.M_value(0.00), 0).toBe(579013)
      expectRounded(@calc.M_value(0.05), 0).toBe(520293)
      expectRounded(@calc.M_value(0.10), 0).toBe(466636)
      expectRounded(@calc.M_value(0.15), 0).toBe(417859)
      expectRounded(@calc.M_value(0.20), 0).toBe(373777)
      expectRounded(@calc.M_value(0.25), 0).toBe(334207)
      expectRounded(@calc.M_value(0.30), 0).toBe(298966)
      expectRounded(@calc.M_value(0.35), 0).toBe(255607)
      expectRounded(@calc.M_value(0.40), 0).toBe(216209)
      expectRounded(@calc.M_value(0.45), 0).toBe(180589)
      expectRounded(@calc.M_value(0.50), 0).toBe(148563)
      expectRounded(@calc.M_value(0.55), 0).toBe(119947)
      expectRounded(@calc.M_value(0.60), 0).toBe(94557)
      expectRounded(@calc.M_value(0.65), 0).toBe(72211)
      expectRounded(@calc.M_value(0.70), 0).toBe(52724)
      expectRounded(@calc.M_value(0.75), 0).toBe(35913)
      expectRounded(@calc.M_value(0.80), 0).toBe(22236)
      expectRounded(@calc.M_value(0.85), 0).toBe(12087)
      expectRounded(@calc.M_value(0.90), 0).toBe(5185)
      expectRounded(@calc.M_value(0.95), 0).toBe(1249)
      expectRounded(@calc.M_value(1.00), 0).toBe(0)

  describe '#M', ->
    beforeEach ->
      @model.set loadCase: 'flight'
      @result = @calc.M()
    it 'should have the correct points', ->
      expectRoundedArray(@result.points, 0, 2).toEqual [
        0                  , 579013,
        0.09999999999999999, 466636,
        0.19999999999999998, 373777,
        0.3                , 298966,

        0.3                , 298966,
        0.44999999999999996, 180589,
        0.6                , 94557,
        0.75               , 35913,

        0.75               , 35913,
        0.8333333333333334 , 15095,
        0.9166666666666666 , 3557,
        1                  , 0
      ]
    it 'should have the correct minimum Y value', ->
      expectRounded(@result.minY, 0).toEqual(0)
    it 'should have the correct maximum Y value', ->
      expectRounded(@result.maxY, 0).toEqual(579013)

  describe '#T_value', ->
    describe 'with thrust = 0', ->
      beforeEach ->
        @model.set
          loadCase: 'flight'
          thrust: 0

      it 'should return the correct values', ->
        expectRounded(@calc.T_value(0.00), 0).toBe(83846)
        expectRounded(@calc.T_value(0.05), 0).toBe(70382)
        expectRounded(@calc.T_value(0.10), 0).toBe(58043)
        expectRounded(@calc.T_value(0.15), 0).toBe(46789)
        expectRounded(@calc.T_value(0.20), 0).toBe(36578)
        expectRounded(@calc.T_value(0.25), 0).toBe(27371)
        expectRounded(@calc.T_value(0.30), 0).toBe(19125)
        expectRounded(@calc.T_value(0.35), 0).toBe(56113)
        expectRounded(@calc.T_value(0.40), 0).toBe(47615)
        expectRounded(@calc.T_value(0.45), 0).toBe(39956)
        expectRounded(@calc.T_value(0.50), 0).toBe(33096)
        expectRounded(@calc.T_value(0.55), 0).toBe(26994)
        expectRounded(@calc.T_value(0.60), 0).toBe(21609)
        expectRounded(@calc.T_value(0.65), 0).toBe(16900)
        expectRounded(@calc.T_value(0.70), 0).toBe(12827)
        expectRounded(@calc.T_value(0.75), 0).toBe(9349)
        expectRounded(@calc.T_value(0.80), 0).toBe(6615)
        expectRounded(@calc.T_value(0.85), 0).toBe(4351)
        expectRounded(@calc.T_value(0.90), 0).toBe(2518)
        expectRounded(@calc.T_value(0.95), 0).toBe(1080)
        expectRounded(@calc.T_value(1.00), 0).toBe(0)

    describe 'with thrust = 300', ->
      beforeEach ->
        @model.set
          loadCase: 'flight'
          thrust: 300

      it 'should return the correct values', ->
        expectRounded(@calc.T_value(0.00), 0).toBe(383846)
        expectRounded(@calc.T_value(0.05), 0).toBe(370382)
        expectRounded(@calc.T_value(0.10), 0).toBe(358043)
        expectRounded(@calc.T_value(0.15), 0).toBe(346789)
        expectRounded(@calc.T_value(0.20), 0).toBe(336578)
        expectRounded(@calc.T_value(0.25), 0).toBe(327371)
        expectRounded(@calc.T_value(0.30), 0).toBe(319125)
        expectRounded(@calc.T_value(0.35), 0).toBe(56113)
        expectRounded(@calc.T_value(0.40), 0).toBe(47615)
        expectRounded(@calc.T_value(0.45), 0).toBe(39956)
        expectRounded(@calc.T_value(0.50), 0).toBe(33096)
        expectRounded(@calc.T_value(0.55), 0).toBe(26994)
        expectRounded(@calc.T_value(0.60), 0).toBe(21609)
        expectRounded(@calc.T_value(0.65), 0).toBe(16900)
        expectRounded(@calc.T_value(0.70), 0).toBe(12827)
        expectRounded(@calc.T_value(0.75), 0).toBe(9349)
        expectRounded(@calc.T_value(0.80), 0).toBe(6615)
        expectRounded(@calc.T_value(0.85), 0).toBe(4351)
        expectRounded(@calc.T_value(0.90), 0).toBe(2518)
        expectRounded(@calc.T_value(0.95), 0).toBe(1080)
        expectRounded(@calc.T_value(1.00), 0).toBe(0)

  describe '#T', ->
    describe 'in flight with thrust = 0 kN', ->
      beforeEach ->
        @model.set
          loadCase: 'flight'
          thrust: 0
        @result = @calc.T()
      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0                  , 83846,
          0.09999999999999999, 58043,
          0.19999999999999998, 36578,
          0.3                , 19125,

          0.3                , 65492,
          0.5333333333333333 , 28946,
          0.7666666666666666 , 8383,
          0.9999999999999998 , 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(0)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(83846)

    describe 'in flight with thrust = 300 kN', ->
      beforeEach ->
        @model.set
          loadCase: 'flight'
          thrust: 300
        @result = @calc.T()
      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0, 383846,
          0.09999999999999999, 358043,
          0.19999999999999998, 336578,
          0.3, 319125,

          0.3, 65492,
          0.5333333333333333, 28946,
          0.7666666666666666, 8383,
          0.9999999999999998, 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(0)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(383846)

    describe 'on the ground with thrust = 0 kN', ->
      beforeEach ->
        @model.set
          loadCase: 'ground'
          thrust: 0
        @result = @calc.T()
      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0                  , -251538,
          0.06666666666666667, -241577,
          0.13333333333333333, -231360,
          0.20000000000000004, -220902,
          0.2                , -40632,
          0.23333333333333334, -40207,
          0.26666666666666666, -39726,
          0.3                , -39191,
          0.3                , 7176,
          0.5333333333333333 , 2728,
          0.7666666666666666 , 399,
          0.9999999999999998 , 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(-251538)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(7176)

    describe 'on the ground with thrust = 300 kN', ->
      beforeEach ->
        @model.set
          loadCase: 'ground'
          thrust: 300
        @result = @calc.T()
      it 'should have the correct points', ->
        expectRoundedArray(@result.points, 0, 2).toEqual [
          0                  , 48462,
          0.06666666666666667, 58423,
          0.13333333333333333, 68640,
          0.20000000000000004, 79098,
          0.2                , 259368,
          0.23333333333333334, 259793,
          0.26666666666666666, 260274,
          0.3                , 260809,
          0.3                , 7176,
          0.5333333333333333 , 2728,
          0.7666666666666666 , 399,
          0.9999999999999998 , 0
        ]
      it 'should have the correct minimum Y value', ->
        expectRounded(@result.minY, 0).toEqual(0)
      it 'should have the correct maximum Y value', ->
        expectRounded(@result.maxY, 0).toEqual(260809)
