function myPrintMatrix(myString, x)

[nr,nc]= size(x) ;
fprintf( '%s \n', myString );

if nr>1 & nc==1  % 1 column vector, output as one row 
    for i=1:nr
        fprintf( '%4.2g ', x(i,1) ) ;
    end
    fprintf('\n');
else            % 1 row vector or matrix
    for i=1:nr
        for j=1:nc
            fprintf( '%4.2g ', x(i,j) ) ;
        end
        fprintf('\n');
    end
end
return
