#declare brain_left_hemisphere = object {
 mesh2 {
   normal_vectors {
     133350,
     <1,0,0>,
     #include"data/lh_normals.inc"
   }
   vertex_vectors {
     133350,
     <0,0,0>,
     #include"data/lh_vertices.inc"
   }
   face_indices {
     266694,
     #include"data/lh_faces.inc"
   }
   texture {
     pigment {
       color rgb<1,0,1>
     }
   }
 }
 rotate <-90,0,0>
 scale <-1,1,1>
}

#declare brain_right_hemisphere = object {
 mesh2 {
   normal_vectors {
     133019,
     <1,0,0>,
     #include"data/rh_normals.inc"
   }
   vertex_vectors {
     133019,
     <0,0,0>,
     #include"data/rh_vertices.inc"
   }
   face_indices {
     266032,
     #include"data/rh_faces.inc"
   }
   texture {
     pigment {
       color rgb<0,1,0>
     }
   }
 }
 rotate <-90,0,0>
 scale <-1,1,1>
}

#declare brain = union {
  object { brain_right_hemisphere }
  object { brain_left_hemisphere }
}
