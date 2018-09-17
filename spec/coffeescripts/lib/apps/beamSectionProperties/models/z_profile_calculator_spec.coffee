describe 'ILR.BeamSectionProperties.Models.ZProfileCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      h: 1.0
      b: 0.5
      tf: 0.1
      ts: 0.1
      alfa: 30.0
    @calc = new ILR.BeamSectionProperties.Models.ZProfileCalculator
      model: @model

  describe '#h', ->
    it 'should return the correct values', ->
      expect(@calc.h()).toEqual 1.0
  describe '#b', ->
    it 'should return the correct values', ->
      expect(@calc.b()).toEqual 0.5
  describe '#tf', ->
    it 'should return the correct values', ->
      expect(@calc.tf()).toEqual 0.1
  describe '#ts', ->
    it 'should return the correct values', ->
      expect(@calc.ts()).toEqual 0.1
  describe '#alfa', ->
    it 'should return the correct values', ->
      expectRounded(@calc.alfa()).toEqual 0.5236

  describe '#baseAx', ->
    it 'should return the correct values', ->
      expect(@calc.baseAx()).toEqual -0.55
  describe '#baseAy', ->
    it 'should return the correct values', ->
      expect(@calc.baseAy()).toEqual 0.6
  describe '#baseBx', ->
    it 'should return the correct values', ->
      expect(@calc.baseBx()).toEqual -0.55
  describe '#baseBy', ->
    it 'should return the correct values', ->
      expect(@calc.baseBy()).toEqual 0.5
  describe '#baseCx', ->
    it 'should return the correct values', ->
      expect(@calc.baseCx()).toEqual -0.05
  describe '#baseCy', ->
    it 'should return the correct values', ->
      expect(@calc.baseCy()).toEqual 0.5
  describe '#baseDx', ->
    it 'should return the correct values', ->
      expect(@calc.baseDx()).toEqual -0.05
  describe '#baseDy', ->
    it 'should return the correct values', ->
      expect(@calc.baseDy()).toEqual -0.6
  describe '#baseEx', ->
    it 'should return the correct values', ->
      expect(@calc.baseEx()).toEqual 0.55
  describe '#baseEy', ->
    it 'should return the correct values', ->
      expect(@calc.baseEy()).toEqual -0.6
  describe '#baseFx', ->
    it 'should return the correct values', ->
      expect(@calc.baseFx()).toEqual 0.55
  describe '#baseFy', ->
    it 'should return the correct values', ->
      expect(@calc.baseFy()).toEqual -0.5
  describe '#baseGx', ->
    it 'should return the correct values', ->
      expect(@calc.baseGx()).toEqual 0.05
  describe '#baseGy', ->
    it 'should return the correct values', ->
      expect(@calc.baseGy()).toEqual -0.5
  describe '#baseHx', ->
    it 'should return the correct values', ->
      expect(@calc.baseHx()).toEqual 0.05
  describe '#baseHy', ->
    it 'should return the correct values', ->
      expect(@calc.baseHy()).toEqual 0.6
  describe '#baseIx', ->
    it 'should return the correct values', ->
      expect(@calc.baseIx()).toEqual -0.55
  describe '#baseIy', ->
    it 'should return the correct values', ->
      expect(@calc.baseIy()).toEqual 0.6

  describe '#rotAx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotAx(), 3).toEqual -0.176
  describe '#rotAy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotAy(), 3).toEqual 0.795
  describe '#rotBx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotBx(), 3).toEqual -0.226
  describe '#rotBy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotBy(), 3).toEqual 0.708
  describe '#rotCx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotCx(), 3).toEqual 0.207
  describe '#rotCy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotCy(), 3).toEqual 0.458
  describe '#rotDx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotDx(), 3).toEqual -0.343
  describe '#rotDy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotDy(), 3).toEqual -0.495
  describe '#rotEx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotEx(), 3).toEqual 0.176
  describe '#rotEy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotEy(), 3).toEqual -0.795
  describe '#rotFx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotFx(), 3).toEqual 0.226
  describe '#rotFy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotFy(), 3).toEqual -0.708
  describe '#rotGx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotGx(), 3).toEqual -0.207
  describe '#rotGy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotGy(), 3).toEqual -0.458
  describe '#rotHx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotHx(), 3).toEqual 0.343
  describe '#rotHy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotHy(), 3).toEqual 0.495
  describe '#rotIx', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotIx(), 3).toEqual -0.176
  describe '#rotIy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.rotIy(), 3).toEqual 0.795

  describe '#IyAlpha0', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyAlpha0(), 3).toEqual 0.045
  describe '#IzAlpha0', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IzAlpha0(), 3).toEqual 0.011
  describe '#IyzAlpha0', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyzAlpha0(), 3).toEqual -0.017

  describe '#IyAlphaX', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyAlphaX(), 4).toEqual 0.0506
  describe '#IzAlphaX', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IzAlphaX(), 4).toEqual 0.0053
  describe '#IyzAlphaX', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyzAlphaX(), 4).toEqual 0.0063

  describe '#IyRadius', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyRadius(), 4).toEqual 1.1319
  describe '#IzRadius', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IzRadius(), 4).toEqual 0.4723
  describe '#IyzRadius', ->
    it 'should return the correct values', ->
      expectRounded(@calc.IyzRadius(), 4).toEqual -0.3805
