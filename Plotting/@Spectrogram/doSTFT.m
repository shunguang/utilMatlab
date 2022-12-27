function [tfImg, lastProcessedDataPointIdx] = doSTFT(obj, hvFlag)
%----------------------------------------------
%intput:
%
%out:
%----------------------------------------------

%% check input data format: make x a 1-d row vector
[four,n] = size(obj.sampleBuffer);
assert(four==4, 'Spectrogram.doSTFT():, x must 4 x n matrix');
assert( n >= obj.cfg.nWinSize, 'Spectrogram.doSTFT():, # of smaples in x is too few!');
assert( 0 == mod(obj.cfg.nWinSize,2),  'only tested even cfg.nWinSize!'); %odd is ok, but noe tested the edges

%create an return object
%todo::
nCols = 1 + floor( (n-obj.cfg.nWinSize) / obj.cfg.nWinStep );
nRows = obj.cfg.getNumImgRows();
tfImg = TimeFreqImg([], nRows, nCols);

%% now we do the reral stuff: calculate spectrogram by each vertical line in <obj.img>
deltaTime = obj.cfg.getSamplingTimeInterval();
nWinHalf = obj.cfg.nWinSize/2;
t0 = obj.startTime;
n0 = nWinHalf+1;            %idx of frm center in original seq: <x>
for j=1:nCols
    %find start and end of data index to do fft
    n1 = n0-nWinHalf;
    n2 = n0+nWinHalf - 1;
    assert( n2<=n );
    %fprintf( '(j, n1,n0,n2)=%d,%d,%d,%d\n', j, n1, n0, n2);

    %prepare <y> which will be passed into fft()
    % y = obj.sampleBuffer.(hvFlag).samples(n1:n2) % works if hvflag is
    % 'horiz' or 'vert'
    if hvFlag == 'H'
        if ~obj.cfg.isRealSignal
            y = obj.sampleBuffer(1, n1:n2) + j * obj.sampleBuffer(2, n1:n2);
        else
            y = obj.sampleBuffer(1, n1:n2);
        end
    else
        if ~obj.cfg.isRealSignal
            y = obj.sampleBuffer(3, n1:n2) + j * obj.sampleBuffer(4, n1:n2);
        else
            y = obj.sampleBuffer(2, n1:n2);
        end
    end


    %do some statistics of y before adding window on it
    tfImg.vFrmTime(j) = t0 + (n0-1) * deltaTime;

    if 0
        yabs = abs(y);
        tfImg.vFrmMean(j) = mean( yabs );
        tfImg.vFrmStd(j)  = std( yabs );
        tfImg.vFrmMag(j)  = max(yabs) - min(yabs);

        %window <y>
        y =  y - mean(y);
        if ~isempty(obj.vWin)
            y = y .* obj.vWin;
        end
    end

    %do FFT
    if obj.cfg.isRealSignal
        Y0 = fft( y, obj.cfg.nFFT );
    else
        %in order to keep consistance with CfgSpectrogram.getFreqBins()
        % , we use fftshift() at here
        Y0 = fftshift(fft( y, obj.cfg.nFFT ));  %complex
    end

    %for nRows=1 + nFFT/2 for real signal
    %   nRows= nFFT for complex
    Y = abs(Y0(1:nRows));

    %determine the dominate freq. phase
    if 0
        [~, idx_y] = max( Y );
        obj.vFrmPhase(j) = angle( Y0(idx_y) );
    end

    tfImg.img(:,j) = Y; %(Y .* Y)/obj.cfg.nFFT;

    %-------for next iteration---------
    n0 = n0 + obj.cfg.nWinStep;
end
tfImg.img = log10(tfImg.img);
lastProcessedDataPointIdx = n2;
end

