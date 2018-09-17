describe 'IRL.DirectOperatingCosts.Models.App', ->
  beforeEach ->
    @doc = new ILR.DirectOperatingCosts.Models.App()

  describe '#curves', ->
    it 'should be a collection with limit 3 on attribute `selected`', ->
      expect(@doc.curves).toBeInstanceOf(ILR.Collections.Curves)
      expect(@doc.curves.limit).toEqual(3)

  describe '#airplanes', ->
    it 'should be a collection with limit 2 on attribute `selected`', ->
      expect(@doc.airplanes).toBeInstanceOf(ILR.DirectOperatingCosts.Collections.Airplanes)
      expect(@doc.airplanes.limit).toEqual(2)
