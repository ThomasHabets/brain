#include "data/brain.inc"

// Spinning two-coloured brain.
union {
  object {
    brain_left_hemisphere
    texture { pigment { color rgb<1,0,1> } }
  }
  object {
    brain_right_hemisphere
    texture { pigment { color rgb<0,1,0> } }
  }
  rotate <0,360*clock,0>
}

light_source {
  <40,0,-200>, rgb<1,1,1>
}

camera {
  right x * 3840 / 2160
  location <0,0,-200>
  look_at <0,0,0>
}
