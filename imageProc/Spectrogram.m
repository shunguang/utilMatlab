classdef Spectrogram
    properties
        cfg;              %a strcture to store the parameters to do STFT
        img =[];          %the results spectrum image
        vFreq=[];         %the freq bins (vertical) in spectrogram
        vWin=[];          %window weights

        %a frm is nFFT # of points inside the window to o FFT, by which we
        %can get one column of data in <I>
        vFrmTime=[];      %the time bins (horizontal) in spectrogram
        vFrmMean=[];      %the mean of the input signal in each frm
        vFrmStd=[];       %the std  of the input signal in each frm
        vFrmMag=[];       %the mag the input signal in each frm
        vFrmPhase=[];     %the dominate freq. phase of the input signal in each frm
        timeResolution=1;
        freqResolution=1;
        datBuffer;        %        
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
            assert( mod(cfg.nWinStep,1)==0, 'Spectrogram(): nWinStep is not an integer!' );

            %create window

            ww = [];
            if strcmp( obj.cfg.winType, 'hanning' )
                ww = hanning( obj.cfg.nWinSize );
            elseif strcmp( obj.cfg.winType, 'hamming' )
                ww = hamming( obj.cfg.nWinSize );
            end
            nCols = ceil( cfg.nSamples / cfg.nWinStep );  %# of pts in time domain
            nRows = cfg.nFFT/2 + 1;                       %# of pts in freq domain

            %if <nClos> is consttant, we will move the following into
            %constructor 
            obj.img = zeros( nRows, nCols);
            obj.vFreq = (0.5*obj.cfg.fs)*linspace(0,1,nRows)';
            obj.vWin =  ww';

            obj.vFrmTime = zeros( 1, nCols);
            obj.vFrmMean = zeros(1, nCols );
            obj.vFrmStd  = zeros(1, nCols );
            obj.vFrmMag  = zeros(1, nCols );
            obj.vFrmPhase  = zeros(1, nCols );
            
            obj.timeResolution = cfg.nWinStep/cfg.fs;
            obj.freqResolution = cfg.fs/cfg.nFFT;           
        end


        function obj = processSamples( obj, x, t0)
            %----------------------------------------------
            %intput:
            %x,       4 x n, [real(horiz); imag(horiz); real(vert); imag(vert)] data sampled at obj.cfg.fs Hz
            %t0,      the time of x[1]
            %
            %out:
            %obj.img=[];             %the results spectrum image
            %obj.vFreq=[];         %the freq bins (vertical) in spectrogram
            %obj.vFrmTime=[];      %the time bins (horizontal) in spectrogram
            %obj.vFrmMean=[];      %the mean of the input signal in each frm
            %obj.vFrmStd=[];       %the std  of the input signal in each frm
            %obj.vFrmMag=[];       %the mag the input signal in each frm
            %obj.vFrmPhase=[];     %the dominate freq. phase of the input signal in each frm 
            %----------------------------------------------

            %% check input data format: make x a 1-d row vector
            [m,n] = size(x);
            if m*n ~= numel(x)
                error('Spectrogram.process():, x must be 1D vector');
            end

            if m>n
                x = x';   %make sure <x> is a row vector
                n = m;
            end
        
            % check size of x    
            if ( n > obj.cfg.nSamples )
                disp( 'Spectrogram.process(): <x> has too many sample points, some data is not used!');
            end
            if ( n < obj.cfg.nSamples )
                disp( 'Spectrogram.process(): <x> has too few sample points, zeros are padded at the end!');
                m = obj.cfg.nSamples - n;
                x = [x, zeros(1, m)];
                n = obj.cfg.nSamples;
            end


            %% now we do the reral stuff: calculate spectrogram by each vertical line in <obj.img>
            deltaTime = 1/obj.cfg.fs;
            [nRows, nCols] = size(obj.img);
            nWinHalf = obj.cfg.nWinSize/2;
            n0 = 1;            %idx of frm center in original seq: <x>
            for j=1:nCols
                nPadBeg = 0;
                nPadEnd = 0;

                %find start and end of data index to do fft
                n1 = n0-nWinHalf;
                n2 = n0+nWinHalf - 1;
                if n1<1
                    nPadBeg = -n1 + 1;
                    n1 = 1;
                end
                if n2>n
                    nPadEnd = n2 - n;
                    n2 = n;
                end
                %fprintf( '(j, n1,n0,n2)=%d,%d,%d,%d\n', j, n1, n0, n2);

                %prepare <y> which will be passed into fft()
                if nPadBeg>0
                    y = [zeros(1,nPadBeg), x(n1:n2) ];
                elseif nPadEnd>0
                    y = [x(n1:n2), zeros(1,nPadEnd) ];
                else
                    y = x(n1:n2);
                end
                if numel(y) ~= obj.cfg.nWinSize
                    assert(0, "# of elements in y is incorrect!");
                end

                %do some statistics of y before adding window on it
                obj.vFrmTime(j) = t0 + (n0-1) * deltaTime;
                obj.vFrmMean(j) = mean( abs(y) );
                obj.vFrmStd(j)  = std(y);
                obj.vFrmMag(j)  = max(y) - min(y);

                %window <y>
                y =  y - mean(y);
                if ~isempty(obj.vWin)
                    y = y .* obj.vWin;
                end

                %do FFT
                Y0 = fft( y, obj.cfg.nFFT );   %complex
                Y = abs(Y0(1:nRows));

                %determine the dominate freq. phase
                [~, idx_y] = max( Y );
                obj.vFrmPhase(j) = angle( Y0(idx_y) );


                %normallize power spectrum
                maxY = eps+max(Y);
                Y = 100*(Y/maxY);
                obj.img(:,j) = (Y .* Y)/obj.cfg.nFFT;

                %-------for next iteration---------
                n0 = n0 + obj.cfg.nWinStep;
            end
            obj.img = 10*log10(obj.img+1);
        end

        function updatePlot( obj, isColorbar, figTitle, savedFilePath )
            [m,n] = size(obj.img);
            figure('Position',[1 1 1920 1080], 'DefaultAxesFontSize',18)
            imagesc( obj.vFrmTime, obj.vFreq, obj.img );
            if isColorbar
                colorbar('location','northoutside')
            end
            xlabel( ['Time (', obj.cfg.timeUnit, '), nPoints=', num2str(n), ', resolution \deltaT =', num2str(obj.timeResolution),')'] );
            ylabel( ['Freq (', obj.cfg.freqUnit, '), nPoints=', num2str(m), ', resolution \deltaf=', num2str(obj.freqResolution) ')'] );
            axis( [obj.vFrmTime(1), obj.vFrmTime(end), obj.vFreq(1), obj.vFreq(end)] );
            set(gca,'TickDir','out');
            title( figTitle );

            if ~isempty(savedFilePath)
                saveas(gcf, savedFilePath );
            end
        end
        
        
        function dumpImg( obj, filePath )
            B = obj.img -  min( obj.img(:) ) ;
            C = B/max(B(:));                    % C(i,j) \in [0,1]
            D = uint8(255*C);                   % D is uint8
            imwrite(D, filePath );
        end
        
    end
end
