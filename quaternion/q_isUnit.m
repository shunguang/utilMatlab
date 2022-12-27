function [nFlag] = q_isUnit( q, myEps )
%=============================================================
% [nFlag] = q_isUnit( q, myEps )
% The objective: To judge if the input quaternion is unit 
% Input:
%        q      - 4 x 1, the coresponding quaternion
%        myEps  - 1 x 1, the tolerance number  
% Output:
%        nFlag  - 1 x 1, 1 is unit, 0 is not a unit quaternion
%-------------------------------------------------------------
% Note:   q is defined by q=[w,x,y,z]', i.e., q=w+xi+jy+zk
%-------------------------------------------------------------
% Reference:
% [0] http://www.cs.berkeley.edu/~laura/cs184/quat/quaternion.html
% [1] E.A. Coutsias and L. Romero, the quaternions with an application to rigid
%     Body dynamics, http://www.math.unm.edu/~vageli/papers/rrr.pdf
% [2] Graphics Gems II, pp. 351-354, pp. 377-380 
% [3] Hearn & Baker, Computer Graphics,  pp. 419-420 & pp. 617-618 
% [4] Ken Shoemake,  "Animating Rotation with Quaternion Curves", Computer Graphics V.19 N.3, 1985 
%-------------------------------------------------------------
% History: 1. the 1st version by   Shunguang Wu,  03/24/04
%          2. correct the errors of 1st version by S. Wu, 04/18/04 
%=============================================================

[q_mag] = q_magnitude(q) ;

nFlag = 0;
if abs(q_mag - 1 ) < myEps
    nFlag = 1 ;
end
  
return

