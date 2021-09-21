subroutine fib(a,n)
    !
    !    calculate first n fibonacci numbers
    !
    implicit none
    integer n, i
    real*8 a(n)
    !f2py intent(in) n
    !f2py intent(out) a
    !f2py depend(n) a
    do i=1,n
        if (i.eq.1) then
            a(i) = 0.0d0
        else if (i.eq.2) then
            a(i) = 1.0d0
        else 
            a(i) = a(i-1) + a(i-2)
        end if
    end do
end subroutine
