function obj = processSamples( obj, newSamples, t0)
%----------------------------------------------
% input:
% newSamples, 4 x n, [real(horiz); imag(horiz); real(vert); imag(vert)] data sampled at obj.cfg.fs Hz
% t0,         the time of x(:,1)
%
% output: update the following
% obj.sampleBuffer
% obj.startTime
% obj.hTimeFreqImg
% obj.vTimeFreqImg
%----------------------------------------------

%% check input data format: make x a 1-d row vector
[four,n] = size(newSamples);

assert(four==4, 'Spectrogram.processSamples():, newSamples must be 4 x n matrix');
if(n<1)
    return;
end

if( isempty(obj.sampleBuffer))
    obj.startTime = t0;
end
obj.sampleBuffer = [obj.sampleBuffer, newSamples];

[~, nSamples] = size(obj.sampleBuffer);
if nSamples < obj.cfg.getMinNumOfSamplesToProcess()
    return;
end

%do STFT for both horizontal and vertical channels
[tfImgH, idx4LastPtH] = obj.doSTFT('H');
[tfImgV, idx4LastPtV] = obj.doSTFT('V');

%remove used data from <obj.sampleBuffer> and update <obj.startTime>
assert( idx4LastPtH == idx4LastPtV );
obj.sampleBuffer(:, 1:idx4LastPtH) = [];
obj.startTime = obj.startTime + double(idx4LastPtH) * obj.cfg.getSamplingTimeInterval();

%update <hTimeFreqImg> and <vTimeFreqImg>
obj.hTimeFreqImg = obj.hTimeFreqImg.addColumns(tfImgH);
obj.vTimeFreqImg = obj.vTimeFreqImg.addColumns(tfImgV);
end
