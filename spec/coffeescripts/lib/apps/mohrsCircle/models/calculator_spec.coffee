describe 'ILR.MohrsCircle.Models.Calculator', ->
  beforeEach ->
    @model = new Backbone.Model
      nx: 0.5
      ny: -0.5
      nxy: 0.5
      alpha: 75
    @calc = new ILR.MohrsCircle.Models.Calculator model: @model

  describe '#nx', ->
    it 'should return the correct values', ->
      expect(@calc.nx()).toEqual 0.5
  describe '#ny', ->
    it 'should return the correct values', ->
      expect(@calc.ny()).toEqual -0.5
  describe '#nxy', ->
    it 'should return the correct values', ->
      expect(@calc.nxy()).toEqual 0.5
  describe '#alpha', ->
    it 'should return the correct values', ->
      expectRounded(@calc.alpha(), 3).toEqual 1.309

  describe '#nX', ->
    it 'should return the correct values', ->
      expectRounded(@calc.nX(), 3).toEqual -0.183
  describe '#nY', ->
    it 'should return the correct values', ->
      expectRounded(@calc.nY(), 3).toEqual 0.183
  describe '#nXY', ->
    it 'should return the correct values', ->
      expectRounded(@calc.nXY(), 3).toEqual -0.683
  describe '#n1', ->
    it 'should return the correct values', ->
      expectRounded(@calc.n1(), 3).toEqual 0.707
  describe '#n2', ->
    it 'should return the correct values', ->
      expectRounded(@calc.n2(), 3).toEqual -0.707
  describe '#x0', ->
    it 'should return the correct values', ->
      expectRounded(@calc.x0(), 3).toEqual 0
  describe '#R', ->
    it 'should return the correct values', ->
      expectRounded(@calc.R(), 3).toEqual 0.707
