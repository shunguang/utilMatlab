%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function name:  wu_doublefactorial
%description:    x = n!!
%
%function call:  nonen
%
%reference:     http://mathworld.wolfram.com/DoubleFactorial.html
%
%author:         S. Wu,                        08/01/02
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function x = wu_doublefactorial(n)

if n<-2
    x=-1 ;
    disp(' doubleFacterial(): sth wrong!');
    return ;
end

if n==0 | n== -1
    x = 1 ;
    return;
end

x=1 ;
if mod(n,2) == 0   % n is even
    for i = n:-2:2
        x = x*i;
    end
else               %n is order
    for i = n:-2:1
        x = x*i;
    end
end
return ;
