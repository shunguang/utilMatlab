%function jacobiHRR
clear all
syms xc yc dxc dyc ddxc ddyc r_i theta_i d_theta dd_theta;  % state variables
syms xr yr dxr dyr; % radar position and velocity 

%function [xc, yc, dxc, dyc, ddxc, ddyc, r, theta, d_theta, dd_theta, ...
%        Rc, d_Rc, theta_c, d_theta_c, c, s]  = EzNotation(x)  

Rc = sqrt((xc-xr)^2 + (yc-yr)^2) ;
theta_c = atan((yc-yr)/(xc-xr)) ;

% compute d_Rc
d_Rc_xc = diff(Rc, xc);
d_Rc_yc = diff(Rc, yc);
d_Rc_xr = diff(Rc, xr);
d_Rc_yr = diff(Rc, yr);
d_Rc = simple(d_Rc_xc * dxc + d_Rc_yc *dyc + d_Rc_xr * dxr + d_Rc_yr *dyr) ;

% compute d_theta_c
d_theta_c_xc = diff(theta_c, xc);
d_theta_c_yc = diff(theta_c, yc);
d_theta_c_xr = diff(theta_c, xr);
d_theta_c_yr = diff(theta_c, yr);
d_theta_c = simple(d_theta_c_xc * dxc + d_theta_c_yc *dyc + d_theta_c_xr * dxr + d_theta_c_yr *dyr) ;

fprintf('Rc=\n');
pretty( collect(Rc) )
fprintf('theta_c=\n');
pretty( theta_c )

fprintf('d_Rc=\n');
pretty( d_Rc )
fprintf('d_theta_c=\n');
pretty( d_theta_c )

% measurement eqs. of HRR
h1 = Rc + r_i*cos(theta_i - theta_c ) ;
h2 = d_Rc - r_i*sin(theta_i - theta_c)*(d_theta - d_theta_c) ;
h3 = Rc ;
h4 = d_Rc ;
h5 = theta_c ;

% compute the jacobian of HRR
Hx = simple(jacobian([h1;h2;h3;h4;h5], [xc yc dxc dyc ddxc ddyc r_i theta_i d_theta dd_theta] ));
fprintf('the jacobian of HRR \n') ;
for i=1:5
    for j=1:10
        if Hx(i,j) ~= sym('0')
            fprintf('Hx(%2d,%2d)=',i,j);
            tmp = simple(Hx(i,j)) ;
            tmp
            pretty(Hx(i,j))
        end
    end
end

pause

%compute the Hessian matrix
fprintf('the Hessian of HRR \n') ;
for k=1:3
    for i=1:10
        hxx{k}(i,:) = simple(jacobian([Hx(k,i)], [xc yc dxc dyc ddxc ddyc r_i theta_i d_theta dd_theta] )) ;
    end
end

for k=1:3
    for i=1:10
        for j=1:10
            if hxx{k}(i,j) ~= sym('0')
                fprintf('hxx{%1d}(%2d,%2d)=\n',k,i,j);
                hxx{k}(i,j)
            end
        end
    end
end

return
