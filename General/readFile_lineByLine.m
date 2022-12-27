function xF2f = readF2f( fileName )
%---------------------------------------
%xF2f, n x 7, 
%      col 1, frame number Id
%      cols 2 to 7, affine parameters
%---------------------------------------
nFrames = 1000;  
xF2f = zeros(nFrames, 7);
affineParams = zeros(1,6);
k=0; %current frame id

fid=fopen( fileName );
while 1
    %read the frame number and nPairs
    tline = fgetl(fid);
    if ~ischar(tline)
        break
    end
    x = getNumsFromLine(tline, 2);
    fn = x(1);
    nPairs = x(2);
    
    %------------------------
    %read the pairs info, dischare it
    for i=1:nPairs
        tline = fgetl(fid);
    end
    %read frame number in front of affine matrix, dischare it
    tline = fgetl(fid);
    %read affine matrix tiltle line, discharge it
    tline = fgetl(fid);
    %------------------------
    
    %read the affine matrix
    tline1 = fgetl(fid); 
    tline2 = fgetl(fid);
    tline = fgetl(fid);
    tline = fgetl(fid);

    x1 = getNumsFromLine(tline1, 4);    
    x2 = getNumsFromLine(tline2, 4);   
    
    %put affine into return array
    affineParams(1) = x1(1);
    affineParams(2) = x1(2); 
    affineParams(3) = x1(4);
    affineParams(4) = x2(1);
    affineParams(5) = x2(2);
    affineParams(6) = x2(4);
    
    k=k+1;
    xF2f(k,1) = fn;
    xF2f(k,2:7) = affineParams;
    %loop for next frame
end
fclose(fid);

if k<nFrames
    xF2f(k+1:nFrames, :) = [];
end
