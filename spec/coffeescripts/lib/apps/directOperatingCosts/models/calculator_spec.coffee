describe 'ILR.DirectOperatingCosts.Models.Calculator', ->
  describe 'predefined airplane', ->
    beforeEach ->
      # create C model
      @doc = new Backbone.Model
        holdingTime: 30 # in min
        diversionRange: 200 # in nm
        fuelReserve: 5 # in %
      # create Costs model
      @costs = new Backbone.Model
        oemPrice: 1150         # in €/kg
        interestRate: 5        # in %
        amortizationPeriod: 12 # in years
        residualValue: 15      # in %
        insuranceRate: 0.5     # in %

        avgSalaryFA: 60000     # in €/year
        avgSalaryFC: 300000    # in €/year for 2 pilots
        crewComplement: 7

        fuelPrice: 0.7         # in €/kg
        payloadCosts: 0.28     # in €/kg
        mtomCosts: 0.01        # in €/kgFH
        landingPrice: 0.01     # in €/kg
        handlingPrice: 0.1     # in €/kg
        costBurden: 2
        laborRate: 50          # in €/h
        atcPrice: 0.7

        transportRate: 0.3     # in €/tkm

      # create Airplane model
      @airplane = new Backbone.Model
        predefined: true
        maxTakeOffMass: 270000
        maxFuelMass: 113000
        operationEmptyMass: 136000
        maxPayload: 41000
        ldRatio: 18
        sfc: 0.65
        maxRange: 8412
        speed: 854
        engineCount: 2
        slst: 233

      # create calculator
      @calc = new ILR.DirectOperatingCosts.Models.Calculator
        doc: @doc
        airplane: @airplane
        costs: @costs

    describe 'doc parameter', ->
      describe '#R_div', ->
        it 'should return the correct value', ->
          expectRounded(@calc.R_div()).toEqual(370.4)
      describe '#f_RFc', ->
        it 'should return the correct value', ->
          expect(@calc.f_RFc()).toEqual(0.05)
      describe '#R_hold', ->
        it 'should return the correct value', ->
          expect(@calc.R_hold()).toEqual(427)

    describe 'cost parameter', ->
      describe '#p_OE', ->
        it 'should return the correct value', ->
          expect(@calc.p_OE()).toEqual(1150)
      describe '#i', ->
        it 'should return the correct value', ->
          expect(@calc.i()).toEqual(0.05)
      describe '#ap', ->
        it 'should return the correct value', ->
          expect(@calc.ap()).toEqual(12)
      describe '#r', ->
        it 'should return the correct value', ->
          expect(@calc.r()).toEqual(0.15)
      describe '#f_Ins', ->
        it 'should return the correct value', ->
          expect(@calc.f_Ins()).toEqual(0.005)
      describe '#S_FA', ->
        it 'should return the correct value', ->
          expect(@calc.S_FA()).toEqual(60000)
      describe '#S_FC', ->
        it 'should return the correct value', ->
          expect(@calc.S_FC()).toEqual(300000)
      describe '#CC', ->
        it 'should return the correct value', ->
          expect(@calc.CC()).toEqual(7)
      describe '#p_F', ->
        it 'should return the correct value', ->
          expect(@calc.p_F()).toEqual(0.7)
      describe '#p_L', ->
        it 'should return the correct value', ->
          expect(@calc.p_L()).toEqual(0.01)
      describe '#p_H', ->
        it 'should return the correct value', ->
          expect(@calc.p_H()).toEqual(0.1)
      describe '#B', ->
        it 'should return the correct value', ->
          expect(@calc.B()).toEqual(2)
      describe '#LR', ->
        it 'should return the correct value', ->
          expect(@calc.LR()).toEqual(50)
      describe '#p_FR', ->
        it 'should return the correct value', ->
          expect(@calc.p_FR()).toEqual(0.7)
      describe '#tr', ->
        it 'should return the correct value', ->
          expect(@calc.tr()).toEqual(0.3)

    describe 'airplane parameter', ->
      describe '#predefinedAirplane', ->
        it 'should return the correct value', ->
          expect(@calc.predefinedAirplane()).toEqual(true)
      describe '#m_TOmax', ->
        it 'should return the correct value', ->
          expect(@calc.m_TOmax()).toEqual(270000)
      describe '#m_Fmax', ->
        it 'should return the correct value', ->
          expect(@calc.m_Fmax()).toEqual(113000)
      describe '#m_OE', ->
        it 'should return the correct value', ->
          expect(@calc.m_OE()).toEqual(136000)
      describe '#m_PLmax', ->
        it 'should return the correct value', ->
          expect(@calc.m_PLmax()).toEqual(41000)
      describe '#ldRatio', ->
        it 'should return the correct value', ->
          expect(@calc.ldRatio()).toEqual(18)
      describe '#sfc', ->
        it 'should return the correct value', ->
          expect(@calc.sfc()).toEqual(0.65)
      describe '#maxRange', ->
        it 'should return the correct value', ->
          expect(@calc.maxRange()).toEqual(8412)
      describe '#v', ->
        it 'should return the correct value', ->
          expect(@calc.v()).toEqual(854)
      describe '#N_eng', ->
        it 'should return the correct value', ->
          expect(@calc.N_eng()).toEqual(2)
      describe '#SLST', ->
        it 'should return the correct value', ->
          expect(@calc.SLST()).toEqual(233)

    describe '#eta', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.eta()).toEqual(15515.2526)

    describe '#R_A', ->
      it 'should calculate the correct values', ->
        expect(@calc.R_A()).toEqual(0)

    describe '#R_B', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.R_B()).toEqual(5426.0218)

    describe '#R_C', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.R_C()).toEqual(7153.4110)

    describe '#R_D', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.R_D()).toEqual(8049.4764)

    describe '#m_PL', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.m_PL(@calc.R_A())).toEqual(41000)
        expectRounded(@calc.m_PL(@calc.R_B())).toEqual(41000)
        expectRounded(@calc.m_PL(@calc.R_C())).toEqual(21000)
        expectRounded(@calc.m_PL(@calc.R_D())).toEqual(0)

    describe '#m_TO', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.m_TO(@calc.R_A())).toEqual(186334.6628)
        expectRounded(@calc.m_TO(@calc.R_B())).toEqual(270000)
        expectRounded(@calc.m_TO(@calc.R_C())).toEqual(270000)
        expectRounded(@calc.m_TO(@calc.R_D())).toEqual(249000)

    describe '#m_F', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.m_F(@calc.R_A())).toEqual(9334.6628)
        expectRounded(@calc.m_F(@calc.R_B())).toEqual(93000)
        expectRounded(@calc.m_F(@calc.R_C())).toEqual(113000)
        expectRounded(@calc.m_F(@calc.R_D())).toEqual(113000)

    describe '#m_TF', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.m_TF(@calc.R_A())).toEqual(0)
        expectRounded(@calc.m_TF(@calc.R_B())).toEqual(79681.2735)
        expectRounded(@calc.m_TF(@calc.R_C())).toEqual(99733.4298)
        expectRounded(@calc.m_TF(@calc.R_D())).toEqual(100788.1940)

    describe '#m_RF', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.m_RF(@calc.R_A())).toEqual(9334.6628)
        expectRounded(@calc.m_RF(@calc.R_B())).toEqual(13318.7265)
        expectRounded(@calc.m_RF(@calc.R_C())).toEqual(13266.5702)
        expectRounded(@calc.m_RF(@calc.R_D())).toEqual(12211.8060)

    describe '#flights', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.flights(@calc.R_A())).toEqual(3284.6995)
        expectRounded(@calc.flights(@calc.R_B())).toEqual(734.5128)
        expectRounded(@calc.flights(@calc.R_C())).toEqual(588.9465)
        expectRounded(@calc.flights(@calc.R_D())).toEqual(534.0445)

    describe '#fh', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.fh(@calc.R_A())).toEqual(0)
        expectRounded(@calc.fh(@calc.R_B())).toEqual(6.3537)
        expectRounded(@calc.fh(@calc.R_C())).toEqual(8.3764)
        expectRounded(@calc.fh(@calc.R_D())).toEqual(9.4256)

    describe '#fhPA', ->
      it 'should calculate the correct values', ->
        expectRounded(@calc.fhPA(@calc.R_A())).toEqual(0)
        expectRounded(@calc.fhPA(@calc.R_B())).toEqual(4666.8415)
        expectRounded(@calc.fhPA(@calc.R_C())).toEqual(4933.2279)
        expectRounded(@calc.fhPA(@calc.R_D())).toEqual(5033.6986)

    describe 'new C method', ->
      describe '#a', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.a(), 8).toEqual(0.1034016)
      describe '#C_cap', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.C_cap()).toEqual(16954010.0082)
      describe '#C_crew', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.C_crew()).toEqual(5544000)
      describe '#C1', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.C_1()).toEqual(22498010.0082)
      describe '#MC_af_mat', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.MC_af_mat(@calc.R_A())).toEqual(1920.7)
          expectRounded(@calc.MC_af_mat(@calc.R_B())).toEqual(2093.5194)
          expectRounded(@calc.MC_af_mat(@calc.R_C())).toEqual(2148.5370)
          expectRounded(@calc.MC_af_mat(@calc.R_D())).toEqual(2177.0768)
      describe '#MC_af_per', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.MC_af_per(@calc.R_A())).toEqual(242.1)
          expectRounded(@calc.MC_af_per(@calc.R_B())).toEqual(2162.4924)
          expectRounded(@calc.MC_af_per(@calc.R_C())).toEqual(2773.8547)
          expectRounded(@calc.MC_af_per(@calc.R_D())).toEqual(3090.9925)
      describe '#MC_eng', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.MC_eng(@calc.R_A())).toEqual(92.4538)
          expectRounded(@calc.MC_eng(@calc.R_B())).toEqual(480.0268)
          expectRounded(@calc.MC_eng(@calc.R_C())).toEqual(603.4118)
          expectRounded(@calc.MC_eng(@calc.R_D())).toEqual(667.4164)
      describe '#MC', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.MC(@calc.R_A())).toEqual(2255.2538)
          expectRounded(@calc.MC(@calc.R_B())).toEqual(4736.0386)
          expectRounded(@calc.MC(@calc.R_C())).toEqual(5525.8034)
          expectRounded(@calc.MC(@calc.R_D())).toEqual(5935.4857)
      describe '#ATC', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.ATC(@calc.R_A())).toEqual(0)
          expectRounded(@calc.ATC(@calc.R_B())).toEqual(8826.2547)
          expectRounded(@calc.ATC(@calc.R_C())).toEqual(11636.1176)
          expectRounded(@calc.ATC(@calc.R_D())).toEqual(13093.7049)
      describe '#C_2', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.C_2(@calc.R_A())).toEqual(29743787.2830)
          expectRounded(@calc.C_2(@calc.R_B())).toEqual(55925208.1378)
          expectRounded(@calc.C_2(@calc.R_C())).toEqual(54050757.1159)
          expectRounded(@calc.C_2(@calc.R_D())).toEqual(49282121.2048)
      describe '#C', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.C(@calc.R_A())).toEqual(52241797.2911)
          expectRounded(@calc.C(@calc.R_B())).toEqual(78423218.1460)
          expectRounded(@calc.C(@calc.R_C())).toEqual(76548767.1241)
          expectRounded(@calc.C(@calc.R_D())).toEqual(71780131.2130)
      describe '#tko', ->
        it 'should calculate the correct values', ->
          expectRounded(@calc.tko(@calc.R_A())).toEqual(0)
          expectRounded(@calc.tko(@calc.R_B())).toEqual(222466.8954)
          expectRounded(@calc.tko(@calc.R_C())).toEqual(150221.6317)
          expectRounded(@calc.tko(@calc.R_D())).toEqual(0)
      describe '#sko', ->
        it 'should calculate the correct values', ->
          expect(@calc.sko(@calc.R_A())).toBeNull()
          expectRounded(@calc.sko(@calc.R_B())).toEqual(0.4799)
          expectRounded(@calc.sko(@calc.R_C())).toEqual(0.8652)
          expect(@calc.sko(@calc.R_D())).toBeNull()
