ILR.LaminateDeformation ?= {}
ILR.LaminateDeformation.Models ?= {}
class ILR.LaminateDeformation.Models.Calculator extends ILR.Models.BaseCalculator
  constructor: (options = {}) ->
    super(_.defaults(options, required: ['model']))

  length:      @reactive 'length',      -> @model.get('length')
  aspectRatio: @reactive 'aspectRatio', -> @length() / @width()
  width:       @reactive 'width',       -> @model.get('width')
  xLoad:       @reactive 'xLoad',       -> @model.get('xLoad')
  yLoad:       @reactive 'yLoad',       -> @model.get('yLoad')
  shearLoad:   @reactive 'shearLoad',   -> @model.get('shearLoad')
  xMoment:     @reactive 'xMoment',     -> @model.get('xMoment')
  yMoment:     @reactive 'yMoment',     -> @model.get('yMoment')
  shearMoment: @reactive 'shearMoment', -> @model.get('shearMoment')
  xyPsf:       @reactive 'xyPsf',       -> @model.get('xyPsf')
  zPsf:        @reactive 'zPsf',        -> @model.get('zPsf')
  membraneStiffness: @reactive 'membraneStiffness', ->
    ILR.settings[@model.name].laminates[@model.get('laminate')].membraneStiffness
  cupplingStiffness: @reactive 'cupplingStiffness', ->
    ILR.settings[@model.name].laminates[@model.get('laminate')].cupplingStiffness
  bendingStiffness: @reactive 'bendingStiffness', ->
    ILR.settings[@model.name].laminates[@model.get('laminate')].bendingStiffness

  abd: @memoize 'abd', ->
    A = @membraneStiffness()
    B = @cupplingStiffness()
    D = @bendingStiffness()
    [
      A[0].concat(B[0])
      A[1].concat(B[1])
      A[2].concat(B[2])
      B[0].concat(D[0])
      B[1].concat(D[1])
      B[2].concat(D[2])
    ]

  eps_kappa: @memoize 'eps_kappa', ->
    Math.gaussianElimination(@abd(), [@xLoad(), @yLoad(), @shearLoad(), @xMoment(), @yMoment(), @shearMoment()])

  laminate: @memoize 'laminate', ->
    [eps_x, eps_y, gamma_xy, kappa_x, kappa_y, kappa_xy] = @eps_kappa()

    xyPsf = @xyPsf()
    zPsf = @zPsf()

    # 1 segment per 10 mm, 1 LE := 100mm
    xgv = (i / 100 for i in [0..@length()] by 10)
    ygv = (i / 100 for i in [0..@width()] by 10)

    # Displacements in x and y direction resulting from normal strains
    eps_x_psf = eps_x * xyPsf
    eps_y_psf = eps_y * xyPsf
    u_x = (eps_x_psf * x for x in xgv)
    v_y = (eps_y_psf * y for y in ygv)

    # Displacement in x and y direction resulting from shear strain
    gamma_xy_half_psf = xyPsf * gamma_xy / 2
    u_xy = (gamma_xy_half_psf * y for y in ygv)
    v_xy = (gamma_xy_half_psf * x for x in xgv)

    # Displacement in z direction due to curvature kappa_x
    kappa_x_half_psf = zPsf * kappa_x / 2
    w_x = (kappa_x_half_psf * x * x for x in xgv)

    # Displacements in z direction due to curvature kappa_y
    kappa_y_half_psf = zPsf * kappa_y / 2
    w_y = (kappa_y_half_psf * y * y for y in ygv)

    # Displacement in z direction due to twist kappa_xy
    w_xy = for x in xgv
      t_psf = zPsf * kappa_xy * x
      t_psf * y for y in ygv

    [
      # 1st quadrant
      for ix in [0...xgv.length] by 1
        for iy in [0...ygv.length] by 1
          [
            xgv[ix] + u_x[ix] + u_xy[iy]
            ygv[iy] + v_y[iy] + v_xy[ix]
            w_x[ix] + w_y[iy] + w_xy[ix][iy]
          ]

      # 2nd quadrant
      for ix in [0...xgv.length] by 1
        for iy in [0...ygv.length] by 1
          [
            -xgv[ix] - u_x[ix] + u_xy[iy]
            ygv[iy] + v_y[iy] - v_xy[ix]
            w_x[ix] + w_y[iy] - w_xy[ix][iy]
          ]

      # 4td quadrant
      for ix in [0...xgv.length] by 1
        for iy in [0...ygv.length] by 1
          [
            -xgv[ix] - u_x[ix] - u_xy[iy]
            -ygv[iy] - v_y[iy] - v_xy[ix]
            w_x[ix] + w_y[iy] + w_xy[ix][iy]
          ]

      # 4th quadrant
      for ix in [0...xgv.length] by 1
        for iy in [0...ygv.length] by 1
          [
            xgv[ix] + u_x[ix] - u_xy[iy]
            -ygv[iy] - v_y[iy] + v_xy[ix]
            w_x[ix] + w_y[iy] - w_xy[ix][iy]
          ]
    ]
