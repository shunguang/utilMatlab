function gen_RMS_latex_tab1

FNs = cell(16,1);

FNs{1} = 'RMS-rotate_circle1.MAT'; 
FNs{2} = 'RMS-rotate-line1.MAT';    
FNs{3} = 'RMS-fixed-circle1.MAT';   
FNs{4} = 'RMS-fixed-line1.MAT';     

FNs{5} = 'RMS-rotate_circle2.MAT';
FNs{6} = 'RMS-rotate-line2.MAT';    
FNs{7} = 'RMS-fixed-circle2.MAT';   
FNs{8} = 'RMS-fixed-line2.MAT';     

FNs{9} = 'RMS-rotate_circle3.MAT';  
FNs{10} = 'RMS-rotate-line3.MAT';    
FNs{11} = 'RMS-fixed-circle3.MAT';   
FNs{12} = 'RMS-fixed-line3.MAT';

FNs{13} = 'RMS-rotate_circle4.MAT';  
FNs{14} = 'RMS-rotate-line4.MAT';
FNs{15} = 'RMS-fixed-circle4.MAT';   
FNs{16} = 'RMS-fixed-line4.MAT';

coloumn1 = cell(19,1);

coloumn1{1} ='x_c';       coloumn1{2} ='y_c';        coloumn1{3} ='\dot{x}_c';
coloumn1{4} ='\dot{y}_c'; coloumn1{5} ='\ddot{x}_c'; coloumn1{6} ='\ddot{y}_c';
coloumn1{7} ='r_1';
coloumn1{8} ='r_2';
coloumn1{9} ='r_3';
coloumn1{10} ='\theta_1';
coloumn1{11} ='\theta_2';
coloumn1{12} ='\theta_3';
coloumn1{13} ='\dot{r}_1';
coloumn1{14} ='\dot{r}_2';
coloumn1{15} ='\dot{r}_3';
coloumn1{16} ='\dot{\theta}_1';
coloumn1{17} ='\dot{\theta}_2';
coloumn1{18} ='\dot{\theta}_3';
coloumn1{19} ='R_c';

RMS =  zeros(19,16) ;
for i=1:16
    load( FNs{i} ) ;
    RMS(1:18,i) = average_x_RMS ;
    RMS(19,i)   = average_Rc_RMS ;
end

RMS = RMS/50;
for i=1:19
    fprintf('     %s', coloumn1{i});
    for j=1:8
        fprintf('%6.4f &', RMS(i,j) );
    end
    fprintf('\\ \n');
end
fprintf('%%%%%%%%%%%%%%%%%%%');
for i=1:19
    fprintf('     %s', coloumn1{i});
    for j=9:16
        fprintf('%6.4f &', RMS(i,j) );
    end
    fprintf('\\\n');
end

return
