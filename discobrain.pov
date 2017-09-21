#version 3.7;

//
// Conditionals
//

#declare rad = 0;

//
// Includes.
//

#if (rad)
  #include "rad_def.inc"
#end
#include "data/brain.inc"

//
// Global settings
//

global_settings {
  #if (rad)
    radiosity { Rad_Settings(Radiosity_Normal, on, off)  }
  #end

  assumed_gamma 1.4
  ambient_light rgb<0,0,0>
}

//
// Brain
//

object {
  brain
  texture {
    pigment {
      color rgb<1,1,1>
    }
  }
  rotate <0,360*clock,0>
}

//
// Lights
//

#declare light_mul = -2;
#declare light_red = light_mul*clock*360;
#declare light_green = (light_mul*clock*360)+120;
#declare light_blue = (light_mul*clock*360)+240;

light_source {
  <0,0,-150>, rgb<1,0,0>
  rotate <0, light_red, 0>
}
light_source {
  <0,0,-150>, rgb<0,1,0>
  rotate <0, light_green, 0>
}

light_source {
  <0,0,-250>, rgb<0,0,1>
  rotate <0, light_blue, 0>
}

//
// Camera
//

camera {
  right x * 3840 / 2160
  location <0,0,-200>
  look_at <0,0,0>
}
