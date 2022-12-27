% =====================================================
% function:   computeRMS()
% objectives: compute RMS for one Montel Carlo run
% input:      x_true:     Nx x Npt
%             x_estimate: Nx x Npt
%
% output:     x_curRMS:  Nx x 1, currrent RMS 
%
% Author:     S. Wu,   09/01/02
% =====================================================
function [x_curRMS] = computeRMS( x_true, x_estimate,outputFlag )

% judge if x_true and x_estimate are the same dim

[Nx,Npt] = size(x_true) ;
[Nx1,Npt1] = size(x_estimate) ;

if( Nx ~= Nx1 | Npt ~= Npt1 )
    disp(' in computeRMS(): sth wrong!') ;
    pause ;
    return
end

% compute RMS

 d_x = x_estimate - x_true ;
 tmp = d_x .* d_x ;
 x_curRMS = sqrt( sum(tmp,2)/Npt ) ;

if lower(outputFlag(1:4)) == 'disp'
     for i=1:Nx
         fprintf('%9.4f', x_curRMS(i,1)); 
     end
end
return