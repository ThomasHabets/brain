// brainspin.pov — Brain spinning
//
// https://github.com/ThomasHabets/brain
//
// Copyright (C) 2017 Thomas Habets <thomas@habets.se>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
#version 3.7;
#include "data/brain.inc"

global_settings {
  assumed_gamma 1.4
  ambient_light rgb<0,0,0>
}

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
