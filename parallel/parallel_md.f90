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


subroutine calculate_force(pos, natom, part_start, part_finish, force)
    use mpi
    implicit none
    integer            :: natom
    !f2py intent(in) natom
    real*8             :: pos(natom, 2)
    !f2py intent(in) pos
    !f2py depend(natom) pos
    real*8             :: force(natom, 2)
    !f2py intent(out) force
    !f2py depend(natom) force
    integer            :: part_start, part_finish
    !f2py intent(in) part_start, part_finish

    integer            :: i, j

    integer             :: atom_per_procs, numprocs, ierr, rank
    real*8, allocatable :: sendbuf(:, :), recvbuf(:, :)


    force = 0.d0
    do i = part_start, part_finish
        do j = i+1, part_finish
            force(i, :) = force(i, :) + (pos(i, :) - pos(j, :)) / &
                          dsqrt((pos(i, 1) - pos(j, 1))**2+(pos(i, 2) - pos(j, 2))**2)**3
        end do
    end do

    call mpi_comm_size(mpi_comm_world, numprocs, ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    atom_per_procs = nint(dble(natom) / dble(numprocs))

    allocate(sendbuf(atom_per_procs, 2))
    allocate(recvbuf(numprocs*atom_per_procs, 2))
    sendbuf = force(part_start:part_finish, :)
    call mpi_gather(sendbuf, atom_per_procs*2, mpi_double_precision, recvbuf, &
                    atom_per_procs*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    call mpi_bcast(recvbuf, natom*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    force = recvbuf
    deallocate(sendbuf)
    deallocate(recvbuf)
    call mpi_barrier(mpi_comm_world, ierr)
end subroutine


subroutine move_atom(pos, vel, force, natom, part_start, part_finish)
    use mpi
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
    integer            :: part_start, part_finish
    !f2py intent(in) part_start, part_finish
    integer            :: i

    integer             :: atom_per_procs, numprocs, ierr, rank
    real*8, allocatable :: sendbuf(:, :), recvbuf(:, :)

    do i = part_start, part_finish
        vel(i, :) = vel(i, :) + force(i, :)
        pos(i, :) = pos(i, :) + vel(i, :)
    end do


    call mpi_comm_size(mpi_comm_world, numprocs, ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)
    atom_per_procs = nint(dble(natom) / dble(numprocs))

    allocate(sendbuf(atom_per_procs, 2))
    allocate(recvbuf(numprocs*atom_per_procs, 2))
    sendbuf = pos(part_start:part_finish, :)
    call mpi_gather(sendbuf, atom_per_procs*2, mpi_double_precision, recvbuf, &
                    atom_per_procs*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    call mpi_bcast(recvbuf, natom*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    pos = recvbuf
    deallocate(sendbuf)
    deallocate(recvbuf)
    allocate(sendbuf(atom_per_procs, 2))
    allocate(recvbuf(numprocs*atom_per_procs, 2))
    sendbuf = vel(part_start:part_finish, :)
    call mpi_gather(sendbuf, atom_per_procs*2, mpi_double_precision, recvbuf, &
                    atom_per_procs*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    call mpi_bcast(recvbuf, natom*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    vel = recvbuf
    deallocate(sendbuf)
    deallocate(recvbuf)
    call mpi_barrier(mpi_comm_world, ierr)
end subroutine
