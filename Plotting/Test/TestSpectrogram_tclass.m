classdef TestSpectrogram_tclass < matlab.unittest.TestCase
    %
    % To run this test, assume you already have envionment vraiable
    % CADDYSHACK_SRC, just type:
    %
    % >>TestSpectrogram.runTests();
    %
    methods(Static)
        function runTests()
            import matlab.unittest.TestSuite
            appSrc = getenv('CADDYSHACK_SRC');
            if isempty(appSrc)
                appSrc = 'C:\Users\wus1\Projects\2022\caddyshack\src';
            end

            addpath(genpath(appSrc));
            suite  = TestSuite.fromClass(?TestSpectrogram);
            result = run(suite);
            table( result);
        end
    end

    methods(Test)
        function testBirdSound(testCase)   
            close all;
           
            cfg = CfgSpectrogram( ...
            'nImgCols', 100, ...              %total time bins to maintain/display in the spectrogram image
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
                nCurrSamples = randi(cfg.nWinSize,1);
                idx2 = idx1 + nCurrSamples;
                if idx2>nTotalSamples
                    idx2=nTotalSamples;
                end

                x = Y(:, idx1:idx2);
                t0 =  (idx1-1)/cfg.fs;
                sp = sp.processSamples(x, t0);

                figTitle = ['t0 =', num2str(t0), ', nCurrSamples=', num2str(nCurrSamples)];
                saveToFile = '';  %sprintf('c:/temp/sp-color-%04d.png', idx1 );
                sp.updatePlot(figTitle, saveToFile);

                %---next iteration ---
                idx1 = idx2+1;
            end
            testCase.verifyTrue(true);
        end %function testBirdSound(testCase)   

        %% test case 2
        function testCCW(testCase)
            ccwCfg = struct('fs', 2e9,'chirpRate', 6e6/1e-3,'rampDuration',100e-3, 'nSamples', 1e6 );
           
            %% Instantiate generation module.
            ccw = ChirpedCwGenerationModule( ...
                'fs', ccwCfg.fs,...
                'chirpRate', ccwCfg.chirpRate,...
                'rampDuration', ccwCfg.rampDuration);
        
           spTimeDomainPts =  100;
           nWinSize = ccwCfg.nSamples/spTimeDomainPts;
           nFFT = 2^nextpow2( nWinSize ); 

            cfg.fs = ccwCfg.fs;
            cfg.nFFT = nFFT;                      %# samples in freq. domain
            cfg.nWinSize = nWinSize;               %# of sample points to do the FFT
            cfg.nWinStep = nWinSize/2;                   %step size to move the window
            cfg.winType = 'hamming';              %'hanning'
            cfg.nSamples = ccwCfg.nSamples;       %total # of samples to do the spectrum
            cfg.freqUnit ='Hz';  
            cfg.timeUnit = 'sec';                 %second
            %cfg.roi = ?
            %cfg.maxTimeToKeepSP = 
            sp = Spectrogram( cfg );
           
            for i=1:2
               dat = ccw.getNSamp( ccwCfg.nSamples );  
               %dat is a JonesSeries('t0', tNext, 'fs', cfg.fs,'samples', zeros(2,nSamp));
               sp = sp.processSamples(x, dat.t0);
               sp.updatePlot(); 
            end
            testCase.verifyTrue(1,1);
        end 
    end %methods(Test)
end

