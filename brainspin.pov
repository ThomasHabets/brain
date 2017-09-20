#include "data/brain.inc"

object {
  brain
  rotate <0,360*clock,0>
}

light_source {
  <40,0,-200>
  color rgb<1,1,1>
}

camera {
  right x * 3840 / 2160
  location <0,0,-200>
  look_at <0,0,0>
}
