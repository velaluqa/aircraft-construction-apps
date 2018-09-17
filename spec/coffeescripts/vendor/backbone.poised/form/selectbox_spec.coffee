describe 'Backbone.Poised.Selectbox', ->
  beforeEach ->
    @model = new Backbone.Model(attr: '')
    @view = new Backbone.Poised.Selectbox
      model: @model
      attribute: 'attr'
      placeholder: 'Select foo or bar'
      options: ['foo', 'bar']
      validate: false
    $('#jasmine_content').html(@view.render().el)

  describe 'Instantiation', ->
    it 'should require `model` option', ->
      expect => new Backbone.Poised.Selectbox()
      .toThrow new Error('Missing `model` option')
      expect => new Backbone.Poised.Selectbox(model: @model)
      .not.toThrow new Error('Missing `model` option')

    it 'should require `attribute` option', ->
      expect => new Backbone.Poised.Selectbox(model: @model)
      .toThrow new Error('Missing `attribute` option')
      expect => new Backbone.Poised.Selectbox(model: @model, attribute: 'attr')
      .not.toThrow new Error('Missing `attribute` option')

    it 'should define slider @attribute', ->
      view = new Backbone.Poised.Selectbox
        model: @model, attribute: 'attr'
      expect(view.attribute).toEqual('attr')

    it 'should use default options', ->
      view = new Backbone.Poised.Selectbox
        model: @model, attribute: 'attr'
      expect(view.options.placeholder).toEqual(null)
      expect(view.options.options).toEqual([])
      expect(view.options.multiselect).toEqual(false)
      expect(view.options.validate).toEqual(true)

    it 'should use given options', ->
      expect(@view.options.placeholder).toEqual('Select foo or bar')
      expect(@view.options.options).toEqual(['foo', 'bar'])
      expect(@view.options.validate).toEqual(false)

  describe 'Element', ->
    it 'should render a select element', ->
      expect(@view.el).toContainElement('select')

    it 'should render given select options', ->
      expect(@view.$('select')).toContainElement('option[value=foo]')
      expect(@view.$('select')).toContainElement('option[value=bar]')

    it 'should render a selected placeholder option', ->
      expect(@view.$('select')).toContainElement('option[value]')
      expect(@view.$('select option[value]')).toBeDisabled()
      expect(@view.$('select option[value]')).toBeSelected()

    describe 'single-selectbox value', ->
      beforeEach ->
        @model = new Backbone.Model(attr: 'foo')
        @view = new Backbone.Poised.Selectbox
          model: @model
          attribute: 'attr'
          placeholder: 'Select foo or bar'
          options: ['foo', 'bar']
          validate: false
        $('#jasmine_content').html(@view.render().el)

      it 'should render the initial model value selected', ->
        expect(@view.$('select option[value=foo]')).toBeSelected()

      it 'should render the new value on model change', ->
        expect(@view.$('select option[value=foo]')).toBeSelected()
        expect(@view.$('select option[value=bar]')).not.toBeSelected()
        @model.set attr: 'bar'
        expect(@view.$('select option[value=foo]')).not.toBeSelected()
        expect(@view.$('select option[value=bar]')).toBeSelected()

      it 'should change the model attribute value, on value change', ->
        @view.$('select').val('bar').change()
        expect(@model.get('attr')).toEqual('bar')

    describe 'multi-selectbox value', ->
      beforeEach ->
        @model = new Backbone.Model(attr: ['foo', 'baz'])
        @view = new Backbone.Poised.Selectbox
          model: @model
          attribute: 'attr'
          placeholder: 'Select something'
          options: ['foo', 'bar', 'fu', 'baz']
          multiselect: true
          validate: false
        $('#jasmine_content').html(@view.render().el)

      it 'should render the initial model value selected', ->
        expect(@view.$('select option[value=foo]')).toBeSelected()
        expect(@view.$('select option[value=bar]')).not.toBeSelected()
        expect(@view.$('select option[value=fu]')).not.toBeSelected()
        expect(@view.$('select option[value=baz]')).toBeSelected()

      it 'should render the new value on model change', ->
        expect(@view.$('select option[value=foo]')).toBeSelected()
        expect(@view.$('select option[value=bar]')).not.toBeSelected()
        expect(@view.$('select option[value=fu]')).not.toBeSelected()
        expect(@view.$('select option[value=baz]')).toBeSelected()
        @model.set attr: ['foo', 'bar', 'fu', 'baz']
        expect(@view.$('select option[value=foo]')).toBeSelected()
        expect(@view.$('select option[value=bar]')).toBeSelected()
        expect(@view.$('select option[value=fu]')).toBeSelected()
        expect(@view.$('select option[value=baz]')).toBeSelected()

      it 'should change the model attribute value, on value change', ->
        @view.$('select').val(['fu']).change()
        expect(@model.get('attr')).toEqual(['fu'])
