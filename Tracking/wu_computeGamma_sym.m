%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function name:  wu_computeGamma_sym( measDim )
%description:    Using the matlab symbolic function int() to compute
%                the gate probability.
%reference:      S.S. Blackman, Multiple target tracking with radar 
%                applications, Artech House, Norwood, NJ.,1986
%
%author:         S. Wu,               08/01/02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% x -- the gamma we wanted 
%
function wu_computeGamma_sym( measDim )
syms z m zero x real;
syms Pg real;

m = sym(measDim);
A = 1/( 2^(m/2) * gamma(m/2) ) ;

f = A*z^(m/2-1)* exp(-z/2) ;

zero = sym('0') ;

g = simple(int(f,z,zero,x)) ;

y = Pg - (g)
%latex(g);

return