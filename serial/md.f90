subroutine init(pos, vel, natom, xmin, xmax, ymin, ymax, vmin, vmax)
    implicit none
    integer            :: natom
    !f2py intent(in) natom
    real*8             :: pos(natom, 2), vel(natom, 2)
    !f2py intent(out) pos, vel
    !f2py depend(natom) pos
    !f2py depend(natom) vel
    real*8             :: xmin, xmax, ymin, ymax
    !f2py intent(in) xmin, xmax, ymin, ymax
    real*8             :: vmin, vmax
    !f2py intent(in) vmin, vmax

    call random_number(pos(:, :))
    pos(:, 1) = (pos(:, 1)-.5d0) * (xmax - xmin) + (xmax + xmin) / 2.d0
    pos(:, 2) = (pos(:, 2)-.5d0) * (ymax - ymin) + (ymax + ymin) / 2.d0

    call random_number(vel(:, :))
    vel(:, :) = (vel(:, :)-.5d0) * (vmax - vmin) + (vmax + vmin) / 2.d0

end subroutine

subroutine calculate_force(pos, natom, force)
    implicit none
    integer            :: natom
    !f2py intent(in) natom
    real*8             :: pos(natom, 2)
    !f2py intent(in) pos
    !f2py depend(natom) pos
    real*8             :: force(natom, 2)
    !f2py intent(out) force
    !f2py depend(natom) force

    integer            :: i, j

    force = 0.d0
    do i = 1, natom
        do j = i+1, natom
            force(i, :) = force(i, :) + (pos(i, :) - pos(j, :)) / &
                          dsqrt((pos(i, 1) - pos(j, 1))**2+(pos(i, 2) - pos(j, 2))**2)**3
        end do
    end do
end subroutine


subroutine move_atom(pos, vel, force, natom)
    implicit none
    integer            :: natom
    !f2py intent(in) natom
    real*8             :: pos(natom, 2)
    !f2py intent(in,out) pos
    !f2py depend(natom) pos
    real*8             :: vel(natom, 2)
    !f2py intent(in,out) vel
    !f2py depend(natom) vel
    real*8             :: force(natom, 2)
    !f2py intent(in) force
    !f2py depend(natom) force

    vel(:, :) = vel(:, :) + force(:, :)
    pos(:, :) = pos(:, :) + vel(:, :)
end subroutine
