classdef TimeFreqImg
    properties  (Access = public)
        nTimeBins=1;           %1 x 1,   integer, # of bins in time domain
        nFreqBins=1;           %1 x 1,   integer, # of bins in freq. domain
        img=[];                %nFreqBins x nTimeBins, float, the spectrogram image

        vFreqBin=[];           %nFreqBins x 1,  float,   normalized freq. values
        % w.r.t. freq. bins

        %a frm is nFFT # of points inside the window to o FFT, by which we
        %can get one column of data in <img>
        vFrmTime=[];      %the time bins (horizontal) in spectrogram
        vFrmMean=[];      %the mean of the input signal in each frm
        vFrmStd=[];       %the std  of the input signal in each frm
        vFrmMag=[];       %the mag the input signal in each frm
        vFrmPhase=[];     %the dominate freq. phase of the input signal in each frm

        timeResolution;      %1 x 1, time resolution at Level 0 (the hightest)
        freqResolution;      %1 x 1, freq. resolution at Level 0 (the hightest)
        fs = 1;
        foiFreq = [1,1];     %freq range of intersting
        foiIdx  = [1,1];     %the row-index of freq range of intersting


        nextWrtColIdx = 0; %the column idx for next written
        isFullImg=false;
    end

    methods
        function obj = TimeFreqImg( cfg, nRows, nCols )
            %-----------------------------------------------------------
            % user case 1:
            % obj = TimeFreqImg( cfg )
            % if <nRows> and <nCols> are not given, we computer the sizes of
            % matrices from config, it maintains a circular buffer kind
            % of data structure and use addColumns() method to update them
            %
            % user case 2:
            % obj = TimeFreqImg( [], nRows, nCols )
            % in this scenario, it is used as a data strcture to hold a few 
            % columns of the spectrogram
            %-----------------------------------------------------------
            assert(nargin==1 || nargin==3, 'TimeFreqImg(): wrong # of args!');
            
            if nargin==1
                nRows = cfg.getNumImgRows();
                nCols = cfg.nImgCols;

                obj.timeResolution = cfg.getTimeResolution();
                obj.freqResolution = cfg.getFreqResolution();

                obj.vFreqBin =  cfg.getFreqBins();
                obj.vFrmTime = (1 : nCols) * obj.timeResolution;

                obj.fs       = cfg.fs;
                obj.foiFreq  = cfg.freqRngToPlot;
                obj.foiIdx   = cfg.getFreqIdx4Plot();
                obj.nextWrtColIdx = 1;
                obj.isFullImg = false;
            else
                obj.vFreqBin =  linspace(0,1,nRows)';
                obj.timeResolution =  1;
                obj.freqResolution = 1;
                obj.vFrmTime = (1 : nCols) * obj.timeResolution;
            end

            obj.nFreqBins = nRows;   %# of rows of the image
            obj.nTimeBins = nCols;   %# of columns of the image
            obj.img = zeros(nRows, nCols);
            obj.vFrmMean = zeros(1, nCols);      %the mean of the input signal in each frm
            obj.vFrmStd = zeros(1, nCols);       %the std  of the input signal in each frm
            obj.vFrmMag = zeros(1, nCols);       %the mag the input signal in each frm
            obj.vFrmPhase = zeros(1, nCols);     %the dominate freq. phase of the input signal in each frm
        end

        %getImg() method
        [img, vTime, vFreq] = getDispImg( obj )

        %addColumns() method
        obj = addColumns(obj, tfImg)
    end
end

