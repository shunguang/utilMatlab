classdef CfgSpectrogram
    properties
        nImgCols = 1;             %total time bins to maintain/display in the spectrogram image
        fs = 44100;
        nFFT = 2048;                      %# samples in freq. domain
        nWinSize = 448;                   %# of sample points to do the FFT
        nWinStep = 224;                   %step size to move the window
        winType = 'hamming';              %'hanning'
        freqUnit ='Hz';
        timeUnit = 'Sec';           %second
        freqRngToPlot=[10000, 20000];
        isShowColorbar = true;
        isRealSignal=true;
    end

    methods
        function obj = CfgSpectrogram( varargin )
            %todo: add parse varargin
            p = inputParser();
            p.addParameter('nImgCols',1024);
            p.addParameter('fs',44100);
            p.addParameter('nFFT',2048);
            p.addParameter('nWinSize',448);
            p.addParameter('nWinStep',224);
            p.addParameter('winType','none');
            p.addParameter('freqUnit', 'Hz');
            p.addParameter('timeUnit','Sec');
            p.addParameter('freqRngToPlot',[10000,20000]);
            p.addParameter('isShowColorbar', true);
            p.addParameter('isRealSignal', false);
            p.parse(varargin{:});
            in = p.Results;

            % All configuration parameters stored into config.
            obj.nImgCols = in.nImgCols;             %total time bins to maintain/display in the spectrogram image
            obj.fs = in.fs;
            obj.nFFT = in.nFFT;                      %# samples in freq. domain
            obj.nWinSize = in.nWinSize;                   %# of sample points to do the FFT
            obj.nWinStep = in.nWinStep;                      %step size to move the window
            obj.winType = in.winType;              %'hanning'
            obj.freqUnit = in.freqUnit;
            obj.timeUnit = in.timeUnit;           %second
            obj.freqRngToPlot = in.freqRngToPlot;
            obj.isShowColorbar = in.isShowColorbar;
            obj.isRealSignal = in.isRealSignal;
            
            %put some validation checking here ...
            assert( mod(obj.nFFT,2) == 0 );
            
        end

        %freq resolutuion in spectrogram image
        function F0 = getFreqResolution(obj)
            F0 = obj.fs/obj.nFFT;
        end
        %time resolutuion in spectrogram image
        function T0 = getTimeResolution(obj)
            T0 = obj.nWinStep/obj.fs;
        end

        function nRows = getNumImgRows(obj)
            if obj.isRealSignal
                nRows = obj.nFFT/2 + 1;
            else
                nRows = obj.nFFT;
            end
        end

        %time resolutuion in spectrogram image
        function dt = getSamplingTimeInterval(obj)
            dt = 1.0/obj.fs;
        end

        function n = getMinNumOfSamplesToProcess(obj)
            n = obj.nWinSize;
        end

        function vFreq = getFreqBins(obj)
            %---------------------------------------------------------------    
            % ref:
            % 1. for real signal, my favoriates are
            % https://www.mathworks.com/help/matlab/ref/fft.html
            % https://stackoverflow.com/questions/4364823/how-do-i-obtain-the-frequencies-of-each-value-in-an-fft
            %
            % 2. for complex signal, this is the only good and best one!
            % https://www.gaussianwaves.com/2015/11/interpreting-fft-results-complex-dft-frequency-bins-and-fftshift
            %---------------------------------------------------------------    
            nRows = obj.getNumImgRows();
            df = obj.getFreqResolution();
            isNormalized = false;
            if obj.isRealSignal
                if isNormalized
                    vFreq =  linspace(0,1,nRows);
                else
                    vFreq = (0: df : (0.5*obj.fs) ); 
                    assert( length(vFreq) == nRows );
                end
            else
                %the correspodning freq of X=fftshift(fft(x)) 
                N = obj.nFFT;
                if mod(N,2) == 0
                    vFreq = df*(-N/2 : 1 : N/2-1);
                else
                    vFreq = df*(-(N-1)/2 : 1 : (N-1)/2-1);
                end
                if isNormalized
                    vFreq = vFreq/obj.fs;
                end
            end
        end

        function vFreqIdx = getFreqIdx4Plot(obj)
            vFreq = obj.getFreqBins();  %1 x n
            [~, n] = size(vFreq);
            vFreq = ones(2,1) * vFreq;                              %2 x n
            vFreq =  abs( vFreq - obj.freqRngToPlot' * ones(1,n) ); %2 x n
            [~, vFreqIdx] = min(vFreq, [], 2);
        end

    end
end

