describe 'ILR.ThinWalledCantilever.Models.Calculator', ->
  beforeEach ->
    @thinWalledCantilever = new Backbone.Model
      load: 700
      length: 10
      height: 5
      thickness: 0.02
      E: 72
      nue: 0.3
      continuous: 'no'
    @calc = new ILR.ThinWalledCantilever.Models.Calculator
      model: @thinWalledCantilever
    @calc.accuracy_x = 10
    @calc.accuracy_y = 10
    @calc.z_segments = 10
    @calc.x_segments = 2

  describe '#load', ->
    it 'should return the model attribute', ->
      expect(@calc.load()).toEqual(700)

  describe '#length', ->
    it 'should return the model attribute', ->
      expect(@calc.length()).toEqual(10)

  describe '#height', ->
    it 'should return the model attribute', ->
      expect(@calc.height()).toEqual(5)

  describe '#thickness', ->
    it 'should return the model attribute', ->
      expect(@calc.thickness()).toEqual(0.02)

  describe '#E', ->
    it 'should return the model attribute', ->
      expect(@calc.E()).toEqual(72000)

  describe '#nue', ->
    it 'should return the model attribute', ->
      expect(@calc.nue()).toEqual(0.3)

  describe '#I', ->
    it 'should return the model attribute', ->
      expectRounded(@calc.I()).toEqual(0.2083)

  describe '#G', ->
    it 'should return the model attribute', ->
      expectRounded(@calc.G()).toEqual(27692.3077)

  describe '#continuous', ->
    it 'should return the model attribute in non-continuous mode', ->
      expect(@calc.continuous()).toEqual(false)

    it 'should return the model attribute in continuous mode', ->
      @thinWalledCantilever.set('continuous', 'yes')
      expect(@calc.continuous()).toEqual(true)

  describe '#orthogonal_point_left', ->
    it 'should return correct values', ->
      for a in [-2..2]
        for b in [-2..2]
          expectRoundedArray(@calc.orthogonal_point_left(-2.5, Math.sqrt(29), a, b)).toEqual [a+5, b+2]
          expectRoundedArray(@calc.orthogonal_point_left(-1, Math.sqrt(2), a, b)).toEqual [a+1, b+1]
          expectRoundedArray(@calc.orthogonal_point_left(-0.5, Math.sqrt(5), a, b)).toEqual [a+1, b+2]
          expectRoundedArray(@calc.orthogonal_point_left(0, 5, a, b)).toEqual [a, b+5]
          expectRoundedArray(@calc.orthogonal_point_left(0.5, Math.sqrt(5), a, b)).toEqual [a+1, b-2]
          expectRoundedArray(@calc.orthogonal_point_left(1, Math.sqrt(2), a, b)).toEqual [a+1, b-1]
          expectRoundedArray(@calc.orthogonal_point_left(2.5, Math.sqrt(29), a, b)).toEqual [a+5, b-2]


  describe '#w', ->
    it 'should return correct values', ->
      expectRounded(@calc.w(0)).toEqual 0
      expectRounded(@calc.w(1)).toEqual -0.2256
      expectRounded(@calc.w(2)).toEqual -0.8711
      expectRounded(@calc.w(3)).toEqual -1.89
      expectRounded(@calc.w(4)).toEqual -3.2356
      expectRounded(@calc.w(5)).toEqual -4.8611
      expectRounded(@calc.w(6)).toEqual -6.72
      expectRounded(@calc.w(7)).toEqual -8.7656
      expectRounded(@calc.w(8)).toEqual -10.9511
      expectRounded(@calc.w(9)).toEqual -13.23
      expectRounded(@calc.w(10)).toEqual -15.5556

  describe '#beam', ->
    it 'should return correct result', ->
      curves = @calc.beam()
      expect(_.keys(curves).sort()).toEqual ['h_outline', 'v_outline', 'h_grid', 'v_grid'].sort()

      # h_outline
      h_outline = curves.h_outline.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      expectRoundedArray(xCoords).toEqual [
        0.0000, 2.0132, 3.6080, 4.9139, 6.0773, 7.1706, 8.2269, 9.2617, 10.2828, 11.2943, 12.2979
        0.0000, -0.0132, 0.3920, 1.0861, 1.9227, 2.8294, 3.7731, 4.7383, 5.7172, 6.7057, 7.7021
      ]
      expectRoundedArray(yCoords).toEqual [
        2.5000, 2.0599, 1.0432, -0.2816, -1.8445, -3.6208, -5.5838, -7.7004, -9.9320, -12.2368, -14.5708
        -2.5000, -2.5110, -2.7854, -3.4984, -4.6266, -6.1015, -7.8562, -9.8307, -11.9702, -14.2232, -16.5404
      ]

      # h_grid
      h_grid = curves.h_grid.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      expectRoundedArray(xCoords).toEqual [
        0.0000, 1.8106, 3.2864, 4.5312, 5.6618, 6.7365, 7.7815, 8.8094, 9.8263, 10.8354, 11.8383
        0.0000, 1.6079, 2.9648, 4.1484, 5.2464, 6.3024, 7.3361, 8.3570, 9.3697, 10.3766, 11.3787
        0.0000, 1.4053, 2.6432, 3.7656, 4.8309, 5.8682, 6.8908, 7.9047, 8.9131, 9.9177, 10.9191
        0.0000, 1.2026, 2.3216, 3.3828, 4.4155, 5.4341, 6.4454, 7.4523, 8.4566, 9.4589, 10.4596
        0.0000, 1.0000, 2.0000, 3.0000, 4.0000, 5.0000, 6.0000, 7.0000, 8.0000, 9.0000, 10.0000
        0.0000, 0.7974, 1.6784, 2.6172, 3.5845, 4.5659, 5.5546, 6.5477, 7.5434, 8.5411, 9.5404
        0.0000, 0.5947, 1.3568, 2.2344, 3.1691, 4.1318, 5.1092, 6.0953, 7.0869, 8.0823, 9.0809
        0.0000, 0.3921, 1.0352, 1.8516, 2.7536, 3.6976, 4.6639, 5.6430, 6.6303, 7.6234, 8.6213
        0.0000, 0.1894, 0.7136, 1.4688, 2.3382, 3.2635, 4.2185, 5.1906, 6.1737, 7.1646, 8.1617
      ]
      expectRoundedArray(yCoords).toEqual [
        2.0000, 1.6028, 0.6603, -0.6033, -2.1227, -3.8688, -5.8111, -7.9134, -10.1358, -12.4355, -14.7677
        1.5000, 1.1457, 0.2774, -0.9250, -2.4009, -4.1169, -6.0383, -8.1264, -10.3396, -12.6341, -14.9647
        1.0000, 0.6886, -0.1054, -1.2467, -2.6791, -4.3650, -6.2655, -8.3395, -10.5435, -12.8327, -15.1616
        0.5000, 0.2315, -0.4883, -1.5683, -2.9574, -4.6130, -6.4928, -8.5525, -10.7473, -13.0314, -15.3586
        0.0000, -0.2256, -0.8711, -1.8900, -3.2356, -4.8611, -6.7200, -8.7656, -10.9511, -13.2300, -15.5556
        -0.5000, -0.6826, -1.2540, -2.2117, -3.5138, -5.1092, -6.9472, -8.9786, -11.1549, -13.4286, -15.7525
        -1.0000, -1.1397, -1.6368, -2.5333, -3.7920, -5.3573, -7.1745, -9.1916, -11.3588, -13.6273, -15.9495
        -1.5000, -1.5968, -2.0197, -2.8550, -4.0702, -5.6053, -7.4017, -9.4047, -11.5626, -13.8259, -16.1464
        -2.0000, -2.0539, -2.4025, -3.1767, -4.3484, -5.8534, -7.6289, -9.6177, -11.7664, -14.0245, -16.3434
      ]

      # v_grid
      expectRoundedArray(_.flatten(curves.v_grid.points)).toEqual [
        2.8294, -6.1015, 7.1706, -3.6208
      ]

      # v_outline
      expectRoundedArray(_.flatten(curves.v_outline.points)).toEqual [
        0.0000, -2.5000, 0.0000, 2.5000,
        7.7021, -16.5404, 12.2979, -14.5708
      ]

  describe '#slice', ->
    it 'should return correct result in non-continuous mode', ->
      curves = @calc.slice()
      expect(_.keys(curves).sort()).toEqual ['h_outline', 'v_outline', 'h_grid', 'v_grid'].sort()

      # h_outline
      h_outline = curves.h_outline.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      expectRoundedArray(xCoords).toEqual [
        -0.6684, 1.4399, 3.4316, 5.3066, 7.0649, 8.7066, 10.2316, 11.6399, 12.9316, 14.1066, 15.1649
        0.6684, 0.5601, 0.5684, 0.6934, 0.9351, 1.2934, 1.7684, 2.3601, 3.0684, 3.8934, 4.8351
      ]
      expectRoundedArray(yCoords).toEqual [
        2.0625, 1.8807, 1.2789, 0.3037, -0.9981, -2.5799, -4.3950, -6.3968, -8.5386, -10.7738, -13.0556
        -2.9375, -3.1193, -3.7211, -4.6963, -5.9981, -7.5799, -9.3950, -11.3968, -13.5386, -15.7738, -18.0556
      ]

      # h_grid
      h_grid = curves.h_grid.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      expectRoundedArray(xCoords).toEqual [
        -0.6152, 1.2714, 3.0648, 4.7648, 6.3714, 7.8848, 9.3048, 10.6314, 11.8648, 13.0048, 14.0514
        -0.5084, 1.1566, 2.7516, 4.2766, 5.7316, 7.1166, 8.4316, 9.6766, 10.8516, 11.9566, 12.9916
        -0.3613, 1.0821, 2.4787, 3.8287, 5.1321, 6.3887, 7.5987, 8.7621, 9.8787, 10.9487, 11.9721
        -0.1873, 1.0343, 2.2327, 3.4077, 4.5593, 5.6877, 6.7927, 7.8743, 8.9327, 9.9677, 10.9793
        0.0000, 1.0000, 2.0000, 3.0000, 4.0000, 5.0000, 6.0000, 7.0000, 8.0000, 9.0000, 10.0000
        0.1873, 0.9657, 1.7673, 2.5923, 3.4407, 4.3123, 5.2073, 6.1257, 7.0673, 8.0323, 9.0207
        0.3613, 0.9179, 1.5213, 2.1713, 2.8679, 3.6113, 4.4013, 5.2379, 6.1213, 7.0513, 8.0279
        0.5084, 0.8434, 1.2484, 1.7234, 2.2684, 2.8834, 3.5684, 4.3234, 5.1484, 6.0434, 7.0084
        0.6152, 0.7286, 0.9352, 1.2352, 1.6286, 2.1152, 2.6952, 3.3686, 4.1352, 4.9952, 5.9486
      ]
      expectRoundedArray(yCoords).toEqual [
        1.7200, 1.5224, 0.9049, -0.0860, -1.4036, -3.0011, -4.8320, -6.8496, -9.0071, -11.2580, -13.5556
        1.3425, 1.1327, 0.5029, -0.5003, -1.8301, -3.4399, -5.2830, -7.3128, -9.4826, -11.7458, -14.0556
        0.9300, 0.7114, 0.0729, -0.9390, -2.2776, -3.8961, -5.7480, -7.7866, -9.9651, -12.2370, -14.5556
        0.4825, 0.2587, -0.3851, -1.4023, -2.7461, -4.3699, -6.2270, -8.2708, -10.4546, -12.7318, -15.0556
        0.0000, -0.2256, -0.8711, -1.8900, -3.2356, -4.8611, -6.7200, -8.7656, -10.9511, -13.2300, -15.5556
        -0.5175, -0.7413, -1.3851, -2.4023, -3.7461, -5.3699, -7.2270, -9.2708, -11.4546, -13.7318, -16.0556
        -1.0700, -1.2886, -1.9271, -2.9390, -4.2776, -5.8961, -7.7480, -9.7866, -11.9651, -14.2370, -16.5556
        -1.6575, -1.8673, -2.4971, -3.5003, -4.8301, -6.4399, -8.2830, -10.3128, -12.4826, -14.7458, -17.0556
        -2.2800, -2.4776, -3.0951, -4.0860, -5.4036, -7.0011, -8.8320, -10.8496, -13.0071, -15.2580, -17.5556
      ]

      # v_grid
      v_grid = curves.v_grid.points
      xCoords = _.flatten ((curve[i] for i in [0..curve.length-1] by 2).reverse() for curve in v_grid)
      yCoords = _.flatten ((curve[i+1] for i in [0..curve.length-1] by 2).reverse() for curve in v_grid)
      expectRoundedArray(xCoords).toEqual [
        8.7066, 7.8848, 7.1166, 6.3887, 5.6877, 5.0000, 4.3123, 3.6113, 2.8834, 2.1152, 1.2934
      ]
      expectRoundedArray(yCoords).toEqual [
        -2.5799, -3.0011, -3.4399, -3.8961, -4.3699, -4.8611, -5.3699, -5.8961, -6.4399, -7.0011, -7.5799
      ]

      # v_outline
      v_outline = curves.v_outline.points
      xCoords = _.flatten ((curve[i] for i in [0..curve.length-1] by 2).reverse() for curve in v_outline)
      yCoords = _.flatten ((curve[i+1] for i in [0..curve.length-1] by 2).reverse() for curve in v_outline)
      expectRoundedArray(xCoords).toEqual [
        -0.6684, -0.6152, -0.5084, -0.3613, -0.1873, 0.0000, 0.1873, 0.3613, 0.5084, 0.6152, 0.6684,
        15.1649, 14.0514, 12.9916, 11.9721, 10.9793, 10.0000, 9.0207, 8.0279, 7.0084, 5.9486, 4.8351
      ]
      expectRoundedArray(yCoords).toEqual [
        2.0625, 1.7200, 1.3425, 0.9300, 0.4825, 0.0000, -0.5175, -1.0700, -1.6575, -2.2800, -2.9375,
        -13.0556, -13.5556, -14.0556, -14.5556, -15.0556, -15.5556, -16.0556, -16.5556, -17.0556, -17.5556, -18.0556
      ]

    it 'should return correct result in continuous mode', ->
      @thinWalledCantilever.set('continuous', 'yes')
      curves = @calc.slice()
      expect(_.keys(curves).sort()).toEqual ['h_outline', 'v_outline', 'h_grid', 'v_grid'].sort()

      # h_outline
      h_outline = curves.h_outline.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_outline).reverse()
      expectRoundedArray(xCoords).toEqual [
        0.0000, 2.1083, 4.1000, 5.9750, 7.7333, 9.3750, 10.9000, 12.3083, 13.6000, 14.7750, 15.8333
        0.0000, -0.1083, -0.1000, 0.0250, 0.2667, 0.6250, 1.1000, 1.6917, 2.4000, 3.2250, 4.1667
      ]
      expectRoundedArray(yCoords).toEqual [
        2.5000, 2.3007, 1.6814, 0.6888, -0.6306, -2.2299, -4.0625, -6.0818, -8.2411, -10.4937, -12.7931
        -2.5000, -2.6643, -3.2486, -4.2063, -5.4906, -7.0549, -8.8525, -10.8368, -12.9611, -15.1788, -17.4431
      ]

      # h_grid
      h_grid = curves.h_grid.points
      xCoords = _.flatten (curve[i] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      yCoords = _.flatten (curve[i+1] for i in [0..curve.length-1] by 2 for curve in h_grid).reverse()
      expectRoundedArray(xCoords).toEqual [
        0.0000, 1.8867, 3.6800, 5.3800, 6.9867, 8.5000, 9.9200, 11.2467, 12.4800, 13.6200, 14.6667
        0.0000, 1.6650, 3.2600, 4.7850, 6.2400, 7.6250, 8.9400, 10.1850, 11.3600, 12.4650, 13.5000
        0.0000, 1.4433, 2.8400, 4.1900, 5.4933, 6.7500, 7.9600, 9.1233, 10.2400, 11.3100, 12.3333
        0.0000, 1.2217, 2.4200, 3.5950, 4.7467, 5.8750, 6.9800, 8.0617, 9.1200, 10.1550, 11.1667
        0.0000, 1.0000, 2.0000, 3.0000, 4.0000, 5.0000, 6.0000, 7.0000, 8.0000, 9.0000, 10.0000
        0.0000, 0.7783, 1.5800, 2.4050, 3.2533, 4.1250, 5.0200, 5.9383, 6.8800, 7.8450, 8.8333
        0.0000, 0.5567, 1.1600, 1.8100, 2.5067, 3.2500, 4.0400, 4.8767, 5.7600, 6.6900, 7.6667
        0.0000, 0.3350, 0.7400, 1.2150, 1.7600, 2.3750, 3.0600, 3.8150, 4.6400, 5.5350, 6.5000
        0.0000, 0.1133, 0.3200, 0.6200, 1.0133, 1.5000, 2.0800, 2.7533, 3.5200, 4.3800, 5.3333
      ]
      expectRoundedArray(yCoords).toEqual [
        2.0000, 1.7884, 1.1569, 0.1520, -1.1796, -2.7911, -4.6360, -6.6676, -8.8391, -11.1040, -13.4156
        1.5000, 1.2797, 0.6394, -0.3742, -1.7146, -3.3349, -5.1885, -7.2288, -9.4091, -11.6828, -14.0031
        1.0000, 0.7744, 0.1289, -0.8900, -2.2356, -3.8611, -5.7200, -7.7656, -9.9511, -12.2300, -14.5556
        0.5000, 0.2727, -0.3746, -1.3953, -2.7426, -4.3699, -6.2305, -8.2778, -10.4651, -12.7457, -15.0731
        0.0000, -0.2256, -0.8711, -1.8900, -3.2356, -4.8611, -6.7200, -8.7656, -10.9511, -13.2300, -15.5556
        -0.5000, -0.7203, -1.3606, -2.3743, -3.7146, -5.3349, -7.1885, -9.2288, -11.4091, -13.6828, -16.0031
        -1.0000, -1.2116, -1.8431, -2.8480, -4.1796, -5.7911, -7.6360, -9.6676, -11.8391, -14.1040, -16.4156
        -1.5000, -1.6993, -2.3186, -3.3113, -4.6306, -6.2299, -8.0625, -10.0818, -12.2411, -14.4938, -16.7931
        -2.0000, -2.1836, -2.7871, -3.7640, -5.0676, -6.6511, -8.4680, -10.4716, -12.6151, -14.8520, -17.1356
      ]

      # v_grid
      v_grid = curves.v_grid.points
      xCoords = _.flatten ((curve[i] for i in [0..curve.length-1] by 2).reverse() for curve in v_grid)
      yCoords = _.flatten ((curve[i+1] for i in [0..curve.length-1] by 2).reverse() for curve in v_grid)
      expectRoundedArray(xCoords).toEqual [
        9.3750, 8.5000, 7.6250, 6.7500, 5.8750, 5.0000, 4.1250, 3.2500, 2.3750, 1.5000, 0.6250
      ]
      expectRoundedArray(yCoords).toEqual [
        -2.2299, -2.7911, -3.3349, -3.8611, -4.3699, -4.8611, -5.3349, -5.7911, -6.2299, -6.6511, -7.0549
      ]

      # v_outline
      v_outline = curves.v_outline.points
      xCoords = _.flatten ((curve[i] for i in [0..curve.length-1] by 2).reverse() for curve in v_outline)
      yCoords = _.flatten ((curve[i+1] for i in [0..curve.length-1] by 2).reverse() for curve in v_outline)
      expectRoundedArray(xCoords).toEqual [
        0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000
        15.8333, 14.6667, 13.5000, 12.3333, 11.1667, 10.0000, 8.8333, 7.6667, 6.5000, 5.3333, 4.1667
      ]
      expectRoundedArray(yCoords).toEqual [
        2.5000, 2.0000, 1.5000, 1.0000, 0.5000, 0.0000, -0.5000, -1.0000, -1.5000, -2.0000, -2.5000
        -12.7931, -13.4156, -14.0031, -14.5556, -15.0731, -15.5556, -16.0031, -16.4156, -16.7931, -17.1356, -17.4431
      ]
