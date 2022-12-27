syms c1 s1 c2 s2 c3 s3 ;

Rx = [1 0  0;
      0 c1 -s1;
      0 s1 c1];
Ry = [c2   0 s2 ;
      0    1  0 ;
      -s2   0  c2];
Rz =[ c3 -s3 0;
    s3  c3 0;
    0    0 1];
    
R=Rz*Ry*Rx



  
