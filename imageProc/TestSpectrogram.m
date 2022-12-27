classdef TestSpectrogram < matlab.unittest.TestCase
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

    properties(TestParameter)
        cfg = {
            %the 1st spCfg
            struct('fs', 2e6,'chirpRate', 1e6,'rampDuration',1 ), ...
            %the 2nd spCfg
            struct('fs', 2e9,'chirpRate', 6e6/1e-3,'rampDuration',100e-3 ) ...
            };
    end

    methods(Test)
        function testBirdSound(testCase)   
            close all;

            spCfg.fs = 44100;
            spCfg.nFFT = 2048;                      %# samples in freq. domain
            spCfg.nWinSize = 448;                   %# of sample points to do the FFT
            spCfg.nWinStep = 224;                      %step size to move the window
            spCfg.winType = 'hamming';              %'hanning'
            spCfg.nSamples = 1000*spCfg.nWinSize;
            spCfg.freqUnit ='Hz';  
            spCfg.timeUnit = 'Sec';           %second
            spCfg.nTimeBins =100;
            spCfg.freqRngToPlot=[10, 1000];

            sp = Spectrogram( spCfg );
            fpath = 'C:\Users\wus1\Projects\2022\caddyshack\dataset\birdSound\birds_after_rain.wav';
            [Y, fs]=audioread(fpath);
            [nTotalSamples, nChs ] = size(Y)
            fprintf( 'nTotalSamples=%d, nChs=%d, fs=%d\n', nTotalSamples, nChs, fs);
            
            nSnapshots = 1; %int32( ceil(nTotalSamples/spCfg.nSamples) );

            %we only take the 1st channel
            isColorbar = true;
            idx1 = 1;
            for i=1:nSnapshots
                idx2 = idx1 + spCfg.nSamples-1;
                if idx2>nTotalSamples
                    idx2=nTotalSamples;
                end

                x = Y(idx1:idx2,1);
                t0 =  (idx1-1)/spCfg.fs;
                sp = sp.processSamples(x, t0);

                figTitle = ['sample rang: [', num2str(idx1), ',', num2str(idx2), '], nSamples=', num2str(idx2-idx1+1)];
                
                saveToFile = sprintf('c:/temp/sp-color-%04d.png',i );
                sp.updatePlot(isColorbar, figTitle, saveToFile);

                imgFile = sprintf('c:/temp/sp-gray-%04d.png',i );
                sp.dumpImg( imgFile );

                %---next iteration ---
                idx1 = idx2+1;
            end
            testCase.verifyTrue(true);
        end %function testBirdSound(testCase)   
    end %methods(Test)
end

