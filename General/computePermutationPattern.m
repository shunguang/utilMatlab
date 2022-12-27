%function main
%    x = computePermutationPattern(4)
%return
%=====================================================================
%  Function name : permutaion
%  Description:    ouput all the permutation patterns of n number
%  input:          n
%  output:         x(n!,8), all the permutation pattern
%
%  Written by:     S.Wu
%  date:           07/30/02                                          
%-------------------------------------------------------------------
%  Memo:   the program is n dependent.  current version for n=8
%          if n changed, need to modify the program.
%=====================================================================
function x = computePermutationPattern( n )

%t1 = cputime ;
switch n
    case 8
        x = permu8 ;
    case 7
        x = permu7 ;
    case 6
        x = permu6 ;
    case 5
        x = permu5 ;
    case 4
        x = permu4 ;
    case 3
        x = permu3 ;
    case 2
        x = permu2 ;
    otherwise
        fprintf('ERROR MSG: input para. is not correct, need to modify the program!\n') ;
end
%t2 = cputime ;
%m=size(x,1);
%fprintf( ' total # of permutations is %d,   cputime=%g', m, t2-t1); 
return


% ========================================================
%
%
% ========================================================
function x = permu8

n= 8
m = factorial(8);
x = zeros(m,8 ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
           
          for i4=1:n
          if ( i4~=i3 & i4~=i2 & i4~=i1 )
              
          for i5=1:n
          if ( i5~=i4 & i5~=i3 & i5~=i2 & i5~=i1 )
              
          for i6=1:n
          if ( i6~=i5 & i6~=i4 & i6~=i3 & i6~=i2 & i6~=i1 )

          for i7=1:n
          if ( i7~=i6 & i7~=i5 & i7~=i4 & i7~=i3 & i7~=i2 & i7~=i1 )
              
          for i8=1:n
          if ( i8~=i7 & i8~=i6 & i8~=i5 & i8~=i4 & i8~=i3 & i8~=i2 & i8~=i1 )
   %          fprintf('%d %d %d %d %d %d %d %d\n', i1, i2, i3,i4, i5, i6, i7, i8 ) ;
             x(m,:) = [i1 i2 i3 i4 i5 i6 i7 i8];   
             m=m+1 ;
          end
          end
       
          end
          end
       
          end
          end
       
          end
          end
          
          end
          end
          
       end
       end
    end
    end
end
return

% ========================================================
%
%
% ========================================================
function x = permu7

n= 7
m = factorial(n);
x = zeros(m,n ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
           
          for i4=1:n
          if ( i4~=i3 & i4~=i2 & i4~=i1 )
              
          for i5=1:n
          if ( i5~=i4 & i5~=i3 & i5~=i2 & i5~=i1 )
              
          for i6=1:n
          if ( i6~=i5 & i6~=i4 & i6~=i3 & i6~=i2 & i6~=i1 )

          for i7=1:n
          if ( i7~=i6 & i7~=i5 & i7~=i4 & i7~=i3 & i7~=i2 & i7~=i1 )
   %          fprintf('%d %d %d %d %d %d %d %d\n', i1, i2, i3,i4, i5, i6, i7, i8 ) ;
             x(m,:) = [i1 i2 i3 i4 i5 i6 i7];   
             m=m+1 ;
          end
          end
       
          end
          end
       
          end
          end
          
          end
          end
          
       end
       end
    end
    end
end
return

% ========================================================
%
%
% ========================================================
function x = permu6

n= 6 ;
m = factorial(n);
x = zeros(m,n ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
           
          for i4=1:n
          if ( i4~=i3 & i4~=i2 & i4~=i1 )
              
          for i5=1:n
          if ( i5~=i4 & i5~=i3 & i5~=i2 & i5~=i1 )
              
          for i6=1:n
          if ( i6~=i5 & i6~=i4 & i6~=i3 & i6~=i2 & i6~=i1 )
   %          fprintf('%d %d %d %d %d %d\n', i1, i2, i3,i4, i5, i6) ;
             x(m,:) = [i1 i2 i3 i4 i5 i6];   
             m=m+1 ;
         end
         end
     
          end
          end
       
          end
          end
          
       end
       end
    end
    end
end
return

% ========================================================
%
%
% ========================================================
function x = permu5

n= 5 ;
m = factorial(5);
x = zeros(m,5 ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
           
          for i4=1:n
          if ( i4~=i3 & i4~=i2 & i4~=i1 )
              
          for i5=1:n
          if ( i5~=i4 & i5~=i3 & i5~=i2 & i5~=i1 )
              
   %          fprintf('%d %d %d %d %d\n', i1, i2, i3,i4, i5) ;
             x(m,:) = [i1 i2 i3 i4 i5];   
             m=m+1 ;
          end
          end
       
          end
          end
          
       end
       end
    end
    end
end
return

% ========================================================
%
%
% ========================================================
function x = permu4

n= 4 ;
m = factorial(4);
x = zeros(m,4 ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
           
          for i4=1:n
          if ( i4~=i3 & i4~=i2 & i4~=i1 )
   %          fprintf('%d %d %d %d\n', i1, i2, i3,i4) ;
             x(m,:) = [i1 i2 i3 i4];   
             m=m+1 ;
          end
          end
          
       end
       end
       
    end
    end
end
return


% ========================================================
%
%
% ========================================================
function x = permu3

n= 3 ;
m = factorial(3);
x = zeros(m,n ) ;
m=1 ;
for i1=1:n
    
    for i2=1:n
    if (i2 ~=i1)        
        
       for i3=1:n
       if ( i3~=i2 & i3~=i1 )
   %          fprintf('%d %d %d %d %d\n', i1, i2, i3,i4, i5) ;
             x(m,:) = [i1 i2 i3];   
             m=m+1 ;
       end
       end
    end
    end
end
return

% ========================================================
%
%
% ========================================================
function x = permu2

n= 2 ;
m = factorial(2);
x = zeros(m,n ) ;
m=1 ;
for i1=1:n
    for i2=1:n
        if (i2 ~=i1)        
             x(m,:) = [i1 i2];   
             m=m+1 ;
        end
    end
end
return

