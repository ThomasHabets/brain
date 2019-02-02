# Brain

Copyright Thomas Habets <thomas@habets.se> 2016-2017

## License

All data is [CC BY](LICENSE.data.md). Data is all files in this
project named `.obj` and `.inc` that are solely 3D models.

All code is [GPLv3](LICENSE.code.md). Code is all files in this
project with extensions like `.cc`, `.py`, `.hs`, etc… and also
`.pov`.

## Make normals

These are a function of the 3D model, so not checked in.

### Python version

```
for i in lh rh; do
  python tools/makenormal.py  data/${i}_vertices.inc data/${i}_faces.inc > data/${i}_normals.inc
done
```

### Haskell version

```
ghc tools/MakeNormal.hs
for i in lh rh; do
  tools/MakeNormal \
      data/${i}_vertices.inc \
      data/${i}_faces.inc \
      data/${i}_normals.inc
done
```

## Render

```
povray brainspin.ini
```

## Assemble video

```
avconv -framerate 60 -f image2 -i brainspin%03d.png -b 65536k brainspin.mp4
```

## Convert to STL and 3D-print

### Convert to .OBJ

```
tools/make_obj.sh data/lh
tools/make_obj.sh data/rh
```

### Convert from .OBJ to .STL

* http://www.greentoken.de/onlineconv/
* https://www.makexyz.com/convert/obj-to-stl

## 3D Print

Shapeways accepts `.OBJ` files, so you don't have to convert to STL
first.

## How the 3D model was created

### 1. Get MRI scan

### 2. Use FreeSurfer to convert from `IMA` to `nii`

```
# Put data under ~/scandir/media
export FREESURFER_HOME=$HOME/scandir/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=$HOME/scandir/media
mri_convert \
    --in_type siemens
    media/XXXXXX/XXXXX_2016XXXX_XXXXXX_XXXXXX/T1W_3D_1_0022/XXX.2016.XX.XX.XX.XX.XX.XXXX.XXXX.IMA blaha.nii.gz
export SUBJECTS_DIR=$(pwd)/subjects
```

### 3. Convert from `nii` to… stuff (takes a few hours)

```
recon-all -i blaha.nii.gz -s bert -all
```

The relevant files are now in "surf" format as:
* `subjects/bert/surf/lh.pial`
* `subjects/bert/surf/rh.pial`

### 4. Convert from `.pial` to a text format.

```
cd freesurfer/matlab
octave
octave> [v,f] = freesurfer_read_surf("/…/subjects/bert/surf/rh.pial");
octave> save "rh.face" f
octave> save "rh.vec" v
[… and same for lh.pial …]
octave> exit
```

### 5. Convert from that text format to POVRay compatible-ish:

```
RE='s/^\s+/</;s/$/>,/;s/ +/,/g'
grep -v \# rh.vec | sed -r "${RE}" > rh_vertices.inc
grep -v \# lh.vec | sed -r "${RE}" > lh_vertices.inc
grep -v \# rh.face | sed -r "${RE}" > rh_faces.inc
grep -v \# lh.face | sed -r "${RE}" > lh_faces.inc
```
