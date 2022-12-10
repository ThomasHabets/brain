#!/usr/bin/python3
#
# Ugly script to merge left and right half, and rotate to work with
# https://modelviewer.dev/
#
import math

def rotate(line):
    if not line or line[0] != 'v':
        return line
    y,z = [float(x) for x in line[2:]]
    angle = -math.pi/2
    y2 = y*math.cos(angle) - z*math.sin(angle)
    z2 = y*math.sin(angle) + z*math.cos(angle)
    return [line[0], line[1], str(y2), str(z2)]

def inc(line, vinc):
    if line[0] != 'f':
        return line
    inds = [int(x)+vinc for x in line[1:]]
    return line[0], *['%d//%d' % (x,x) for x in inds]

def read(fn, vinc=0):
    return [inc(rotate(x.strip('\n ').split(' ')), vinc) for x in open(fn) if x[0] not in 'gs']

def main():
    lh = read('data/lh_object.obj')
    lhvs = len([x for x in lh if x[0] == 'v'])
    rh = read('data/rh_object.obj', vinc=lhvs)
    print('s 1\ng model\ns 1\n')
    print('\n'.join([' '.join(x) for x in lh if x[0] == 'v']))
    print('\n'.join([' '.join(x) for x in rh if x[0] == 'v']))
    print('\n'.join([' '.join(x) for x in lh if x[0] == 'vn']))
    print('\n'.join([' '.join(x) for x in rh if x[0] == 'vn']))
    print('\n'.join([' '.join(x) for x in lh if x[0] == 'f']))
    print('\n'.join([' '.join(x) for x in rh if x[0] == 'f']))

if __name__ == '__main__':
    main()
