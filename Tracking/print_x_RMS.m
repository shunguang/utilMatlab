function print_x_RMS( msgStr, average_x_RMS ) 
global gn_beg_r   gn_end_r ; % the begining position of radii
global gn_beg_eta gn_end_eta ; % the begining position of radii
global gn_beg_xi  gn_end_xi ; % the begining position of radii

fprintf('%s\n', msgStr );
        
fprintf('RMS global:' );
for j=1:3
    fprintf('%10.5f ', average_x_RMS(j) ); 
end
fprintf('\n           ' );
for j=4:6
    fprintf('%10.5f ', average_x_RMS(j) ); 
end
fprintf('\n           ' );
for j=7:9
    fprintf('%10.5f ', average_x_RMS(j) ); 
end
        
fprintf('\n RMS r_i:' );
for j=gn_beg_r:gn_end_r
    fprintf('%10.5f ', average_x_RMS(j)); 
end
        
fprintf('\n RMS eta_i:' );
for j=gn_beg_eta:gn_end_eta
    fprintf('%10.5f ', average_x_RMS(j)); 
end

fprintf('\n RMS xi_i:' );
for j=gn_beg_xi:gn_end_xi
    fprintf('%10.5f ', average_x_RMS(j)); 
end

return

