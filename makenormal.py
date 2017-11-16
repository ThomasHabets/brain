#!/usr/bin/python
# makenormal — Create normals out of vertices and faces.
#
# https://github.com/ThomasHabets/brain
#
# Copyright (C) 2017 Thomas Habets <thomas@habets.se>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
import math
import sys
import re

def main(vsi, fsi):
  vs = []
  for line in open(vsi):
    m = re.search(r'\s*<\s*([e\d.-]+)\s*,\s*([e\d.-]+)\s*,\s*([e\d.-]+)\s*>\s*,\s*\n', line)
    if not m:
      raise RuntimeError("failz on %s" % line)
    vs.append( [float(x) for x in m.groups()] )

  fs = []
  for line in open(fsi):
    m = re.search(r'\s*<\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*>\s*,\s*', line)
    if not m:
      raise RuntimeError("failz on faces")
    fs.append( [int(x) for x in m.groups()] )

  face_normals = []
  v_to_normals = {}
  for f in fs:
    v = [vs[x-1] for x in f]
    a = [v[0][x] - v[1][x] for x in range(3)]
    b = [v[0][x] - v[2][x] for x in range(3)]
    # cross
    n = [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0],
    ]
    l = math.sqrt(sum([x*x for x in n]))
    n = tuple([x/l for x in n])
    face_normals.append(n)
    for i in range(3):
      v_to_normals.setdefault(f[i], []).append(n)

  for i in sorted(v_to_normals.keys()):
    ns = v_to_normals[i]
    n = [
        sum([x[0] for x in ns]),
        sum([x[1] for x in ns]),
        sum([x[2] for x in ns]),
    ]
    l = math.sqrt(sum([x*x for x in n]))
    n = tuple([x/l for x in n])
    print "<%f,%f,%f>," % n

if __name__ == '__main__':
  main(*sys.argv[1:])
