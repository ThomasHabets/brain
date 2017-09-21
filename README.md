## Make normals

These are a function of the 3D model, so not checked in.

```
for i in lh rh; do
  python makenormal.py  data/${i}_vertices.inc data/${i}_faces.inc > data/${i}_normals.inc
  python makenormal.py  data/${i}_vertices.inc data/${i}_faces.inc > data/${i}_normals.inc
done
```

## Render

## Assemble video

```
avconv -framerate 60 -f image2 -i brainspin%03d.png -b 65536k brainspin.mp4
```

## How the 3D model was created

```
# 1) Put data under ~/scandir/media
# 2) Use FreeSurfer to convert from IMA to nii
export FREESURFER_HOME=$HOME/scandir/freesurfer
source $FREESURFER_HOME/SetUpFreeSurfer.sh
export SUBJECTS_DIR=$HOME/scandir/media
mri_convert \
    --in_type siemens
    media/XXXXXX/XXXXX_2016XXXX_XXXXXX_XXXXXX/T1W_3D_1_0022/XXX.2016.XX.XX.XX.XX.XX.XXXX.XXXX.IMA blaha.nii.gz
export SUBJECTS_DIR=$(pwd)/subjects

# 3) Convert the nii file to… stuff (takes a few hours)
recon-all -i blaha.nii.gz -s bert -all

# The relevant files are now in "surf" format as:
# subjects/bert/surf/lh.pial
# subjects/bert/surf/rh.pial

# 4) Convert from .pial to a text format.
cd freesurfer/matlab
octave
octave> [v,f] = freesurfer_read_surf("/…/subjects/bert/surf/rh.pial");
octave> save "rh.face" f
octave> save "rh.vec" v
[… and same for lh.pial …]
octave> exit

# 5) Convert from that text format to POVRay compatible-ish:
RE='s/^\s+/</;s/$/>,/;s/ +/,/g'
grep -v \# rh.vec | sed -r "${RE}" > rh_vertices.inc
grep -v \# lh.vec | sed -r "${RE}" > lh_vertices.inc
grep -v \# rh.face | sed -r "${RE}" > rh_faces.inc
grep -v \# lh.face | sed -r "${RE}" > lh_faces.inc
```
