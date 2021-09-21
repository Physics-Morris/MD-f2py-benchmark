from random import random
import numpy as np
import time

def init(natom, xmin, xmax, ymin, ymax, vmin, vmax):
    pos = np.zeros((natom, 2), 'd')
    vel = np.zeros((natom, 2), 'd')
    for i in range(natom):
        pos[i, 0] = random()
        pos[i, 1] = random()
        pos[i, :] = (pos[i, :]-.5) * (xmax - xmin) + (xmax + xmin) / 2.

        vel[i, 0] = random()
        vel[i, 1] = random()
        vel[i, :] = (vel[i, :]-.5) * (vmax - vmin) + (vmax + vmin) / 2
    return pos, vel

def calculate_force(pos, natom):
    force = np.zeros((natom, 2), 'd')
    for i in range(natom):
        for j in range(i+1, natom):
            force[i, :] = force[i, :] + (pos[i, :] - pos[j, :]) / \
                          np.sqrt((pos[i, 0] - pos[j, 0])**2+(pos[i, 1] - pos[j, 1])**2)**3
    return force

def move_atom(force, natom):
    global pos, vel
    vel[:, :] = vel[:, :] + force[:, :]
    pos[:, :] = pos[:, :] + vel[:, :]


start = time.time()

nstep = 100
natom = 1600

pos, vel = init(natom, 0, 100, 0, 100, -1, 1)

for i in range(nstep):
    print(i)
    force = calculate_force(pos, natom)
    move_atom(force, natom)

finish = time.time()

print(finish-start)
