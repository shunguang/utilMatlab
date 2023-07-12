function passportPhoto_print_out_4inx6in

p ='C:\Users\wus1\Projects\0wus1-personal\important_family_Docs\VisasAndPassport\PassportApply2023';
f1 = [p, '\zwu3.png'];
fout = [p, '\zach-international-driver-print-4inx6in.jpg'];

I0 = imread(f1);

[m,n,k] = size(I0);
if(m ~= n )
    k = min(m,n);
    I0 = I0(1:k,1:k,:);
end

I = zeros(2*m, 3*m,3);

I = [I0,I0,I0;
     I0,I0,I0];
imwrite(I,fout, 'jpg', 'Quality', 100 );
 
