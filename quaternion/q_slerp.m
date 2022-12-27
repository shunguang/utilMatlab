function [qc] = q_slerp(qa, qb, t)
%qa,qb, 4 x 1,
%qc, 4 x 1

qa = q_normalization( qa ) ;
qb = q_normalization( qb ) ;

theta = acos(qa' * qb) ;  %dot product
if theta < 1e-10
    qc = (qa+qb)/2 ;
else
    qc = (1/sin(theta))* ( sin( (1-t)*theta ) * qa + sin(t*theta) * qb ) ;
end
qc = q_normalization( qc ) ;
%eof
