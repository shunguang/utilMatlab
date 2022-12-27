%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function name:  [S,V] = hyperSphere(n,r)
%description:    this function compute the surface area,S, and content,V, 
%                of the n-hypersphere with radius $r$.
%function call:  doublefactorial()
%
%reference:      http://mathworld.wolfram.com/Hypersphere.html
%
%author:         S. Wu,                        08/01/02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [S,V] = wu_hyperSphere(n,r)

if mod(n,2) == 0   % n is even
    S = ( 2 * pi^(n/2) ) / factorial( n/2-1) ;
else               %n is odd
    S = ( 2^((n+1)/2) * pi^((n-1)/2) ) / wu_doublefactorial(n-2) ;
end

V = S * r^n / n ;
return



