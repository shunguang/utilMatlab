%=========================================================
% insideFlag = IsInsideTrangle( V, c)
% description: this function judages if pt c is inside a 
%              triangle defined by three vertexes V.
% input        V, 2 x 3, three vertexes points 
%              c, 2 x 1, a point
% wrttien by:  S. Wu, 03/25/03
%=========================================================
% inside test
% function main
% V = [ 0  -1   1;
%      1  0    0];
% c = [1; 1.0001];
% IsInsideTrangle( V, c)
% return

function insideFlag = IsInsideTrangle( V, c)
% V, 2 x 3, three vertexes points 
% c, 2 x 1, a point
% this function judages if pt c is inside a triangle defined by three vertexes
% V.


% compute the distance from pt c to the three vertexes.
r = dist(c', V) ;

% compute the three side lenth
a = zeros(3,1) ;
for i=1:3
    j=i+1;
    if j>3
        j=1;
    end
    a(i) =  sqrt( sum( (V(:,i) - V(:,j)).^2 ) ) ;
end

% compute the total and three triangle's area inside
totalArea = areaTriangle( a ) + eps ;

insideFlag =  1 ;
subArea = 0 ;
for i=1:3
    j=i+1 ;
    if j>3
        j=1 ;
    end
    subArea = subArea + areaTriangle( [r(i), r(j),a(i)] ) ;
    if subArea > totalArea    % not inside
%        disp('sdf');
        insideFlag = 0 ;
        break;
    end
end
return


function  Area = areaTriangle( a )
% a -  3x1, the lengthes of  three sides
s = ( a(1) + a(2) + a(3) ) / 2 ;
Area = sqrt(s*(s-a(1))*(s-a(2))*(s-a(3))) ;
return