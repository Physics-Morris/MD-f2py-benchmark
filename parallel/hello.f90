subroutine sayhello(comm)
    use mpi
    implicit none
    integer :: comm, rank, numprocs, ierr
    !f2py intent(in) comm
    call MPI_Comm_size(comm, numprocs, ierr)
    call MPI_Comm_rank(comm, rank, ierr)
    print *, 'Hello, World! I am process ', rank, ' of ', numprocs
end subroutine sayhello

subroutine calculate_sum(start, finish, ans)
    implicit none
    integer :: start, finish, ans
    !f2py intent(in) start, finish
    !f2py intent(out) ans
    integer :: i

    ans = 0
    do i = start, finish
        ans = ans + i
    end do
end subroutine
