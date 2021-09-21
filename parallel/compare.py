import matplotlib.pyplot as plt
import matplotlib as mpl
import numpy as np
from pylab import cm

mpl.rcParams['font.family'] = 'STIXGeneral'
plt.rcParams['xtick.labelsize'] = 18
plt.rcParams['ytick.labelsize'] = 18
plt.rcParams['font.size'] = 18
plt.rcParams['figure.figsize'] = [9, 4]
plt.rcParams['axes.titlesize'] = 20
plt.rcParams['axes.labelsize'] = 20
plt.rcParams['lines.linewidth'] = 3
plt.rcParams['lines.markersize'] = 8
plt.rcParams['legend.fontsize'] = 17
plt.rcParams['mathtext.fontset'] = 'stix'
plt.rcParams['axes.linewidth'] = 1

plt.style.use('dark_background')

colors = cm.get_cmap('Set1', 9)

fig = plt.figure()
ax = fig.add_subplot(1, 1, 1)

ax.xaxis.set_tick_params(which='major', size=5, width=1,
                         direction='in', top='on')
ax.xaxis.set_tick_params(which='minor', size=3, width=1,
                         direction='in', top='on')
ax.yaxis.set_tick_params(which='major', size=5, width=1,
                         direction='in', right='on')
ax.yaxis.set_tick_params(which='minor', size=3, width=1,
                         direction='in', right='on')

NP, fortran, f2python = np.loadtxt('runtime.dat', unpack=True)

ax.bar(np.log2(NP)-.1, fortran, color=colors(1), width=.2, label='fortran')
ax.bar(np.log2(NP)+.1, f2python, color=colors(2), width=.2, label='f2py')

ax.set_yscale('log')
ax.set_xticks(np.log2(NP))
ax.set_xticklabels([1000, 2000, 4000, 8000, 16000, 32000, 64000, 128000, 256000])
ax.set_xlabel('Number of particles')
ax.set_ylabel('CPU time [s]')
ax.set_title('2D Parallel Molecular Dynamcis, 100 steps')
# ax.set_title('gfortran 9.3.0, flags = -Wall -g -fno-second-underscore -fPIC -O3 -funroll-loops')
ax.legend()


plt.tight_layout()
plt.savefig('cpu_time_dark.png', dpi=1000, transparent=True)
plt.show()
