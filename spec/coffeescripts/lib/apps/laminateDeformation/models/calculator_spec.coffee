describe 'ILR.LaminateDeformation.Models.Calculator', ->
  beforeAll ->
    ILR.settings.laminateDeformation.laminates =
      1:
        membraneStiffness: [[68000, 12400, 6500], [12400, 38500, 19100], [6500, 19100, 13100]]
        cupplingStiffness: [[13800, -2800, -1600], [-2800, -8400, -4800], [-1600, -4800, -2800]]
        bendingStiffness: [[5700, 1000, 500], [1000, 3200, 1600], [500, 1600, 1100]]

  beforeEach ->
    @model = new Backbone.Model
      laminate: 1
      length: 200
      aspectRatio: 2
      width: 100
      xLoad: 100
      yLoad: 50
      shearLoad: 25
      xMoment: 75
      yMoment: 33
      shearMoment: 12
      xyPsf: 1
      zPsf: 1
    @model.name = 'laminateDeformation'

    @calc = new ILR.LaminateDeformation.Models.Calculator
      model: @model

  describe 'model parameter', ->
    describe '#length', ->
      it 'should return the correct value', ->
        expect(@calc.length()).toEqual(200)

    describe '#aspectRatio', ->
      it 'should return the correct value', ->
        expect(@calc.aspectRatio()).toEqual(2)

    describe '#width', ->
      it 'should return the correct value', ->
        expect(@calc.width()).toEqual(100)

    describe '#xLoad', ->
      it 'should return the correct value', ->
        expect(@calc.xLoad()).toEqual(100)

    describe '#yLoad', ->
      it 'should return the correct value', ->
        expect(@calc.yLoad()).toEqual(50)

    describe '#shearLoad', ->
      it 'should return the correct value', ->
        expect(@calc.shearLoad()).toEqual(25)

    describe '#xMoment', ->
      it 'should return the correct value', ->
        expect(@calc.xMoment()).toEqual(75)

    describe '#yMoment', ->
      it 'should return the correct value', ->
        expect(@calc.yMoment()).toEqual(33)

    describe '#shearMoment', ->
      it 'should return the correct value', ->
        expect(@calc.shearMoment()).toEqual(12)

    describe '#membraneStiffness', ->
      it 'should return the correct value', ->
        expect(@calc.membraneStiffness()).toEqual([[68000, 12400, 6500], [12400, 38500, 19100], [6500, 19100, 13100]])

    describe '#cupplingStiffness', ->
      it 'should return the correct value', ->
        expect(@calc.cupplingStiffness()).toEqual([[13800, -2800, -1600], [-2800, -8400, -4800], [-1600, -4800, -2800]])

    describe '#bendingStiffness', ->
      it 'should return the correct value', ->
        expect(@calc.bendingStiffness()).toEqual([[5700, 1000, 500], [1000, 3200, 1600], [500, 1600, 1100]])

  describe '#abd', ->
    it 'should return the correct ABD matrix', ->
      expect(@calc.abd()).toEqual([[68000, 12400, 6500, 13800, -2800, -1600], [12400, 38500, 19100, -2800, -8400, -4800], [6500, 19100, 13100, -1600, -4800, -2800], [13800, -2800, -1600, 5700, 1000, 500], [-2800, -8400, -4800, 1000, 3200, 1600], [-1600, -4800, -2800, 500, 1600, 1100]])

  describe '#eps_kappa', ->
    it 'should return the correct vector', ->
      expectRoundedArray(@calc.eps_kappa()).toEqual([-0.0041, 0.0072, 0.0070, 0.0235, 0.0259, 0.0062])

  describe '#laminate', ->
    it 'should return the correct matrices', ->
      [q1, q2, q3, q4] = @calc.laminate()

      # 1st quadrant X
      expectRoundedArray(_.map(q1, (row) -> _.map(row, _.first))).toEqual [
        [0.0000, 0.0004, 0.0007, 0.0011, 0.0014, 0.0018, 0.0021, 0.0025, 0.0028, 0.0032, 0.0035]
        [0.0996, 0.0999, 0.1003, 0.1006, 0.1010, 0.1014, 0.1017, 0.1021, 0.1024, 0.1028, 0.1031]
        [0.1992, 0.1995, 0.1999, 0.2002, 0.2006, 0.2009, 0.2013, 0.2017, 0.2020, 0.2024, 0.2027]
        [0.2988, 0.2991, 0.2995, 0.2998, 0.3002, 0.3005, 0.3009, 0.3012, 0.3016, 0.3019, 0.3023]
        [0.3984, 0.3987, 0.3991, 0.3994, 0.3998, 0.4001, 0.4005, 0.4008, 0.4012, 0.4015, 0.4019]
        [0.4980, 0.4983, 0.4987, 0.4990, 0.4994, 0.4997, 0.5001, 0.5004, 0.5008, 0.5011, 0.5015]
        [0.5976, 0.5979, 0.5983, 0.5986, 0.5990, 0.5993, 0.5997, 0.6000, 0.6004, 0.6007, 0.6011]
        [0.6971, 0.6975, 0.6979, 0.6982, 0.6986, 0.6989, 0.6993, 0.6996, 0.7000, 0.7003, 0.7007]
        [0.7967, 0.7971, 0.7974, 0.7978, 0.7981, 0.7985, 0.7989, 0.7992, 0.7996, 0.7999, 0.8003]
        [0.8963, 0.8967, 0.8970, 0.8974, 0.8977, 0.8981, 0.8984, 0.8988, 0.8992, 0.8995, 0.8999]
        [0.9959, 0.9963, 0.9966, 0.9970, 0.9973, 0.9977, 0.9980, 0.9984, 0.9987, 0.9991, 0.9994]
        [1.0955, 1.0959, 1.0962, 1.0966, 1.0969, 1.0973, 1.0976, 1.0980, 1.0983, 1.0987, 1.0990]
        [1.1951, 1.1955, 1.1958, 1.1962, 1.1965, 1.1969, 1.1972, 1.1976, 1.1979, 1.1983, 1.1986]
        [1.2947, 1.2951, 1.2954, 1.2958, 1.2961, 1.2965, 1.2968, 1.2972, 1.2975, 1.2979, 1.2982]
        [1.3943, 1.3946, 1.3950, 1.3953, 1.3957, 1.3961, 1.3964, 1.3968, 1.3971, 1.3975, 1.3978]
        [1.4939, 1.4942, 1.4946, 1.4949, 1.4953, 1.4956, 1.4960, 1.4964, 1.4967, 1.4971, 1.4974]
        [1.5935, 1.5938, 1.5942, 1.5945, 1.5949, 1.5952, 1.5956, 1.5959, 1.5963, 1.5966, 1.5970]
        [1.6931, 1.6934, 1.6938, 1.6941, 1.6945, 1.6948, 1.6952, 1.6955, 1.6959, 1.6962, 1.6966]
        [1.7927, 1.7930, 1.7934, 1.7937, 1.7941, 1.7944, 1.7948, 1.7951, 1.7955, 1.7958, 1.7962]
        [1.8923, 1.8926, 1.8930, 1.8933, 1.8937, 1.8940, 1.8944, 1.8947, 1.8951, 1.8954, 1.8958]
        [1.9918, 1.9922, 1.9926, 1.9929, 1.9933, 1.9936, 1.9940, 1.9943, 1.9947, 1.9950, 1.9954]
      ]

      # 1st quadrant Y
      expectRoundedArray(_.map(q1, (row) -> _.map(row, (el) -> el[1]))).toEqual [
        [0.0000, 0.1007, 0.2014, 0.3022, 0.4029, 0.5036, 0.6043, 0.7051, 0.8058, 0.9065, 1.0072]
        [0.0004, 0.1011, 0.2018, 0.3025, 0.4033, 0.5040, 0.6047, 0.7054, 0.8061, 0.9069, 1.0076]
        [0.0007, 0.1014, 0.2022, 0.3029, 0.4036, 0.5043, 0.6051, 0.7058, 0.8065, 0.9072, 1.0080]
        [0.0011, 0.1018, 0.2025, 0.3032, 0.4040, 0.5047, 0.6054, 0.7061, 0.8069, 0.9076, 1.0083]
        [0.0014, 0.1021, 0.2029, 0.3036, 0.4043, 0.5050, 0.6058, 0.7065, 0.8072, 0.9079, 1.0087]
        [0.0018, 0.1025, 0.2032, 0.3039, 0.4047, 0.5054, 0.6061, 0.7068, 0.8076, 0.9083, 1.0090]
        [0.0021, 0.1028, 0.2036, 0.3043, 0.4050, 0.5057, 0.6065, 0.7072, 0.8079, 0.9086, 1.0094]
        [0.0025, 0.1032, 0.2039, 0.3046, 0.4054, 0.5061, 0.6068, 0.7075, 0.8083, 0.9090, 1.0097]
        [0.0028, 0.1035, 0.2043, 0.3050, 0.4057, 0.5064, 0.6072, 0.7079, 0.8086, 0.9093, 1.0101]
        [0.0032, 0.1039, 0.2046, 0.3053, 0.4061, 0.5068, 0.6075, 0.7082, 0.8090, 0.9097, 1.0104]
        [0.0035, 0.1042, 0.2050, 0.3057, 0.4064, 0.5071, 0.6079, 0.7086, 0.8093, 0.9100, 1.0108]
        [0.0039, 0.1046, 0.2053, 0.3061, 0.4068, 0.5075, 0.6082, 0.7089, 0.8097, 0.9104, 1.0111]
        [0.0042, 0.1050, 0.2057, 0.3064, 0.4071, 0.5079, 0.6086, 0.7093, 0.8100, 0.9108, 1.0115]
        [0.0046, 0.1053, 0.2060, 0.3068, 0.4075, 0.5082, 0.6089, 0.7097, 0.8104, 0.9111, 1.0118]
        [0.0049, 0.1057, 0.2064, 0.3071, 0.4078, 0.5086, 0.6093, 0.7100, 0.8107, 0.9115, 1.0122]
        [0.0053, 0.1060, 0.2067, 0.3075, 0.4082, 0.5089, 0.6096, 0.7104, 0.8111, 0.9118, 1.0125]
        [0.0056, 0.1064, 0.2071, 0.3078, 0.4085, 0.5093, 0.6100, 0.7107, 0.8114, 0.9122, 1.0129]
        [0.0060, 0.1067, 0.2074, 0.3082, 0.4089, 0.5096, 0.6103, 0.7111, 0.8118, 0.9125, 1.0132]
        [0.0063, 0.1071, 0.2078, 0.3085, 0.4092, 0.5100, 0.6107, 0.7114, 0.8121, 0.9129, 1.0136]
        [0.0067, 0.1074, 0.2081, 0.3089, 0.4096, 0.5103, 0.6110, 0.7118, 0.8125, 0.9132, 1.0139]
        [0.0070, 0.1078, 0.2085, 0.3092, 0.4099, 0.5107, 0.6114, 0.7121, 0.8128, 0.9136, 1.0143]
      ]

      # 1st quadrant Z
      expectRoundedArray(_.map(q1, (row) -> _.map(row, (el) -> el[2]))).toEqual [
        [0.0000, 0.0001, 0.0005, 0.0012, 0.0021, 0.0032, 0.0047, 0.0063, 0.0083, 0.0105, 0.0130]
        [0.0001, 0.0003, 0.0008, 0.0015, 0.0024, 0.0037, 0.0052, 0.0069, 0.0089, 0.0112, 0.0137]
        [0.0005, 0.0007, 0.0012, 0.0020, 0.0030, 0.0043, 0.0059, 0.0077, 0.0098, 0.0121, 0.0147]
        [0.0011, 0.0014, 0.0019, 0.0028, 0.0039, 0.0052, 0.0068, 0.0087, 0.0108, 0.0132, 0.0159]
        [0.0019, 0.0023, 0.0029, 0.0038, 0.0049, 0.0064, 0.0080, 0.0100, 0.0121, 0.0146, 0.0173]
        [0.0029, 0.0034, 0.0041, 0.0050, 0.0062, 0.0077, 0.0095, 0.0114, 0.0137, 0.0162, 0.0190]
        [0.0042, 0.0047, 0.0055, 0.0065, 0.0078, 0.0093, 0.0111, 0.0132, 0.0155, 0.0181, 0.0209]
        [0.0058, 0.0063, 0.0071, 0.0082, 0.0096, 0.0112, 0.0130, 0.0151, 0.0175, 0.0201, 0.0230]
        [0.0075, 0.0081, 0.0090, 0.0102, 0.0116, 0.0132, 0.0151, 0.0173, 0.0198, 0.0225, 0.0254]
        [0.0095, 0.0102, 0.0111, 0.0123, 0.0138, 0.0155, 0.0175, 0.0197, 0.0222, 0.0250, 0.0280]
        [0.0117, 0.0125, 0.0135, 0.0148, 0.0163, 0.0181, 0.0201, 0.0224, 0.0250, 0.0278, 0.0309]
        [0.0142, 0.0150, 0.0161, 0.0174, 0.0190, 0.0208, 0.0229, 0.0253, 0.0279, 0.0308, 0.0340]
        [0.0169, 0.0178, 0.0189, 0.0203, 0.0219, 0.0238, 0.0260, 0.0284, 0.0311, 0.0341, 0.0373]
        [0.0198, 0.0208, 0.0220, 0.0234, 0.0251, 0.0271, 0.0293, 0.0318, 0.0346, 0.0376, 0.0408]
        [0.0230, 0.0240, 0.0253, 0.0268, 0.0285, 0.0306, 0.0329, 0.0354, 0.0382, 0.0413, 0.0446]
        [0.0264, 0.0275, 0.0288, 0.0304, 0.0322, 0.0343, 0.0366, 0.0392, 0.0421, 0.0452, 0.0486]
        [0.0301, 0.0312, 0.0325, 0.0342, 0.0361, 0.0382, 0.0406, 0.0433, 0.0462, 0.0494, 0.0529]
        [0.0339, 0.0351, 0.0365, 0.0382, 0.0402, 0.0424, 0.0449, 0.0476, 0.0506, 0.0539, 0.0574]
        [0.0380, 0.0393, 0.0408, 0.0425, 0.0446, 0.0468, 0.0494, 0.0522, 0.0552, 0.0585, 0.0621]
        [0.0424, 0.0437, 0.0452, 0.0471, 0.0491, 0.0515, 0.0541, 0.0569, 0.0601, 0.0634, 0.0671]
        [0.0470, 0.0483, 0.0499, 0.0518, 0.0540, 0.0564, 0.0590, 0.0620, 0.0651, 0.0686, 0.0723]
      ]

      # 2nd quadrant X
      expectRoundedArray(_.map(q2, (row) -> _.map(row, _.first))).toEqual [
        [0.0000, 0.0004, 0.0007, 0.0011, 0.0014, 0.0018, 0.0021, 0.0025, 0.0028, 0.0032, 0.0035]
        [-0.0996, -0.0992, -0.0989, -0.0985, -0.0982, -0.0978, -0.0975, -0.0971, -0.0968, -0.0964, -0.0961]
        [-0.1992, -0.1988, -0.1985, -0.1981, -0.1978, -0.1974, -0.1971, -0.1967, -0.1964, -0.1960, -0.1957]
        [-0.2988, -0.2984, -0.2981, -0.2977, -0.2974, -0.2970, -0.2967, -0.2963, -0.2960, -0.2956, -0.2953]
        [-0.3984, -0.3980, -0.3977, -0.3973, -0.3970, -0.3966, -0.3963, -0.3959, -0.3955, -0.3952, -0.3948]
        [-0.4980, -0.4976, -0.4973, -0.4969, -0.4966, -0.4962, -0.4958, -0.4955, -0.4951, -0.4948, -0.4944]
        [-0.5976, -0.5972, -0.5968, -0.5965, -0.5961, -0.5958, -0.5954, -0.5951, -0.5947, -0.5944, -0.5940]
        [-0.6971, -0.6968, -0.6964, -0.6961, -0.6957, -0.6954, -0.6950, -0.6947, -0.6943, -0.6940, -0.6936]
        [-0.7967, -0.7964, -0.7960, -0.7957, -0.7953, -0.7950, -0.7946, -0.7943, -0.7939, -0.7936, -0.7932]
        [-0.8963, -0.8960, -0.8956, -0.8953, -0.8949, -0.8946, -0.8942, -0.8939, -0.8935, -0.8932, -0.8928]
        [-0.9959, -0.9956, -0.9952, -0.9949, -0.9945, -0.9942, -0.9938, -0.9935, -0.9931, -0.9928, -0.9924]
        [-1.0955, -1.0952, -1.0948, -1.0945, -1.0941, -1.0938, -1.0934, -1.0930, -1.0927, -1.0923, -1.0920]
        [-1.1951, -1.1948, -1.1944, -1.1941, -1.1937, -1.1933, -1.1930, -1.1926, -1.1923, -1.1919, -1.1916]
        [-1.2947, -1.2943, -1.2940, -1.2936, -1.2933, -1.2929, -1.2926, -1.2922, -1.2919, -1.2915, -1.2912]
        [-1.3943, -1.3939, -1.3936, -1.3932, -1.3929, -1.3925, -1.3922, -1.3918, -1.3915, -1.3911, -1.3908]
        [-1.4939, -1.4935, -1.4932, -1.4928, -1.4925, -1.4921, -1.4918, -1.4914, -1.4911, -1.4907, -1.4904]
        [-1.5935, -1.5931, -1.5928, -1.5924, -1.5921, -1.5917, -1.5914, -1.5910, -1.5907, -1.5903, -1.5900]
        [-1.6931, -1.6927, -1.6924, -1.6920, -1.6917, -1.6913, -1.6910, -1.6906, -1.6902, -1.6899, -1.6895]
        [-1.7927, -1.7923, -1.7920, -1.7916, -1.7913, -1.7909, -1.7905, -1.7902, -1.7898, -1.7895, -1.7891]
        [-1.8923, -1.8919, -1.8915, -1.8912, -1.8908, -1.8905, -1.8901, -1.8898, -1.8894, -1.8891, -1.8887]
        [-1.9918, -1.9915, -1.9911, -1.9908, -1.9904, -1.9901, -1.9897, -1.9894, -1.9890, -1.9887, -1.9883]
      ]

      # 2nd quadrant Y
      expectRoundedArray(_.map(q2, (row) -> _.map(row, (el) -> el[1]))).toEqual [
        [0.0000, 0.1007, 0.2014, 0.3022, 0.4029, 0.5036, 0.6043, 0.7051, 0.8058, 0.9065, 1.0072]
        [-0.0004, 0.1004, 0.2011, 0.3018, 0.4025, 0.5033, 0.6040, 0.7047, 0.8054, 0.9062, 1.0069]
        [-0.0007, 0.1000, 0.2007, 0.3015, 0.4022, 0.5029, 0.6036, 0.7044, 0.8051, 0.9058, 1.0065]
        [-0.0011, 0.0997, 0.2004, 0.3011, 0.4018, 0.5026, 0.6033, 0.7040, 0.8047, 0.9055, 1.0062]
        [-0.0014, 0.0993, 0.2000, 0.3008, 0.4015, 0.5022, 0.6029, 0.7037, 0.8044, 0.9051, 1.0058]
        [-0.0018, 0.0990, 0.1997, 0.3004, 0.4011, 0.5019, 0.6026, 0.7033, 0.8040, 0.9048, 1.0055]
        [-0.0021, 0.0986, 0.1993, 0.3001, 0.4008, 0.5015, 0.6022, 0.7030, 0.8037, 0.9044, 1.0051]
        [-0.0025, 0.0983, 0.1990, 0.2997, 0.4004, 0.5012, 0.6019, 0.7026, 0.8033, 0.9041, 1.0048]
        [-0.0028, 0.0979, 0.1986, 0.2994, 0.4001, 0.5008, 0.6015, 0.7023, 0.8030, 0.9037, 1.0044]
        [-0.0032, 0.0976, 0.1983, 0.2990, 0.3997, 0.5005, 0.6012, 0.7019, 0.8026, 0.9033, 1.0041]
        [-0.0035, 0.0972, 0.1979, 0.2986, 0.3994, 0.5001, 0.6008, 0.7015, 0.8023, 0.9030, 1.0037]
        [-0.0039, 0.0968, 0.1976, 0.2983, 0.3990, 0.4997, 0.6005, 0.7012, 0.8019, 0.9026, 1.0034]
        [-0.0042, 0.0965, 0.1972, 0.2979, 0.3987, 0.4994, 0.6001, 0.7008, 0.8016, 0.9023, 1.0030]
        [-0.0046, 0.0961, 0.1969, 0.2976, 0.3983, 0.4990, 0.5998, 0.7005, 0.8012, 0.9019, 1.0027]
        [-0.0049, 0.0958, 0.1965, 0.2972, 0.3980, 0.4987, 0.5994, 0.7001, 0.8009, 0.9016, 1.0023]
        [-0.0053, 0.0954, 0.1962, 0.2969, 0.3976, 0.4983, 0.5991, 0.6998, 0.8005, 0.9012, 1.0020]
        [-0.0056, 0.0951, 0.1958, 0.2965, 0.3973, 0.4980, 0.5987, 0.6994, 0.8002, 0.9009, 1.0016]
        [-0.0060, 0.0947, 0.1955, 0.2962, 0.3969, 0.4976, 0.5984, 0.6991, 0.7998, 0.9005, 1.0013]
        [-0.0063, 0.0944, 0.1951, 0.2958, 0.3966, 0.4973, 0.5980, 0.6987, 0.7995, 0.9002, 1.0009]
        [-0.0067, 0.0940, 0.1948, 0.2955, 0.3962, 0.4969, 0.5977, 0.6984, 0.7991, 0.8998, 1.0005]
        [-0.0070, 0.0937, 0.1944, 0.2951, 0.3958, 0.4966, 0.5973, 0.6980, 0.7987, 0.8995, 1.0002]
      ]

      # 2nd quadrant Z
      expectRoundedArray(_.map(q2, (row) -> _.map(row, (el) -> el[2]))).toEqual [
        [0.0000, 0.0001, 0.0005, 0.0012, 0.0021, 0.0032, 0.0047, 0.0063, 0.0083, 0.0105, 0.0130]
        [0.0001, 0.0002, 0.0005, 0.0011, 0.0019, 0.0030, 0.0044, 0.0060, 0.0079, 0.0101, 0.0125]
        [0.0005, 0.0005, 0.0007, 0.0013, 0.0020, 0.0031, 0.0044, 0.0060, 0.0078, 0.0099, 0.0122]
        [0.0011, 0.0010, 0.0012, 0.0017, 0.0024, 0.0034, 0.0046, 0.0061, 0.0079, 0.0099, 0.0122]
        [0.0019, 0.0018, 0.0019, 0.0023, 0.0030, 0.0039, 0.0051, 0.0065, 0.0082, 0.0102, 0.0124]
        [0.0029, 0.0028, 0.0028, 0.0032, 0.0038, 0.0046, 0.0057, 0.0071, 0.0088, 0.0107, 0.0128]
        [0.0042, 0.0040, 0.0040, 0.0043, 0.0048, 0.0056, 0.0067, 0.0080, 0.0096, 0.0114, 0.0135]
        [0.0058, 0.0054, 0.0054, 0.0056, 0.0061, 0.0068, 0.0078, 0.0091, 0.0106, 0.0124, 0.0144]
        [0.0075, 0.0071, 0.0070, 0.0072, 0.0076, 0.0083, 0.0092, 0.0104, 0.0119, 0.0136, 0.0155]
        [0.0095, 0.0091, 0.0089, 0.0090, 0.0094, 0.0100, 0.0108, 0.0120, 0.0134, 0.0150, 0.0169]
        [0.0117, 0.0113, 0.0110, 0.0111, 0.0113, 0.0119, 0.0127, 0.0138, 0.0151, 0.0167, 0.0185]
        [0.0142, 0.0137, 0.0134, 0.0133, 0.0136, 0.0140, 0.0148, 0.0158, 0.0171, 0.0186, 0.0204]
        [0.0169, 0.0163, 0.0159, 0.0158, 0.0160, 0.0164, 0.0171, 0.0181, 0.0193, 0.0207, 0.0225]
        [0.0198, 0.0192, 0.0188, 0.0186, 0.0187, 0.0191, 0.0197, 0.0206, 0.0217, 0.0231, 0.0248]
        [0.0230, 0.0223, 0.0218, 0.0216, 0.0216, 0.0219, 0.0225, 0.0233, 0.0244, 0.0257, 0.0273]
        [0.0264, 0.0256, 0.0251, 0.0248, 0.0248, 0.0250, 0.0255, 0.0263, 0.0273, 0.0286, 0.0301]
        [0.0301, 0.0292, 0.0286, 0.0283, 0.0282, 0.0284, 0.0288, 0.0295, 0.0304, 0.0317, 0.0331]
        [0.0339, 0.0330, 0.0323, 0.0319, 0.0318, 0.0319, 0.0323, 0.0329, 0.0338, 0.0350, 0.0364]
        [0.0380, 0.0371, 0.0363, 0.0359, 0.0357, 0.0357, 0.0360, 0.0366, 0.0374, 0.0385, 0.0399]
        [0.0424, 0.0413, 0.0406, 0.0400, 0.0398, 0.0398, 0.0400, 0.0405, 0.0413, 0.0423, 0.0436]
        [0.0470, 0.0459, 0.0450, 0.0444, 0.0441, 0.0440, 0.0442, 0.0447, 0.0454, 0.0463, 0.0476]
      ]

      # 3rd quadrant X
      expectRoundedArray(_.map(q3, (row) -> _.map(row, _.first))).toEqual [
        [0.0000, -0.0004, -0.0007, -0.0011, -0.0014, -0.0018, -0.0021, -0.0025, -0.0028, -0.0032, -0.0035]
        [-0.0996, -0.0999, -0.1003, -0.1006, -0.1010, -0.1014, -0.1017, -0.1021, -0.1024, -0.1028, -0.1031]
        [-0.1992, -0.1995, -0.1999, -0.2002, -0.2006, -0.2009, -0.2013, -0.2017, -0.2020, -0.2024, -0.2027]
        [-0.2988, -0.2991, -0.2995, -0.2998, -0.3002, -0.3005, -0.3009, -0.3012, -0.3016, -0.3019, -0.3023]
        [-0.3984, -0.3987, -0.3991, -0.3994, -0.3998, -0.4001, -0.4005, -0.4008, -0.4012, -0.4015, -0.4019]
        [-0.4980, -0.4983, -0.4987, -0.4990, -0.4994, -0.4997, -0.5001, -0.5004, -0.5008, -0.5011, -0.5015]
        [-0.5976, -0.5979, -0.5983, -0.5986, -0.5990, -0.5993, -0.5997, -0.6000, -0.6004, -0.6007, -0.6011]
        [-0.6971, -0.6975, -0.6979, -0.6982, -0.6986, -0.6989, -0.6993, -0.6996, -0.7000, -0.7003, -0.7007]
        [-0.7967, -0.7971, -0.7974, -0.7978, -0.7981, -0.7985, -0.7989, -0.7992, -0.7996, -0.7999, -0.8003]
        [-0.8963, -0.8967, -0.8970, -0.8974, -0.8977, -0.8981, -0.8984, -0.8988, -0.8992, -0.8995, -0.8999]
        [-0.9959, -0.9963, -0.9966, -0.9970, -0.9973, -0.9977, -0.9980, -0.9984, -0.9987, -0.9991, -0.9994]
        [-1.0955, -1.0959, -1.0962, -1.0966, -1.0969, -1.0973, -1.0976, -1.0980, -1.0983, -1.0987, -1.0990]
        [-1.1951, -1.1955, -1.1958, -1.1962, -1.1965, -1.1969, -1.1972, -1.1976, -1.1979, -1.1983, -1.1986]
        [-1.2947, -1.2951, -1.2954, -1.2958, -1.2961, -1.2965, -1.2968, -1.2972, -1.2975, -1.2979, -1.2982]
        [-1.3943, -1.3946, -1.3950, -1.3953, -1.3957, -1.3961, -1.3964, -1.3968, -1.3971, -1.3975, -1.3978]
        [-1.4939, -1.4942, -1.4946, -1.4949, -1.4953, -1.4956, -1.4960, -1.4964, -1.4967, -1.4971, -1.4974]
        [-1.5935, -1.5938, -1.5942, -1.5945, -1.5949, -1.5952, -1.5956, -1.5959, -1.5963, -1.5966, -1.5970]
        [-1.6931, -1.6934, -1.6938, -1.6941, -1.6945, -1.6948, -1.6952, -1.6955, -1.6959, -1.6962, -1.6966]
        [-1.7927, -1.7930, -1.7934, -1.7937, -1.7941, -1.7944, -1.7948, -1.7951, -1.7955, -1.7958, -1.7962]
        [-1.8923, -1.8926, -1.8930, -1.8933, -1.8937, -1.8940, -1.8944, -1.8947, -1.8951, -1.8954, -1.8958]
        [-1.9918, -1.9922, -1.9926, -1.9929, -1.9933, -1.9936, -1.9940, -1.9943, -1.9947, -1.9950, -1.9954]
      ]

      # 3rd quadrant Y
      expectRoundedArray(_.map(q3, (row) -> _.map(row, (el) -> el[1]))).toEqual [
        [0.0000, -0.1007, -0.2014, -0.3022, -0.4029, -0.5036, -0.6043, -0.7051, -0.8058, -0.9065, -1.0072]
        [-0.0004, -0.1011, -0.2018, -0.3025, -0.4033, -0.5040, -0.6047, -0.7054, -0.8061, -0.9069, -1.0076]
        [-0.0007, -0.1014, -0.2022, -0.3029, -0.4036, -0.5043, -0.6051, -0.7058, -0.8065, -0.9072, -1.0080]
        [-0.0011, -0.1018, -0.2025, -0.3032, -0.4040, -0.5047, -0.6054, -0.7061, -0.8069, -0.9076, -1.0083]
        [-0.0014, -0.1021, -0.2029, -0.3036, -0.4043, -0.5050, -0.6058, -0.7065, -0.8072, -0.9079, -1.0087]
        [-0.0018, -0.1025, -0.2032, -0.3039, -0.4047, -0.5054, -0.6061, -0.7068, -0.8076, -0.9083, -1.0090]
        [-0.0021, -0.1028, -0.2036, -0.3043, -0.4050, -0.5057, -0.6065, -0.7072, -0.8079, -0.9086, -1.0094]
        [-0.0025, -0.1032, -0.2039, -0.3046, -0.4054, -0.5061, -0.6068, -0.7075, -0.8083, -0.9090, -1.0097]
        [-0.0028, -0.1035, -0.2043, -0.3050, -0.4057, -0.5064, -0.6072, -0.7079, -0.8086, -0.9093, -1.0101]
        [-0.0032, -0.1039, -0.2046, -0.3053, -0.4061, -0.5068, -0.6075, -0.7082, -0.8090, -0.9097, -1.0104]
        [-0.0035, -0.1042, -0.2050, -0.3057, -0.4064, -0.5071, -0.6079, -0.7086, -0.8093, -0.9100, -1.0108]
        [-0.0039, -0.1046, -0.2053, -0.3061, -0.4068, -0.5075, -0.6082, -0.7089, -0.8097, -0.9104, -1.0111]
        [-0.0042, -0.1050, -0.2057, -0.3064, -0.4071, -0.5079, -0.6086, -0.7093, -0.8100, -0.9108, -1.0115]
        [-0.0046, -0.1053, -0.2060, -0.3068, -0.4075, -0.5082, -0.6089, -0.7097, -0.8104, -0.9111, -1.0118]
        [-0.0049, -0.1057, -0.2064, -0.3071, -0.4078, -0.5086, -0.6093, -0.7100, -0.8107, -0.9115, -1.0122]
        [-0.0053, -0.1060, -0.2067, -0.3075, -0.4082, -0.5089, -0.6096, -0.7104, -0.8111, -0.9118, -1.0125]
        [-0.0056, -0.1064, -0.2071, -0.3078, -0.4085, -0.5093, -0.6100, -0.7107, -0.8114, -0.9122, -1.0129]
        [-0.0060, -0.1067, -0.2074, -0.3082, -0.4089, -0.5096, -0.6103, -0.7111, -0.8118, -0.9125, -1.0132]
        [-0.0063, -0.1071, -0.2078, -0.3085, -0.4092, -0.5100, -0.6107, -0.7114, -0.8121, -0.9129, -1.0136]
        [-0.0067, -0.1074, -0.2081, -0.3089, -0.4096, -0.5103, -0.6110, -0.7118, -0.8125, -0.9132, -1.0139]
        [-0.0070, -0.1078, -0.2085, -0.3092, -0.4099, -0.5107, -0.6114, -0.7121, -0.8128, -0.9136, -1.0143]
      ]

      # 3rd quadrant Z
      expectRoundedArray(_.map(q3, (row) -> _.map(row, (el) -> el[2]))).toEqual [
        [0.0000, 0.0001, 0.0005, 0.0012, 0.0021, 0.0032, 0.0047, 0.0063, 0.0083, 0.0105, 0.0130]
        [0.0001, 0.0003, 0.0008, 0.0015, 0.0024, 0.0037, 0.0052, 0.0069, 0.0089, 0.0112, 0.0137]
        [0.0005, 0.0007, 0.0012, 0.0020, 0.0030, 0.0043, 0.0059, 0.0077, 0.0098, 0.0121, 0.0147]
        [0.0011, 0.0014, 0.0019, 0.0028, 0.0039, 0.0052, 0.0068, 0.0087, 0.0108, 0.0132, 0.0159]
        [0.0019, 0.0023, 0.0029, 0.0038, 0.0049, 0.0064, 0.0080, 0.0100, 0.0121, 0.0146, 0.0173]
        [0.0029, 0.0034, 0.0041, 0.0050, 0.0062, 0.0077, 0.0095, 0.0114, 0.0137, 0.0162, 0.0190]
        [0.0042, 0.0047, 0.0055, 0.0065, 0.0078, 0.0093, 0.0111, 0.0132, 0.0155, 0.0181, 0.0209]
        [0.0058, 0.0063, 0.0071, 0.0082, 0.0096, 0.0112, 0.0130, 0.0151, 0.0175, 0.0201, 0.0230]
        [0.0075, 0.0081, 0.0090, 0.0102, 0.0116, 0.0132, 0.0151, 0.0173, 0.0198, 0.0225, 0.0254]
        [0.0095, 0.0102, 0.0111, 0.0123, 0.0138, 0.0155, 0.0175, 0.0197, 0.0222, 0.0250, 0.0280]
        [0.0117, 0.0125, 0.0135, 0.0148, 0.0163, 0.0181, 0.0201, 0.0224, 0.0250, 0.0278, 0.0309]
        [0.0142, 0.0150, 0.0161, 0.0174, 0.0190, 0.0208, 0.0229, 0.0253, 0.0279, 0.0308, 0.0340]
        [0.0169, 0.0178, 0.0189, 0.0203, 0.0219, 0.0238, 0.0260, 0.0284, 0.0311, 0.0341, 0.0373]
        [0.0198, 0.0208, 0.0220, 0.0234, 0.0251, 0.0271, 0.0293, 0.0318, 0.0346, 0.0376, 0.0408]
        [0.0230, 0.0240, 0.0253, 0.0268, 0.0285, 0.0306, 0.0329, 0.0354, 0.0382, 0.0413, 0.0446]
        [0.0264, 0.0275, 0.0288, 0.0304, 0.0322, 0.0343, 0.0366, 0.0392, 0.0421, 0.0452, 0.0486]
        [0.0301, 0.0312, 0.0325, 0.0342, 0.0361, 0.0382, 0.0406, 0.0433, 0.0462, 0.0494, 0.0529]
        [0.0339, 0.0351, 0.0365, 0.0382, 0.0402, 0.0424, 0.0449, 0.0476, 0.0506, 0.0539, 0.0574]
        [0.0380, 0.0393, 0.0408, 0.0425, 0.0446, 0.0468, 0.0494, 0.0522, 0.0552, 0.0585, 0.0621]
        [0.0424, 0.0437, 0.0452, 0.0471, 0.0491, 0.0515, 0.0541, 0.0569, 0.0601, 0.0634, 0.0671]
        [0.0470, 0.0483, 0.0499, 0.0518, 0.0540, 0.0564, 0.0590, 0.0620, 0.0651, 0.0686, 0.0723]
      ]

      # 4th quadrant X
      expectRoundedArray(_.map(q4, (row) -> _.map(row, _.first))).toEqual [
        [0.0000, -0.0004, -0.0007, -0.0011, -0.0014, -0.0018, -0.0021, -0.0025, -0.0028, -0.0032, -0.0035]
        [0.0996, 0.0992, 0.0989, 0.0985, 0.0982, 0.0978, 0.0975, 0.0971, 0.0968, 0.0964, 0.0961]
        [0.1992, 0.1988, 0.1985, 0.1981, 0.1978, 0.1974, 0.1971, 0.1967, 0.1964, 0.1960, 0.1957]
        [0.2988, 0.2984, 0.2981, 0.2977, 0.2974, 0.2970, 0.2967, 0.2963, 0.2960, 0.2956, 0.2953]
        [0.3984, 0.3980, 0.3977, 0.3973, 0.3970, 0.3966, 0.3963, 0.3959, 0.3955, 0.3952, 0.3948]
        [0.4980, 0.4976, 0.4973, 0.4969, 0.4966, 0.4962, 0.4958, 0.4955, 0.4951, 0.4948, 0.4944]
        [0.5976, 0.5972, 0.5968, 0.5965, 0.5961, 0.5958, 0.5954, 0.5951, 0.5947, 0.5944, 0.5940]
        [0.6971, 0.6968, 0.6964, 0.6961, 0.6957, 0.6954, 0.6950, 0.6947, 0.6943, 0.6940, 0.6936]
        [0.7967, 0.7964, 0.7960, 0.7957, 0.7953, 0.7950, 0.7946, 0.7943, 0.7939, 0.7936, 0.7932]
        [0.8963, 0.8960, 0.8956, 0.8953, 0.8949, 0.8946, 0.8942, 0.8939, 0.8935, 0.8932, 0.8928]
        [0.9959, 0.9956, 0.9952, 0.9949, 0.9945, 0.9942, 0.9938, 0.9935, 0.9931, 0.9928, 0.9924]
        [1.0955, 1.0952, 1.0948, 1.0945, 1.0941, 1.0938, 1.0934, 1.0930, 1.0927, 1.0923, 1.0920]
        [1.1951, 1.1948, 1.1944, 1.1941, 1.1937, 1.1933, 1.1930, 1.1926, 1.1923, 1.1919, 1.1916]
        [1.2947, 1.2943, 1.2940, 1.2936, 1.2933, 1.2929, 1.2926, 1.2922, 1.2919, 1.2915, 1.2912]
        [1.3943, 1.3939, 1.3936, 1.3932, 1.3929, 1.3925, 1.3922, 1.3918, 1.3915, 1.3911, 1.3908]
        [1.4939, 1.4935, 1.4932, 1.4928, 1.4925, 1.4921, 1.4918, 1.4914, 1.4911, 1.4907, 1.4904]
        [1.5935, 1.5931, 1.5928, 1.5924, 1.5921, 1.5917, 1.5914, 1.5910, 1.5907, 1.5903, 1.5900]
        [1.6931, 1.6927, 1.6924, 1.6920, 1.6917, 1.6913, 1.6910, 1.6906, 1.6902, 1.6899, 1.6895]
        [1.7927, 1.7923, 1.7920, 1.7916, 1.7913, 1.7909, 1.7905, 1.7902, 1.7898, 1.7895, 1.7891]
        [1.8923, 1.8919, 1.8915, 1.8912, 1.8908, 1.8905, 1.8901, 1.8898, 1.8894, 1.8891, 1.8887]
        [1.9918, 1.9915, 1.9911, 1.9908, 1.9904, 1.9901, 1.9897, 1.9894, 1.9890, 1.9887, 1.9883]
      ]

      # 4th quadrant Y
      expectRoundedArray(_.map(q4, (row) -> _.map(row, (el) -> el[1]))).toEqual [
        [0.0000, -0.1007, -0.2014, -0.3022, -0.4029, -0.5036, -0.6043, -0.7051, -0.8058, -0.9065, -1.0072]
        [0.0004, -0.1004, -0.2011, -0.3018, -0.4025, -0.5033, -0.6040, -0.7047, -0.8054, -0.9062, -1.0069]
        [0.0007, -0.1000, -0.2007, -0.3015, -0.4022, -0.5029, -0.6036, -0.7044, -0.8051, -0.9058, -1.0065]
        [0.0011, -0.0997, -0.2004, -0.3011, -0.4018, -0.5026, -0.6033, -0.7040, -0.8047, -0.9055, -1.0062]
        [0.0014, -0.0993, -0.2000, -0.3008, -0.4015, -0.5022, -0.6029, -0.7037, -0.8044, -0.9051, -1.0058]
        [0.0018, -0.0990, -0.1997, -0.3004, -0.4011, -0.5019, -0.6026, -0.7033, -0.8040, -0.9048, -1.0055]
        [0.0021, -0.0986, -0.1993, -0.3001, -0.4008, -0.5015, -0.6022, -0.7030, -0.8037, -0.9044, -1.0051]
        [0.0025, -0.0983, -0.1990, -0.2997, -0.4004, -0.5012, -0.6019, -0.7026, -0.8033, -0.9041, -1.0048]
        [0.0028, -0.0979, -0.1986, -0.2994, -0.4001, -0.5008, -0.6015, -0.7023, -0.8030, -0.9037, -1.0044]
        [0.0032, -0.0976, -0.1983, -0.2990, -0.3997, -0.5005, -0.6012, -0.7019, -0.8026, -0.9033, -1.0041]
        [0.0035, -0.0972, -0.1979, -0.2986, -0.3994, -0.5001, -0.6008, -0.7015, -0.8023, -0.9030, -1.0037]
        [0.0039, -0.0968, -0.1976, -0.2983, -0.3990, -0.4997, -0.6005, -0.7012, -0.8019, -0.9026, -1.0034]
        [0.0042, -0.0965, -0.1972, -0.2979, -0.3987, -0.4994, -0.6001, -0.7008, -0.8016, -0.9023, -1.0030]
        [0.0046, -0.0961, -0.1969, -0.2976, -0.3983, -0.4990, -0.5998, -0.7005, -0.8012, -0.9019, -1.0027]
        [0.0049, -0.0958, -0.1965, -0.2972, -0.3980, -0.4987, -0.5994, -0.7001, -0.8009, -0.9016, -1.0023]
        [0.0053, -0.0954, -0.1962, -0.2969, -0.3976, -0.4983, -0.5991, -0.6998, -0.8005, -0.9012, -1.0020]
        [0.0056, -0.0951, -0.1958, -0.2965, -0.3973, -0.4980, -0.5987, -0.6994, -0.8002, -0.9009, -1.0016]
        [0.0060, -0.0947, -0.1955, -0.2962, -0.3969, -0.4976, -0.5984, -0.6991, -0.7998, -0.9005, -1.0013]
        [0.0063, -0.0944, -0.1951, -0.2958, -0.3966, -0.4973, -0.5980, -0.6987, -0.7995, -0.9002, -1.0009]
        [0.0067, -0.0940, -0.1948, -0.2955, -0.3962, -0.4969, -0.5977, -0.6984, -0.7991, -0.8998, -1.0005]
        [0.0070, -0.0937, -0.1944, -0.2951, -0.3958, -0.4966, -0.5973, -0.6980, -0.7987, -0.8995, -1.0002]
      ]

      # 4th quadrant Z
      expectRoundedArray(_.map(q4, (row) -> _.map(row, (el) -> el[2]))).toEqual [
        [0.0000, 0.0001, 0.0005, 0.0012, 0.0021, 0.0032, 0.0047, 0.0063, 0.0083, 0.0105, 0.0130]
        [0.0001, 0.0002, 0.0005, 0.0011, 0.0019, 0.0030, 0.0044, 0.0060, 0.0079, 0.0101, 0.0125]
        [0.0005, 0.0005, 0.0007, 0.0013, 0.0020, 0.0031, 0.0044, 0.0060, 0.0078, 0.0099, 0.0122]
        [0.0011, 0.0010, 0.0012, 0.0017, 0.0024, 0.0034, 0.0046, 0.0061, 0.0079, 0.0099, 0.0122]
        [0.0019, 0.0018, 0.0019, 0.0023, 0.0030, 0.0039, 0.0051, 0.0065, 0.0082, 0.0102, 0.0124]
        [0.0029, 0.0028, 0.0028, 0.0032, 0.0038, 0.0046, 0.0057, 0.0071, 0.0088, 0.0107, 0.0128]
        [0.0042, 0.0040, 0.0040, 0.0043, 0.0048, 0.0056, 0.0067, 0.0080, 0.0096, 0.0114, 0.0135]
        [0.0058, 0.0054, 0.0054, 0.0056, 0.0061, 0.0068, 0.0078, 0.0091, 0.0106, 0.0124, 0.0144]
        [0.0075, 0.0071, 0.0070, 0.0072, 0.0076, 0.0083, 0.0092, 0.0104, 0.0119, 0.0136, 0.0155]
        [0.0095, 0.0091, 0.0089, 0.0090, 0.0094, 0.0100, 0.0108, 0.0120, 0.0134, 0.0150, 0.0169]
        [0.0117, 0.0113, 0.0110, 0.0111, 0.0113, 0.0119, 0.0127, 0.0138, 0.0151, 0.0167, 0.0185]
        [0.0142, 0.0137, 0.0134, 0.0133, 0.0136, 0.0140, 0.0148, 0.0158, 0.0171, 0.0186, 0.0204]
        [0.0169, 0.0163, 0.0159, 0.0158, 0.0160, 0.0164, 0.0171, 0.0181, 0.0193, 0.0207, 0.0225]
        [0.0198, 0.0192, 0.0188, 0.0186, 0.0187, 0.0191, 0.0197, 0.0206, 0.0217, 0.0231, 0.0248]
        [0.0230, 0.0223, 0.0218, 0.0216, 0.0216, 0.0219, 0.0225, 0.0233, 0.0244, 0.0257, 0.0273]
        [0.0264, 0.0256, 0.0251, 0.0248, 0.0248, 0.0250, 0.0255, 0.0263, 0.0273, 0.0286, 0.0301]
        [0.0301, 0.0292, 0.0286, 0.0283, 0.0282, 0.0284, 0.0288, 0.0295, 0.0304, 0.0317, 0.0331]
        [0.0339, 0.0330, 0.0323, 0.0319, 0.0318, 0.0319, 0.0323, 0.0329, 0.0338, 0.0350, 0.0364]
        [0.0380, 0.0371, 0.0363, 0.0359, 0.0357, 0.0357, 0.0360, 0.0366, 0.0374, 0.0385, 0.0399]
        [0.0424, 0.0413, 0.0406, 0.0400, 0.0398, 0.0398, 0.0400, 0.0405, 0.0413, 0.0423, 0.0436]
        [0.0470, 0.0459, 0.0450, 0.0444, 0.0441, 0.0440, 0.0442, 0.0447, 0.0454, 0.0463, 0.0476]
      ]