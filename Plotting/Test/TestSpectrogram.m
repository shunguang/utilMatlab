function TestSpectrogram
close all;
clear all;

test1;
test2;

end

function test1
fx = 2.5e9;
fy = 1.6e9;
fs = 6e9;
nFFT = 32768*2;
cfg4Sp = CfgSpectrogram( ...
    'nImgCols', 1080, ...             %total time bins to maintain/display in the spectrogram image
    'fs',  6e9, ...                   %samping freq
    'nFFT', nFFT,...                  %# samples in freq. domain
    'nWinSize', nFFT,...              %32768 -- # of sample points to do the FFT
    'nWinStep', nFFT/4,...            %step size to move the window
    'winType', 'hamming', ...         %'hanning'
    'freqUnit', 'Hz', ...             %freq unit
    'timeUnit', 'Sec',...             %time unit
    'freqRngToPlot', [-3e9, 3e9] );

spFigId = 1;
sp = Spectrogram( cfg4Sp );
t1=0;
T0 = 1/fs;
dt = 1e-4;
while t1<0.01
    t2 = t1+dt-T0;
    t = (t1:T0:t2);
    x = exp(-1i*2*pi*fx*t);
    y = 10*exp(-1i*2*pi*fy*t);
    xIn = [real(x);imag(x);real(y);imag(y)];
    [four,n] = size(xIn);

    sp = sp.processSamples(xIn, t1);

    figTitle =['t0 =', num2str(t1), ', nCurrSamples=', num2str(n)];
    sp.updatePlot(figTitle, '', spFigId);

    %-----------------
    t1=t2+T0;
end
end


function test2
appSrc = getenv('CADDYSHACK_SRC');
if isempty(appSrc)
    appSrc = 'C:\Users\wus1\Projects\2022\caddyshack\src';
end
addpath(genpath(appSrc));

cfg = CfgSpectrogram( ...
    'nImgCols', 500, ...              %total time bins to maintain/display in the spectrogram image
    'fs',  44100, ...                 %samping freq
    'nFFT', 2048,...                  %# samples in freq. domain
    'nWinSize', 448,...               %# of sample points to do the FFT
    'nWinStep', 224,...               %step size to move the window
    'winType', 'hamming', ...         %'hanning'
    'freqUnit', 'Hz', ...             %freq unit
    'timeUnit', 'Sec',...             %time unit
    'freqRngToPlot', [10000, 20000] );

fpath = 'C:\Users\wus1\Projects\2022\caddyshack\dataset\birdSound\birds_after_rain.wav';
[Y, fs]=audioread(fpath);
[nTotalSamples, nChs ] = size(Y);
fprintf( 'nTotalSamples=%d, nChs=%d, fs=%d\n', nTotalSamples, nChs, fs);

%make a 4 x n matrix to simulate ccw data set
Y = [Y'; Y'];

sp = Spectrogram( cfg );
idx1 = 1;
while ( idx1 < nTotalSamples )
    nCurrSamples = randi([300,10*cfg.nWinSize],1);
    idx2 = idx1 + nCurrSamples;
    if idx2>nTotalSamples
        idx2=nTotalSamples;
    end

    x = Y(:, idx1:idx2);
    t0 =  (idx1-1)/cfg.fs;
    sp = sp.processSamples(x, t0);

    figTitle = ['t0 =', num2str(t0), ', nCurrSamples=', num2str(nCurrSamples)];
    saveToFile = '';  %sprintf('c:/temp/sp-color-%04d.png', idx1 );
    sp.updatePlot(figTitle, saveToFile, 1);

    %---next iteration ---
    idx1 = idx2+1;
end
end %function test2

