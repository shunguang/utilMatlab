function myPrintMatrix( myString, x, formatFlag)
%---------------------------------------------------
% myPrintMatrix( myString, x, formatFlag)
% myString,   a string to display
% x,          M x N, the array will be printed 
% formatFlag, 1 x 1, 1 - double pricision
%                    2 - 5 digital pricision
%                    3 - 1 digial  pricision
% S.Wu   08/02/03
%---------------------------------------------------

if nargin < 3
    formatFlag = 1 ;  % 1 - double pricision
                      % 2 - 5 digital pricision
                      % 3 - 1 digial  pricision
end
[nr,nc]= size(x) ;
fprintf( '%s \n', myString );


if nr>1 & nc==1  % 1 column vector, output as one row 
    for i=1:nr
        if formatFlag == 1
            fprintf( '%14.11e ', x(i,1) ) ;
        elseif  formatFlag == 2
            fprintf( '%12.6f ', x(i,1) ) ;
        elseif  formatFlag == 3
            fprintf( '%7.1f ', x(i,1) ) ;
        end
    end
    fprintf('\n');
else            % 1 row vector or matrix
    for i=1:nr
        for j=1:nc
            if formatFlag == 1
                fprintf( '%14.11e ', x(i,j) ) ;
            elseif  formatFlag == 2
                fprintf( '%12.6f ', x(i,j) ) ;
            elseif  formatFlag == 3
                fprintf( '%7.1f ', x(i,j) ) ;
            end
        end
        fprintf('\n');
    end
end
return
