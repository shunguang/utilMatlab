function sym_file_transfer(file_name1, file_name2)
%--------------------------------------------------------
% sym_file_transfer(file_name1, file_name2)
% transfer the symbolic results into matlab functions
%--------------------------------------------------------
fid1 = fopen(file_name1,'r') 

fid2 = fopen(file_name2,'w') 

mySemicolo = ';' ;
while 1 
    % read 4 lines each time
    line1 = fgetl(fid1);
    if line1 == -1
        break;
    end
    line2 = fgetl(fid1);
    line3 = fgetl(fid1);
    line4 = fgetl(fid1);
    line5 = fgetl(fid1);
%pause
    % write to the new file
    fprintf(fid2,'%s', line1);
    fprintf(fid2,'%s %c\n', line4, mySemicolo);
end

fclose(fid1);
fclose(fid2);
return
