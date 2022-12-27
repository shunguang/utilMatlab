classdef Spectrogram
    properties
        cfg;                    %a strcture to store the parameters to do STFT
        hTimeFreqImg=[];        %horizontal   TimeFreqImage
        vTimeFreqImg=[];        %vertical      TimeFreqImage
        vWin=[];                %weight of FFT window

        sampleBuffer=[];        %4 x n, buffer the incoming samples
                                % todo: replace this so that it just uses
                                % JonesSeries, which can concatenate using
                                % [] operators
        startTime=0;            %corresponding time of sampleBuffer[1]
    end


    methods
        function obj = Spectrogram( cfg )
            %
            %example cfg
            % cfg = struct('nSamples', 8192, nFFT', 1024, 'nWinSize', 1024, 
            %               'nWinStep', 256, 'fs', 100, 'freqUnit', 'KHz', 
            %               'timeUnit', 'ms', 
            %               'winType', 'hanning');  
            %
            %
            obj.cfg = cfg;

            assert( cfg.nFFT ==  2^nextpow2( cfg.nFFT ) );

            %create window
            ww = [];
            if strcmp( obj.cfg.winType, 'hanning' )
                ww = hanning( obj.cfg.nWinSize );
            elseif strcmp( obj.cfg.winType, 'hamming' )
                ww = hamming( obj.cfg.nWinSize );
            end
            obj.vWin =  ww';
            
            %if <nClos> is consttant, we will move the following into
            %constructor 
            obj.hTimeFreqImg = TimeFreqImg( cfg );
            obj.vTimeFreqImg = TimeFreqImg( cfg );
            obj.sampleBuffer=[];
        end

        obj = processSamples( obj, x, t0)
        [tfImg, idx4LastDataPoint] = doSTFT( obj, hvFlag)
        updatePlot( obj, figTitle, savedFilePath,figId )

        
        
        function dumpImg( obj, filePath )
            B = obj.img -  min( obj.img(:) ) ;
            C = B/max(B(:));                    % C(i,j) \in [0,1]
            D = uint8(255*C);                   % D is uint8
            imwrite(D, filePath );
        end
        
    end
end
