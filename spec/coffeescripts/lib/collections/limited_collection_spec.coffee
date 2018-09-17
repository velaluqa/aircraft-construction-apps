describe 'ILR.Collections.LimitedCollection', ->
  beforeEach ->
    @model1 = new Backbone.Model name: 'First'
    @model2 = new Backbone.Model name: 'Second'
    @model3 = new Backbone.Model name: 'Third'
    @collection = new ILR.Collections.LimitedCollection [@model1, @model2, @model3],
      limit: 2

  describe 'deselecting a curve', ->
    it 'should remove the curve from array of selected curves', ->
      @collection.each (model) -> model.set selected: false
      change = jasmine.createSpy('change:selected')
      @collection.on "change:selected", change

      @model1.set selected: true

      expect(@collection.history).toInclude(@model1)
      @model1.set selected: false
      expect(@collection.history).not.toInclude(@model1)

      expect(change).toHaveBeenCalled()

  describe 'selecting a model', ->
    it 'should manipulate the history accordingly', ->
      @collection.each (model) -> model.set selected: false
      change = jasmine.createSpy('change:selected')
      @collection.on "change:selected", change

      expect(@collection.history).toEqual([])
      @model1.set selected: true
      expect(@collection.history).toInclude(@model1)

      expect(change).toHaveBeenCalled()

    it 'should remove and deselect oldest if collection is at its limit', ->
      @collection.each (model) -> model.set selected: false
      change = jasmine.createSpy('change:selected')
      @collection.on "change:selected", change

      @model1.set selected: true
      @model2.set selected: true

      expect(@collection.history).toEqual([@model1, @model2])
      @model3.set selected: true
      expect(@collection.history).toEqual([@model2, @model3])

      expect(@model1.get('selected')).toBeFalsy()

      expect(change).toHaveBeenCalled()
