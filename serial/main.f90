program main
    implicit none
    integer, parameter :: nstep=100
    integer, parameter :: natom=102400
    real*8             :: pos(natom, 2), vel(natom, 2)
    real*8             :: force(natom, 2)
    integer            :: i
    real*8             :: start, finish

    call cpu_time(start)
    call init(pos, vel, natom, 0.d0, 100.d0, 0.d0, 100.d0, -1.d0, 1.d0)
    
    do i = 1, nstep
        write(*, *) i
        call calculate_force(pos, natom, force)
        call move_atom(pos, vel, force, natom)
    end do
    call cpu_time(finish)

    write(*, *) finish-start
end program
