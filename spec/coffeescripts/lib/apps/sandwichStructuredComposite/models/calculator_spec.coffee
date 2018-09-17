describe 'ILR.SandwichStructuredComposite.Models.Calculator', ->
  beforeEach ->
    @model = new Backbone.Model
      width: 1
      length: 20
      height: 0.2
      skinRatio: 10
      load: 54
      elasticModulusSkin: 100
      shearModulusCore: 500

    @calc = new ILR.SandwichStructuredComposite.Models.Calculator
      model: @model

  describe 'model parameter', ->
    describe '#width', ->
      it 'should return the correct value', ->
        expect(@calc.width()).toEqual(1)
    describe '#length', ->
      it 'should return the correct value', ->
        expect(@calc.length()).toEqual(20)
    describe '#height', ->
      it 'should return the correct value', ->
        expect(@calc.height()).toEqual(0.2)
    describe '#skinRatio', ->
      it 'should return the correct value', ->
        expectRounded(@calc.skinRatio()).toEqual(0.1)
    describe '#load', ->
      it 'should return the correct value', ->
        expectRounded(@calc.load()).toEqual(0.054)
    describe '#elasticModulusSkin', ->
      it 'should return the correct value', ->
        expect(@calc.elasticModulusSkin()).toEqual(100000)
    describe '#shearModulusCore', ->
      it 'should return the correct value', ->
        expectRounded(@calc.shearModulusCore()).toEqual(500)

  describe '#w_stress_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.w_stress_value(0.0 * @model.get('length'))).toEqual(0.0000)
      expectRounded(@calc.w_stress_value(0.1 * @model.get('length'))).toEqual(-0.9720)
      expectRounded(@calc.w_stress_value(0.2 * @model.get('length'))).toEqual(-1.7280)
      expectRounded(@calc.w_stress_value(0.3 * @model.get('length'))).toEqual(-2.2680)
      expectRounded(@calc.w_stress_value(0.4 * @model.get('length'))).toEqual(-2.5920)
      expectRounded(@calc.w_stress_value(0.5 * @model.get('length'))).toEqual(-2.7000)
      expectRounded(@calc.w_stress_value(0.6 * @model.get('length'))).toEqual(-2.5920)
      expectRounded(@calc.w_stress_value(0.7 * @model.get('length'))).toEqual(-2.2680)
      expectRounded(@calc.w_stress_value(0.8 * @model.get('length'))).toEqual(-1.7280)
      expectRounded(@calc.w_stress_value(0.9 * @model.get('length'))).toEqual(-0.9720)
      expectRounded(@calc.w_stress_value(1.0 * @model.get('length'))).toEqual(0.0000)

  describe '#w_beam_value', ->
    it 'should return the correct value', ->
      expectRounded(@calc.w_beam_value(0.0 * @model.get('length'))).toEqual(0.0000)
      expectRounded(@calc.w_beam_value(0.1 * @model.get('length'))).toEqual(-0.8829)
      expectRounded(@calc.w_beam_value(0.2 * @model.get('length'))).toEqual(-1.6704)
      expectRounded(@calc.w_beam_value(0.3 * @model.get('length'))).toEqual(-2.2869)
      expectRounded(@calc.w_beam_value(0.4 * @model.get('length'))).toEqual(-2.6784)
      expectRounded(@calc.w_beam_value(0.5 * @model.get('length'))).toEqual(-2.8125)
      expectRounded(@calc.w_beam_value(0.6 * @model.get('length'))).toEqual(-2.6784)
      expectRounded(@calc.w_beam_value(0.7 * @model.get('length'))).toEqual(-2.2869)
      expectRounded(@calc.w_beam_value(0.8 * @model.get('length'))).toEqual(-1.6704)
      expectRounded(@calc.w_beam_value(0.9 * @model.get('length'))).toEqual(-0.8829)
      expectRounded(@calc.w_beam_value(1.0 * @model.get('length'))).toEqual(0.0000)
