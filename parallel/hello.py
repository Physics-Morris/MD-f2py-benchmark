from mpi4py import MPI
from numpy import f2py
import numpy as np
# import subprocess
# subprocess.run(['f2py', '-c', '--f90exec=mpif90', 'hello.f90', '-m', 'helloworld'])
import helloworld

comm = MPI.COMM_WORLD
numprocs = comm.Get_size()
rank = comm.Get_rank()

fcomm = MPI.COMM_WORLD.py2f()
helloworld.sayhello(fcomm)

start, finish = rank*100, (rank+1)*100
ans = helloworld.calculate_sum(start, finish)
# print(ans)

send_buf = np.zeros(1, dtype='i') + ans
final_ans = None
if rank == 0:
    final_ans = np.empty([numprocs, 1], dtype='i')
comm.Gather(send_buf, final_ans, root=0)

if rank == 0: print(final_ans)

if rank == 0:
    for i in range(numprocs):
        # assert np.allclose(final_ans[i,:], i)
        np.allclose(final_ans[i,:], i)
