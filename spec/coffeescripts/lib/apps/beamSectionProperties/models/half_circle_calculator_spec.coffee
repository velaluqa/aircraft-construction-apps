describe 'ILR.BeamSectionProperties.Models.HalfCircleCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      baseThickness: 1
      relBaseThickness: 1
      averageRadius: 10
    @calc = new ILR.BeamSectionProperties.Models.HalfCircleCalculator
      model: @model

  describe '#baseThickness', ->
    it 'should return ', ->
      expect(@calc.baseThickness()).toEqual(1)
  describe '#relBaseThickness', ->
    it 'should return ', ->
      expect(@calc.relBaseThickness()).toEqual(1)
  describe '#averageRadius', ->
    it 'should return ', ->
      expect(@calc.averageRadius()).toEqual(10)

  describe '#relEdgeThickness', ->
    it 'should return the correct value', ->
      expectRounded(@calc.relEdgeThickness()).toEqual(1.0)
  describe '#tCircle', ->
    it 'should return the correct value', ->
      expectRounded(@calc.tCircle()).toEqual(1)
  describe '#h', ->
    it 'should return the correct value', ->
      expectRounded(@calc.h()).toEqual(20)
  describe '#openShearCenterX', ->
    it 'should return the correct value', ->
      expectRounded(@calc.openShearCenterX()).toEqual(-8.9387)
  describe '#closedShearCenterX', ->
    it 'should return the correct value', ->
      expectRounded(@calc.closedShearCenterX()).toEqual(-1.6565)

  describe '#outerAy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerAy(), 1).toEqual(-10.5)
  describe '#outerAz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerAz(), 1).toEqual(0.5)
  describe '#outerBy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerBy(), 1).toEqual(-10.5)
  describe '#outerBz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerBz(), 1).toEqual(-0.6)
  describe '#outerCy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerCy(), 1).toEqual(-10.4)
  describe '#outerCz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerCz(), 1).toEqual(-1.7)
  describe '#outerDy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerDy(), 1).toEqual(-10.1)
  describe '#outerDz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerDz(), 1).toEqual(-2.8)
  describe '#outerEy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerEy(), 1).toEqual(-9.7)
  describe '#outerEz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerEz(), 1).toEqual(-3.9)
  describe '#outerFy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerFy(), 1).toEqual(-9.2)
  describe '#outerFz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerFz(), 1).toEqual(-5.0)
  describe '#outerGy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerGy(), 1).toEqual(-8.5)
  describe '#outerGz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerGz(), 1).toEqual(-6.1)
  describe '#outerHy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerHy(), 1).toEqual(-7.6)
  describe '#outerHz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerHz(), 1).toEqual(-7.2)
  describe '#outerIy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerIy(), 1).toEqual(-6.4)
  describe '#outerIz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerIz(), 1).toEqual(-8.3)
  describe '#outerJy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerJy(), 1).toEqual(-4.7)
  describe '#outerJz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerJz(), 1).toEqual(-9.4)
  describe '#outerKy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerKy(), 1).toEqual(-4.2)
  describe '#outerKz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerKz(), 1).toEqual(-9.6)
  describe '#outerLy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerLy(), 1).toEqual(-2.6)
  describe '#outerLz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerLz(), 1).toEqual(-10.2)
  describe '#outerMy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerMy(), 1).toEqual(0.0)
  describe '#outerMz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerMz(), 1).toEqual(-10.5)
  describe '#outerNy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerNy(), 1).toEqual(2.6)
  describe '#outerNz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerNz(), 1).toEqual(-10.2)
  describe '#outerOy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerOy(), 1).toEqual(4.2)
  describe '#outerOz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerOz(), 1).toEqual(-9.6)
  describe '#outerPy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerPy(), 1).toEqual(4.7)
  describe '#outerPz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerPz(), 1).toEqual(-9.4)
  describe '#outerQy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerQy(), 1).toEqual(6.4)
  describe '#outerQz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerQz(), 1).toEqual(-8.3)
  describe '#outerRy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerRy(), 1).toEqual(7.6)
  describe '#outerRz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerRz(), 1).toEqual(-7.2)
  describe '#outerSy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerSy(), 1).toEqual(8.5)
  describe '#outerSz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerSz(), 1).toEqual(-6.1)
  describe '#outerTy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerTy(), 1).toEqual(9.2)
  describe '#outerTz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerTz(), 1).toEqual(-5.0)
  describe '#outerUy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerUy(), 1).toEqual(9.7)
  describe '#outerUz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerUz(), 1).toEqual(-3.9)
  describe '#outerVy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerVy(), 1).toEqual(10.1)
  describe '#outerVz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerVz(), 1).toEqual(-2.8)
  describe '#outerWy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerWy(), 1).toEqual(10.4)
  describe '#outerWz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerWz(), 1).toEqual(-1.7)
  describe '#outerXy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerXy(), 1).toEqual(10.5)
  describe '#outerXz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerXz(), 1).toEqual(-0.6)
  describe '#outerYy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerYy(), 1).toEqual(10.5)
  describe '#outerYz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerYz(), 1).toEqual(0.5)
  describe '#outerZy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerZy(), 1).toEqual(-10.5)
  describe '#outerZz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.outerZz(), 1).toEqual(0.5)

  describe '#innerAy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerAy(), 1).toEqual(-9.5)
  describe '#innerAz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerAz(), 1).toEqual(-0.5)
  describe '#innerBy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerBy(), 1).toEqual(-9.4)
  describe '#innerBz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerBz(), 1).toEqual(-1.4)
  describe '#innerCy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerCy(), 1).toEqual(-9.2)
  describe '#innerCz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerCz(), 1).toEqual(-2.3)
  describe '#innerDy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerDy(), 1).toEqual(-8.9)
  describe '#innerDz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerDz(), 1).toEqual(-3.2)
  describe '#innerEy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerEy(), 1).toEqual(-8.6)
  describe '#innerEz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerEz(), 1).toEqual(-4.1)
  describe '#innerFy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerFy(), 1).toEqual(-8.1)
  describe '#innerFz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerFz(), 1).toEqual(-5.0)
  describe '#innerGy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerGy(), 1).toEqual(-7.4)
  describe '#innerGz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerGz(), 1).toEqual(-5.9)
  describe '#innerHy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerHy(), 1).toEqual(-6.6)
  describe '#innerHz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerHz(), 1).toEqual(-6.8)
  describe '#innerIy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerIy(), 1).toEqual(-5.6)
  describe '#innerIz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerIz(), 1).toEqual(-7.7)
  describe '#innerJy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerJy(), 1).toEqual(-4.0)
  describe '#innerJz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerJz(), 1).toEqual(-8.6)
  describe '#innerKy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerKy(), 1).toEqual(-2.9)
  describe '#innerKz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerKz(), 1).toEqual(-9.1)
  describe '#innerLy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerLy(), 1).toEqual(-2.2)
  describe '#innerLz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerLz(), 1).toEqual(-9.2)
  describe '#innerMy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerMy(), 1).toEqual(0.0)
  describe '#innerMz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerMz(), 1).toEqual(-9.5)
  describe '#innerNy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerNy(), 1).toEqual(2.2)
  describe '#innerNz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerNz(), 1).toEqual(-9.2)
  describe '#innerOy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerOy(), 1).toEqual(2.9)
  describe '#innerOz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerOz(), 1).toEqual(-9.1)
  describe '#innerPy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerPy(), 1).toEqual(4.0)
  describe '#innerPz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerPz(), 1).toEqual(-8.6)
  describe '#innerQy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerQy(), 1).toEqual(5.6)
  describe '#innerQz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerQz(), 1).toEqual(-7.7)
  describe '#innerRy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerRy(), 1).toEqual(6.6)
  describe '#innerRz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerRz(), 1).toEqual(-6.8)
  describe '#innerSy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerSy(), 1).toEqual(7.4)
  describe '#innerSz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerSz(), 1).toEqual(-5.9)
  describe '#innerTy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerTy(), 1).toEqual(8.1)
  describe '#innerTz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerTz(), 1).toEqual(-5.0)
  describe '#innerUy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerUy(), 1).toEqual(8.6)
  describe '#innerUz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerUz(), 1).toEqual(-4.1)
  describe '#innerVy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerVy(), 1).toEqual(8.9)
  describe '#innerVz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerVz(), 1).toEqual(-3.2)
  describe '#innerWy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerWy(), 1).toEqual(9.2)
  describe '#innerWz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerWz(), 1).toEqual(-2.3)
  describe '#innerXy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerXy(), 1).toEqual(9.4)
  describe '#innerXz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerXz(), 1).toEqual(-1.4)
  describe '#innerYy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerYy(), 1).toEqual(9.5)
  describe '#innerYz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerYz(), 1).toEqual(-0.5)
  describe '#innerZy', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerZy(), 1).toEqual(-9.5)
  describe '#innerZz', ->
    it 'should return the correct value', ->
      expectRounded(@calc.innerZz(), 1).toEqual(-0.5)
