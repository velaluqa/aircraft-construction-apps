describe 'ILR.BeamSectionProperties.Models.StaticMomentCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      coord: 'eigen'
      za: 40
      l: 50
      t: 5
      alpha: -44
      z0: 25
    @calc = new ILR.BeamSectionProperties.Models.StaticMomentCalculator
      model: @model

  describe '#coord', ->
    it 'should return the correct value', ->
      expect(@calc.coord()).toEqual('eigen')
  describe '#za', ->
    it 'should return the correct value', ->
      expectRounded(@calc.za()).toEqual(40)
  describe '#l', ->
    it 'should return the correct value', ->
      expectRounded(@calc.l()).toEqual(50)
  describe '#t', ->
    it 'should return the correct value', ->
      expectRounded(@calc.t()).toEqual(5)
  describe '#alpha', ->
    it 'should return the deg in rad', ->
      expectRounded(@calc.alpha()).toEqual(-0.7679)
  describe '#z0', ->
    it 'should return the correct value', ->
      expectRounded(@calc.z0()).toEqual(25)

  describe '#z0element', ->
    describe 'with coord = eigen', ->
      beforeEach ->
        @model.set coord: 'eigen'
      it 'should return the correct value', ->
        expectRounded(@calc.z0element(), 2).toEqual(22.63)

    describe 'with coord = none', ->
      beforeEach ->
        @model.set coord: 'none'
      it 'should return the correct value', ->
        expectRounded(@calc.z0element(), 2).toEqual(25)

  describe '#Sz_x', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Sz_x(0.0), 1).toEqual(40.0)
      expectRounded(@calc.Sz_x(0.1), 1).toEqual(36.5)
      expectRounded(@calc.Sz_x(0.2), 1).toEqual(33.1)
      expectRounded(@calc.Sz_x(0.3), 1).toEqual(29.6)
      expectRounded(@calc.Sz_x(0.4), 1).toEqual(26.1)
      expectRounded(@calc.Sz_x(0.5), 1).toEqual(22.6)
      expectRounded(@calc.Sz_x(0.6), 1).toEqual(19.2)
      expectRounded(@calc.Sz_x(0.7), 1).toEqual(15.7)
      expectRounded(@calc.Sz_x(0.8), 1).toEqual(12.2)
      expectRounded(@calc.Sz_x(0.9), 1).toEqual(8.7)
      expectRounded(@calc.Sz_x(1.0), 1).toEqual(5.3)

  describe '#s', ->
    it 'should return the correct values', ->
      expect(@calc.s(0.0)).toEqual(0)
      expect(@calc.s(0.1)).toEqual(5)
      expect(@calc.s(0.2)).toEqual(10)
      expect(@calc.s(0.3)).toEqual(15)
      expect(@calc.s(0.4)).toEqual(20)
      expect(@calc.s(0.5)).toEqual(25)
      expect(@calc.s(0.6)).toEqual(30)
      expect(@calc.s(0.7)).toEqual(35)
      expect(@calc.s(0.8)).toEqual(40)
      expect(@calc.s(0.9)).toEqual(45)
      expect(@calc.s(1.0)).toEqual(50)

  describe '#Sz_y', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Sz_y(0.0), 1).toEqual(0.0)
      expectRounded(@calc.Sz_y(0.1), 1).toEqual(3.9)
      expectRounded(@calc.Sz_y(0.2), 1).toEqual(6.9)
      expectRounded(@calc.Sz_y(0.3), 1).toEqual(9.1)
      expectRounded(@calc.Sz_y(0.4), 1).toEqual(10.4)
      expectRounded(@calc.Sz_y(0.5), 1).toEqual(10.9)
      expectRounded(@calc.Sz_y(0.6), 1).toEqual(10.4)
      expectRounded(@calc.Sz_y(0.7), 1).toEqual(9.1)
      expectRounded(@calc.Sz_y(0.8), 1).toEqual(6.9)
      expectRounded(@calc.Sz_y(0.9), 1).toEqual(3.9)
      expectRounded(@calc.Sz_y(1.0), 1).toEqual(0.0)

  describe '#Ss_x', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Ss_x(0.0), 2).toEqual(0.00)
      expectRounded(@calc.Ss_x(0.1), 2).toEqual(6.31)
      expectRounded(@calc.Ss_x(0.2), 2).toEqual(12.02)
      expectRounded(@calc.Ss_x(0.3), 2).toEqual(17.12)
      expectRounded(@calc.Ss_x(0.4), 2).toEqual(21.63)
      expectRounded(@calc.Ss_x(0.5), 2).toEqual(25.52)
      expectRounded(@calc.Ss_x(0.6), 2).toEqual(28.82)
      expectRounded(@calc.Ss_x(0.7), 2).toEqual(31.51)
      expectRounded(@calc.Ss_x(0.8), 2).toEqual(33.60)
      expectRounded(@calc.Ss_x(0.9), 2).toEqual(35.08)
      expectRounded(@calc.Ss_x(1.0), 2).toEqual(35.97)

  describe '#Ss_y', ->
    it 'should return the correct values', ->
      expectRounded(@calc.Ss_y(0.0), 2).toEqual(40.00)
      expectRounded(@calc.Ss_y(0.1), 2).toEqual(39.34)
      expectRounded(@calc.Ss_y(0.2), 2).toEqual(38.05)
      expectRounded(@calc.Ss_y(0.3), 2).toEqual(36.14)
      expectRounded(@calc.Ss_y(0.4), 2).toEqual(33.60)
      expectRounded(@calc.Ss_y(0.5), 2).toEqual(30.44)
      expectRounded(@calc.Ss_y(0.6), 2).toEqual(26.66)
      expectRounded(@calc.Ss_y(0.7), 2).toEqual(22.25)
      expectRounded(@calc.Ss_y(0.8), 2).toEqual(17.21)
      expectRounded(@calc.Ss_y(0.9), 2).toEqual(11.55)
      expectRounded(@calc.Ss_y(1.0), 2).toEqual( 5.27)

  describe '#basicAy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicAy(), 1).toEqual(0)
  describe '#basicAz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicAz(), 1).toEqual(-2.5)
  describe '#basicBy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicBy(), 1).toEqual(50)
  describe '#basicBz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicBz(), 1).toEqual(-2.5)
  describe '#basicCy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicCy(), 1).toEqual(50)
  describe '#basicCz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicCz(), 1).toEqual(2.5)
  describe '#basicDy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicDy(), 1).toEqual(0)
  describe '#basicDz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.basicDz(), 1).toEqual(2.5)
  describe '#Ay', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Ay(), 1).toEqual(-1.7)
  describe '#Az', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Az(), 1).toEqual(38.2)
  describe '#By', ->
    it 'should return the correct value', ->
      expectRounded(@calc.By(), 1).toEqual(34.2)
  describe '#Bz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Bz(), 1).toEqual(3.5)
  describe '#Cy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Cy(), 1).toEqual(37.7)
  describe '#Cz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Cz(), 1).toEqual(7.1)
  describe '#Dy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Dy(), 1).toEqual(1.7)
  describe '#Dz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.Dz(), 1).toEqual(41.8)
