from mpi4py import MPI
from numpy import f2py
import ParallelMD as md
import numpy as np
import time

# f2py -c --f90exec=mpif90 parallel_md.f90 -m ParallelMD

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

if rank == 0: start = time.time()

nstep = 100
natom = 256000
atom_per_procs = int(natom / size)

pos = np.zeros((natom, 2), 'd')
vel = np.zeros((natom, 2), 'd')
force = np.zeros((natom, 2), 'd')

if rank == 0: pos, vel = md.init(natom, 0, 100, 0, 100, -1, 1)
comm.Bcast(pos, root=0)
comm.Bcast(vel, root=0)

part_start, part_finish = int(rank * (natom / size)), int((rank+1) * (natom / size) - 1)
comm.barrier()

for i in range(nstep):
    force = md.calculate_force(pos, natom, part_start+1, part_finish+1)
    md.move_atom(pos, vel, force, natom, part_start+1, part_finish+1)

finish = time.time()

if rank == 0: print(finish-start)
