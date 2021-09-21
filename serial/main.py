from numpy import f2py
import numpy as np
import time
# compile module
with open("md.f90") as sourcefile:
    sourcecode = sourcefile.read()
f2py.compile(sourcecode, modulename='md', extension='f90', source_fn='md.f90', extra_args='')
import md


start = time.time()

nstep = 100
natom = 10000

pos = np.zeros((natom, 2), 'd')
vel = np.zeros((natom, 2), 'd')
force = np.zeros((natom, 2), 'd')

pos, vel = md.init(natom, 0, 100, 0, 100, -1, 1)

for i in range(nstep):
    print(i)
    force = md.calculate_force(pos, natom)
    md.move_atom(pos, vel, force, natom)

finish = time.time()

print(finish-start)
