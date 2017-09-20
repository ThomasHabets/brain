for i in lh rh:
  python makenormal.py  data/${i}_vertices.inc data/${i}_faces.inc > data/${i}_normals.inc
  python makenormal.py  data/${i}_vertices.inc data/${i}_faces.inc > data/${i}_normals.inc

