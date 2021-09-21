program main
    use mpi
    implicit none
    integer, parameter  :: nstep=100
    integer, parameter  :: natom=256000
    real*8              :: pos(natom, 2), vel(natom, 2)
    real*8              :: force(natom, 2)
    integer             :: i
    real*8              :: start, finish

    integer             :: ierr, numprocs, rank
    integer             :: atom_per_procs
    integer             :: part_start, part_finish

    call mpi_init(ierr)
    call mpi_comm_size(mpi_comm_world, numprocs, ierr)
    call mpi_comm_rank(mpi_comm_world, rank, ierr)

    if (rank == 0) then
        call cpu_time(start)
    end if

    atom_per_procs = nint(dble(natom) / dble(numprocs))

    if (rank == 0) then
        call init(pos, vel, natom, 0.d0, 100.d0, 0.d0, 100.d0, -1.d0, 1.d0)
    end if

    call mpi_bcast(pos, natom*2, mpi_double_precision, 0, mpi_comm_world, ierr)
    call mpi_bcast(vel, natom*2, mpi_double_precision, 0, mpi_comm_world, ierr)

    part_start = rank * atom_per_procs+1
    part_finish = (rank+1) * atom_per_procs

    call mpi_barrier(mpi_comm_world, ierr)

    do i = 1, nstep
        call calculate_force(pos, natom, part_start, part_finish, force)
        call move_atom(pos, vel, force, natom, part_start, part_finish)
    end do

    if (rank == 0) then
        call cpu_time(finish)
        write(*, *) finish-start
    end if

    call mpi_finalize(ierr)
end program
