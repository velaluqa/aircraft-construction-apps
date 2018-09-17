describe 'ILR.BeamSectionProperties.Models.UProfileCalculator', ->
  beforeEach ->
    @model = new Backbone.Model
      profileWidth: 1
      relFlangeThickness: 0.1
      relWebThickness: 0.8
      relLipThickness: 0.1
      relWebHeight: 1
      relLipHeight: 0.15
    @calc = new ILR.BeamSectionProperties.Models.UProfileCalculator
      model: @model

  describe '#relFlangeThickness', ->
    it 'should return the correct value', ->
      expect(@calc.relFlangeThickness()).toEqual(0.1)
  describe '#relWebThickness', ->
    it 'should return the correct value', ->
      expect(@calc.relWebThickness()).toEqual(0.8)
  describe '#relLipThickness', ->
    it 'should return the correct value', ->
      expect(@calc.relLipThickness()).toEqual(0.1)
  describe '#profileWidth', ->
    it 'should return the correct value', ->
      expect(@calc.profileWidth()).toEqual(1)
  describe '#relWebHeight', ->
    it 'should return the correct value', ->
      expect(@calc.relWebHeight()).toEqual(1)
  describe '#relLipHeight', ->
    it 'should return the correct value', ->
      expect(@calc.relLipHeight()).toEqual(0.15)

  describe 'with relLipHeight < 0', ->
    beforeEach ->
      @model.set relLipHeight: -0.15

    describe '#flangeThickness', ->
      it 'should return the correct value', ->
        expect(@calc.flangeThickness()).toEqual(0.1)
    describe '#webThickness', ->
      it 'should return the correct value', ->
        expect(@calc.webThickness()).toEqual(0.8)
    describe '#lipThickness', ->
      it 'should return the correct value', ->
        expect(@calc.lipThickness()).toEqual(0.1)
    describe '#webHeight', ->
      it 'should return the correct value', ->
        expect(@calc.webHeight()).toEqual(1)
    describe '#lipHeight', ->
      it 'should return the correct value', ->
        expect(@calc.lipHeight()).toEqual(-0.15)

    describe '#Ax', ->
      it 'should return the correct value', ->
        expect(@calc.Ax()).toEqual(-0.4)
    describe '#Ay', ->
      it 'should return the correct value', ->
        expect(@calc.Ay()).toEqual(0)
    describe '#Bx', ->
      it 'should return the correct value', ->
        expect(@calc.Bx()).toEqual(-0.4)
    describe '#By', ->
      it 'should return the correct value', ->
        expect(@calc.By()).toEqual(0.5)
    describe '#Cx', ->
      it 'should return the correct value', ->
        expect(@calc.Cx()).toEqual(0.5)
    describe '#Cy', ->
      it 'should return the correct value', ->
        expect(@calc.Cy()).toEqual(0.5)
    describe '#Dx', ->
      it 'should return the correct value', ->
        expect(@calc.Dx()).toEqual(0.5)
    describe '#Dy', ->
      it 'should return the correct value', ->
        expect(@calc.Dy()).toEqual(0.65)
    describe '#Ex', ->
      it 'should return the correct value', ->
        expect(@calc.Ex()).toEqual(0.6)
    describe '#Ey', ->
      it 'should return the correct value', ->
        expect(@calc.Ey()).toEqual(0.65)
    describe '#Fx', ->
      it 'should return the correct value', ->
        expect(@calc.Fx()).toEqual(0.6)
    describe '#Fy', ->
      it 'should return the correct value', ->
        expect(@calc.Fy()).toEqual(0.4)
    describe '#Gx', ->
      it 'should return the correct value', ->
        expect(@calc.Gx()).toEqual(0.5)
    describe '#Gy', ->
      it 'should return the correct value', ->
        expect(@calc.Gy()).toEqual(0.4)
    describe '#Hx', ->
      it 'should return the correct value', ->
        expect(@calc.Hx()).toEqual(0.5)
    describe '#Hy', ->
      it 'should return the correct value', ->
        expect(@calc.Hy()).toEqual(0.4)
    describe '#Ix', ->
      it 'should return the correct value', ->
        expect(@calc.Ix()).toEqual(0.4)
    describe '#Iy', ->
      it 'should return the correct value', ->
        expect(@calc.Iy()).toEqual(0.4)
    describe '#Jx', ->
      it 'should return the correct value', ->
        expect(@calc.Jx()).toEqual(0.4)
    describe '#Jy', ->
      it 'should return the correct value', ->
        expect(@calc.Jy()).toEqual(-0.4)
    describe '#Kx', ->
      it 'should return the correct value', ->
        expect(@calc.Kx()).toEqual(0.5)
    describe '#Ky', ->
      it 'should return the correct value', ->
        expect(@calc.Ky()).toEqual(-0.4)
    describe '#Lx', ->
      it 'should return the correct value', ->
        expect(@calc.Lx()).toEqual(0.5)
    describe '#Ly', ->
      it 'should return the correct value', ->
        expect(@calc.Ly()).toEqual(-0.4)
    describe '#Mx', ->
      it 'should return the correct value', ->
        expect(@calc.Mx()).toEqual(0.6)
    describe '#My', ->
      it 'should return the correct value', ->
        expect(@calc.My()).toEqual(-0.4)
    describe '#Nx', ->
      it 'should return the correct value', ->
        expect(@calc.Nx()).toEqual(0.6)
    describe '#Ny', ->
      it 'should return the correct value', ->
        expect(@calc.Ny()).toEqual(-0.65)
    describe '#Ox', ->
      it 'should return the correct value', ->
        expect(@calc.Ox()).toEqual(0.5)
    describe '#Oy', ->
      it 'should return the correct value', ->
        expect(@calc.Oy()).toEqual(-0.65)
    describe '#Px', ->
      it 'should return the correct value', ->
        expect(@calc.Px()).toEqual(0.5)
    describe '#Py', ->
      it 'should return the correct value', ->
        expect(@calc.Py()).toEqual(-0.5)
    describe '#Qx', ->
      it 'should return the correct value', ->
        expect(@calc.Qx()).toEqual(-0.4)
    describe '#Qy', ->
      it 'should return the correct value', ->
        expect(@calc.Qy()).toEqual(-0.5)
    describe '#Rx', ->
      it 'should return the correct value', ->
        expect(@calc.Rx()).toEqual(-0.4)
    describe '#Ry', ->
      it 'should return the correct value', ->
        expect(@calc.Ry()).toEqual(0)

    describe '#inertiaBase', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaBase(), 8).toEqual(0.06666667)
    describe '#inertiaFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaFlange(), 8).toEqual(0.00813333)
    describe '#inertiaEdge', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaEdge(), 8).toEqual(0.009975)
    describe '#inertiaIy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaIy(), 8).toEqual(0.084775)
    describe '#staticMomentLip', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentLip(), 8).toEqual(0.00064167)
    describe '#staticMomentSy0', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy0(), 8).toEqual(0.011)
    describe '#staticMomentFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentFlange(), 8).toEqual(0.00578531)
    describe '#staticMomentSy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy(), 8).toEqual(0.01028729)

    describe 'thrustCenterX', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterX()).toEqual(-0.1213)
    describe 'thrustCenterY', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterY()).toEqual(0)

  describe 'with relLipThickness = 0', ->
    beforeEach ->
      @model.set relLipThickness: 0
    describe '#flangeThickness', ->
      it 'should return the correct value', ->
        expect(@calc.flangeThickness()).toEqual(0.1)
    describe '#webThickness', ->
      it 'should return the correct value', ->
        expect(@calc.webThickness()).toEqual(0.8)
    describe '#lipThickness', ->
      it 'should return the correct value', ->
        expect(@calc.lipThickness()).toEqual(0)
    describe '#webHeight', ->
      it 'should return the correct value', ->
        expect(@calc.webHeight()).toEqual(1)
    describe '#lipHeight', ->
      it 'should return the correct value', ->
        expect(@calc.lipHeight()).toEqual(0)

    describe '#Ax', ->
      it 'should return the correct value', ->
        expect(@calc.Ax()).toEqual(-0.4)
    describe '#Ay', ->
      it 'should return the correct value', ->
        expect(@calc.Ay()).toEqual(0)
    describe '#Bx', ->
      it 'should return the correct value', ->
        expect(@calc.Bx()).toEqual(-0.4)
    describe '#By', ->
      it 'should return the correct value', ->
        expect(@calc.By()).toEqual(0.5)
    describe '#Cx', ->
      it 'should return the correct value', ->
        expect(@calc.Cx()).toEqual(0.6)
    describe '#Cy', ->
      it 'should return the correct value', ->
        expect(@calc.Cy()).toEqual(0.5)
    describe '#Dx', ->
      it 'should return the correct value', ->
        expect(@calc.Dx()).toEqual(0.6)
    describe '#Dy', ->
      it 'should return the correct value', ->
        expect(@calc.Dy()).toEqual(0.5)
    describe '#Ex', ->
      it 'should return the correct value', ->
        expect(@calc.Ex()).toEqual(0.6)
    describe '#Ey', ->
      it 'should return the correct value', ->
        expect(@calc.Ey()).toEqual(0.5)
    describe '#Fx', ->
      it 'should return the correct value', ->
        expect(@calc.Fx()).toEqual(0.6)
    describe '#Fy', ->
      it 'should return the correct value', ->
        expect(@calc.Fy()).toEqual(0.4)
    describe '#Gx', ->
      it 'should return the correct value', ->
        expect(@calc.Gx()).toEqual(0.6)
    describe '#Gy', ->
      it 'should return the correct value', ->
        expect(@calc.Gy()).toEqual(0.4)
    describe '#Hx', ->
      it 'should return the correct value', ->
        expect(@calc.Hx()).toEqual(0.6)
    describe '#Hy', ->
      it 'should return the correct value', ->
        expect(@calc.Hy()).toEqual(0.4)
    describe '#Ix', ->
      it 'should return the correct value', ->
        expect(@calc.Ix()).toEqual(0.4)
    describe '#Iy', ->
      it 'should return the correct value', ->
        expect(@calc.Iy()).toEqual(0.4)
    describe '#Jx', ->
      it 'should return the correct value', ->
        expect(@calc.Jx()).toEqual(0.4)
    describe '#Jy', ->
      it 'should return the correct value', ->
        expect(@calc.Jy()).toEqual(-0.4)
    describe '#Kx', ->
      it 'should return the correct value', ->
        expect(@calc.Kx()).toEqual(0.6)
    describe '#Ky', ->
      it 'should return the correct value', ->
        expect(@calc.Ky()).toEqual(-0.4)
    describe '#Lx', ->
      it 'should return the correct value', ->
        expect(@calc.Lx()).toEqual(0.6)
    describe '#Ly', ->
      it 'should return the correct value', ->
        expect(@calc.Ly()).toEqual(-0.4)
    describe '#Mx', ->
      it 'should return the correct value', ->
        expect(@calc.Mx()).toEqual(0.6)
    describe '#My', ->
      it 'should return the correct value', ->
        expect(@calc.My()).toEqual(-0.4)
    describe '#Nx', ->
      it 'should return the correct value', ->
        expect(@calc.Nx()).toEqual(0.6)
    describe '#Ny', ->
      it 'should return the correct value', ->
        expect(@calc.Ny()).toEqual(-0.5)
    describe '#Ox', ->
      it 'should return the correct value', ->
        expect(@calc.Ox()).toEqual(0.6)
    describe '#Oy', ->
      it 'should return the correct value', ->
        expect(@calc.Oy()).toEqual(-0.5)
    describe '#Px', ->
      it 'should return the correct value', ->
        expect(@calc.Px()).toEqual(0.6)
    describe '#Py', ->
      it 'should return the correct value', ->
        expect(@calc.Py()).toEqual(-0.5)
    describe '#Qx', ->
      it 'should return the correct value', ->
        expect(@calc.Qx()).toEqual(-0.4)
    describe '#Qy', ->
      it 'should return the correct value', ->
        expect(@calc.Qy()).toEqual(-0.5)
    describe '#Rx', ->
      it 'should return the correct value', ->
        expect(@calc.Rx()).toEqual(-0.4)
    describe '#Ry', ->
      it 'should return the correct value', ->
        expect(@calc.Ry()).toEqual(0)

    describe '#inertiaBase', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaBase(), 8).toEqual(0.06666667)
    describe '#inertiaFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaFlange(), 8).toEqual(0.00813333)
    describe '#inertiaEdge', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaEdge(), 8).toEqual(0)
    describe '#inertiaIy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaIy(), 8).toEqual(0.0748)
    describe '#staticMomentLip', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentLip(), 8).toEqual(0)
    describe '#staticMomentSy0', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy0(), 8).toEqual(0)
    describe '#staticMomentFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentFlange(), 8).toEqual(0.003645)
    describe '#staticMomentSy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy(), 8).toEqual(0.00729)

    describe 'thrustCenterX', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterX()).toEqual(-0.0975)
    describe 'thrustCenterY', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterY()).toEqual(0)

  describe 'with relLipThickness = 0 and relLipHeight < 0', ->
    beforeEach ->
      @model.set(relLipThickness: 0, relLipHeight: -0.1)

    describe '#flangeThickness', ->
      it 'should return the correct value', ->
        expect(@calc.flangeThickness()).toEqual(0.1)
    describe '#webThickness', ->
      it 'should return the correct value', ->
        expect(@calc.webThickness()).toEqual(0.8)
    describe '#lipThickness', ->
      it 'should return the correct value', ->
        expect(@calc.lipThickness()).toEqual(0)
    describe '#webHeight', ->
      it 'should return the correct value', ->
        expect(@calc.webHeight()).toEqual(1)
    describe '#lipHeight', ->
      it 'should return the correct value', ->
        expect(@calc.lipHeight()).toEqual(0)

    describe '#Ax', ->
      it 'should return the correct value', ->
        expect(@calc.Ax()).toEqual(-0.4)
    describe '#Ay', ->
      it 'should return the correct value', ->
        expect(@calc.Ay()).toEqual(0)
    describe '#Bx', ->
      it 'should return the correct value', ->
        expect(@calc.Bx()).toEqual(-0.4)
    describe '#By', ->
      it 'should return the correct value', ->
        expect(@calc.By()).toEqual(0.5)
    describe '#Cx', ->
      it 'should return the correct value', ->
        expect(@calc.Cx()).toEqual(0.6)
    describe '#Cy', ->
      it 'should return the correct value', ->
        expect(@calc.Cy()).toEqual(0.5)
    describe '#Dx', ->
      it 'should return the correct value', ->
        expect(@calc.Dx()).toEqual(0.6)
    describe '#Dy', ->
      it 'should return the correct value', ->
        expect(@calc.Dy()).toEqual(0.5)
    describe '#Ex', ->
      it 'should return the correct value', ->
        expect(@calc.Ex()).toEqual(0.6)
    describe '#Ey', ->
      it 'should return the correct value', ->
        expect(@calc.Ey()).toEqual(0.5)
    describe '#Fx', ->
      it 'should return the correct value', ->
        expect(@calc.Fx()).toEqual(0.6)
    describe '#Fy', ->
      it 'should return the correct value', ->
        expect(@calc.Fy()).toEqual(0.4)
    describe '#Gx', ->
      it 'should return the correct value', ->
        expect(@calc.Gx()).toEqual(0.6)
    describe '#Gy', ->
      it 'should return the correct value', ->
        expect(@calc.Gy()).toEqual(0.4)
    describe '#Hx', ->
      it 'should return the correct value', ->
        expect(@calc.Hx()).toEqual(0.6)
    describe '#Hy', ->
      it 'should return the correct value', ->
        expect(@calc.Hy()).toEqual(0.4)
    describe '#Ix', ->
      it 'should return the correct value', ->
        expect(@calc.Ix()).toEqual(0.4)
    describe '#Iy', ->
      it 'should return the correct value', ->
        expect(@calc.Iy()).toEqual(0.4)
    describe '#Jx', ->
      it 'should return the correct value', ->
        expect(@calc.Jx()).toEqual(0.4)
    describe '#Jy', ->
      it 'should return the correct value', ->
        expect(@calc.Jy()).toEqual(-0.4)
    describe '#Kx', ->
      it 'should return the correct value', ->
        expect(@calc.Kx()).toEqual(0.6)
    describe '#Ky', ->
      it 'should return the correct value', ->
        expect(@calc.Ky()).toEqual(-0.4)
    describe '#Lx', ->
      it 'should return the correct value', ->
        expect(@calc.Lx()).toEqual(0.6)
    describe '#Ly', ->
      it 'should return the correct value', ->
        expect(@calc.Ly()).toEqual(-0.4)
    describe '#Mx', ->
      it 'should return the correct value', ->
        expect(@calc.Mx()).toEqual(0.6)
    describe '#My', ->
      it 'should return the correct value', ->
        expect(@calc.My()).toEqual(-0.4)
    describe '#Nx', ->
      it 'should return the correct value', ->
        expect(@calc.Nx()).toEqual(0.6)
    describe '#Ny', ->
      it 'should return the correct value', ->
        expect(@calc.Ny()).toEqual(-0.5)
    describe '#Ox', ->
      it 'should return the correct value', ->
        expect(@calc.Ox()).toEqual(0.6)
    describe '#Oy', ->
      it 'should return the correct value', ->
        expect(@calc.Oy()).toEqual(-0.5)
    describe '#Px', ->
      it 'should return the correct value', ->
        expect(@calc.Px()).toEqual(0.6)
    describe '#Py', ->
      it 'should return the correct value', ->
        expect(@calc.Py()).toEqual(-0.5)
    describe '#Qx', ->
      it 'should return the correct value', ->
        expect(@calc.Qx()).toEqual(-0.4)
    describe '#Qy', ->
      it 'should return the correct value', ->
        expect(@calc.Qy()).toEqual(-0.5)
    describe '#Rx', ->
      it 'should return the correct value', ->
        expect(@calc.Rx()).toEqual(-0.4)
    describe '#Ry', ->
      it 'should return the correct value', ->
        expect(@calc.Ry()).toEqual(0)

    describe '#inertiaBase', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaBase(), 8).toEqual(0.06666667)
    describe '#inertiaFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaFlange(), 8).toEqual(0.00813333)
    describe '#inertiaEdge', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaEdge(), 8).toEqual(0)
    describe '#inertiaIy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaIy(), 8).toEqual(0.0748)
    describe '#staticMomentLip', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentLip(), 8).toEqual(0)
    describe '#staticMomentSy0', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy0(), 8).toEqual(0)
    describe '#staticMomentFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentFlange(), 8).toEqual(0.003645)
    describe '#staticMomentSy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy(), 8).toEqual(0.00729)
    describe 'thrustCenterX', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterX()).toEqual(-0.0975)
    describe 'thrustCenterY', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterY()).toEqual(0)

  describe 'with relLipHeight > 0', ->
    beforeEach ->
      @model.set relLipHeight: 0.15

    describe '#flangeThickness', ->
      it 'should return the correct value', ->
        expect(@calc.flangeThickness()).toEqual(0.1)
    describe '#webThickness', ->
      it 'should return the correct value', ->
        expect(@calc.webThickness()).toEqual(0.8)
    describe '#lipThickness', ->
      it 'should return the correct value', ->
        expect(@calc.lipThickness()).toEqual(0.1)
    describe '#webHeight', ->
      it 'should return the correct value', ->
        expect(@calc.webHeight()).toEqual(1)
    describe '#lipHeight', ->
      it 'should return the correct value', ->
        expect(@calc.lipHeight()).toEqual(0.15)

    describe '#Ax', ->
      it 'should return the correct value', ->
        expect(@calc.Ax()).toEqual(-0.4)
    describe '#Ay', ->
      it 'should return the correct value', ->
        expect(@calc.Ay()).toEqual(0)
    describe '#Bx', ->
      it 'should return the correct value', ->
        expect(@calc.Bx()).toEqual(-0.4)
    describe '#By', ->
      it 'should return the correct value', ->
        expect(@calc.By()).toEqual(0.5)
    describe '#Cx', ->
      it 'should return the correct value', ->
        expect(@calc.Cx()).toEqual(0.5)
    describe '#Cy', ->
      it 'should return the correct value', ->
        expect(@calc.Cy()).toEqual(0.5)
    describe '#Dx', ->
      it 'should return the correct value', ->
        expect(@calc.Dx()).toEqual(0.5)
    describe '#Dy', ->
      it 'should return the correct value', ->
        expect(@calc.Dy()).toEqual(0.5)
    describe '#Ex', ->
      it 'should return the correct value', ->
        expect(@calc.Ex()).toEqual(0.6)
    describe '#Ey', ->
      it 'should return the correct value', ->
        expect(@calc.Ey()).toEqual(0.5)
    describe '#Fx', ->
      it 'should return the correct value', ->
        expect(@calc.Fx()).toEqual(0.6)
    describe '#Fy', ->
      it 'should return the correct value', ->
        expect(@calc.Fy()).toEqual(0.25)
    describe '#Gx', ->
      it 'should return the correct value', ->
        expect(@calc.Gx()).toEqual(0.5)
    describe '#Gy', ->
      it 'should return the correct value', ->
        expect(@calc.Gy()).toEqual(0.25)
    describe '#Hx', ->
      it 'should return the correct value', ->
        expect(@calc.Hx()).toEqual(0.5)
    describe '#Hy', ->
      it 'should return the correct value', ->
        expect(@calc.Hy()).toEqual(0.4)
    describe '#Ix', ->
      it 'should return the correct value', ->
        expect(@calc.Ix()).toEqual(0.4)
    describe '#Iy', ->
      it 'should return the correct value', ->
        expect(@calc.Iy()).toEqual(0.4)
    describe '#Jx', ->
      it 'should return the correct value', ->
        expect(@calc.Jx()).toEqual(0.4)
    describe '#Jy', ->
      it 'should return the correct value', ->
        expect(@calc.Jy()).toEqual(-0.4)
    describe '#Kx', ->
      it 'should return the correct value', ->
        expect(@calc.Kx()).toEqual(0.5)
    describe '#Ky', ->
      it 'should return the correct value', ->
        expect(@calc.Ky()).toEqual(-0.4)
    describe '#Lx', ->
      it 'should return the correct value', ->
        expect(@calc.Lx()).toEqual(0.5)
    describe '#Ly', ->
      it 'should return the correct value', ->
        expect(@calc.Ly()).toEqual(-0.25)
    describe '#Mx', ->
      it 'should return the correct value', ->
        expect(@calc.Mx()).toEqual(0.6)
    describe '#My', ->
      it 'should return the correct value', ->
        expect(@calc.My()).toEqual(-0.25)
    describe '#Nx', ->
      it 'should return the correct value', ->
        expect(@calc.Nx()).toEqual(0.6)
    describe '#Ny', ->
      it 'should return the correct value', ->
        expect(@calc.Ny()).toEqual(-0.5)
    describe '#Ox', ->
      it 'should return the correct value', ->
        expect(@calc.Ox()).toEqual(0.5)
    describe '#Oy', ->
      it 'should return the correct value', ->
        expect(@calc.Oy()).toEqual(-0.5)
    describe '#Px', ->
      it 'should return the correct value', ->
        expect(@calc.Px()).toEqual(0.5)
    describe '#Py', ->
      it 'should return the correct value', ->
        expect(@calc.Py()).toEqual(-0.5)
    describe '#Qx', ->
      it 'should return the correct value', ->
        expect(@calc.Qx()).toEqual(-0.4)
    describe '#Qy', ->
      it 'should return the correct value', ->
        expect(@calc.Qy()).toEqual(-0.5)
    describe '#Rx', ->
      it 'should return the correct value', ->
        expect(@calc.Rx()).toEqual(-0.4)
    describe '#Ry', ->
      it 'should return the correct value', ->
        expect(@calc.Ry()).toEqual(0)

    describe '#inertiaBase', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaBase(), 8).toEqual(0.06666667)
    describe '#inertiaFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaFlange(), 8).toEqual(0.00813333)
    describe '#inertiaEdge', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaEdge(), 8).toEqual(0.003225)
    describe '#inertiaIy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.inertiaIy(), 8).toEqual(0.078025)
    describe '#staticMomentLip', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentLip(), 8).toEqual(0.00023833)
    describe '#staticMomentSy0', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy0(), 8).toEqual(0.0070)
    describe '#staticMomentFlange', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentFlange(), 8).toEqual(0.00479531)
    describe '#staticMomentSy', ->
      it 'should return the correct values', ->
        expectRounded(@calc.staticMomentSy(), 8).toEqual(0.01006729)

    describe 'thrustCenterX', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterX()).toEqual(-0.129)
    describe 'thrustCenterY', ->
      it 'should return the correct values', ->
        expectRounded(@calc.thrustCenterY()).toEqual(0)
