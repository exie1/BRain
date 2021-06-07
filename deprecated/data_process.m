%% load and restructure data 
clear all
file_name = ['gratdirandcorr_MA026_Utah100-14_ch'];
    
for d1 = 1:4 % dth direction, loop for 4 directions 
    for i = 1:100 % ith channel

        filename = [file_name,num2str(i),'.mat'];
        load (filename);

        data1 = arrangedLFP; 
        data1 = permute(arrangedLFP,[3 2 1]); % rearrange dementionality to make time=row, channel=column, direction=Z
        data1n1 = data1(:,:,d1); % extract data1 from ith channel 100 trial and jth direction
        datan(:,:,i) = data1n1;% raw data %[time,trial,channel]
    end
    datan = permute(datan,[1 3 2]); % reshape dimension to [time, channel,trial]
    data(:,:,:,d1) = datan; % accumulate data into master matrix [time,channel,trial,direction]

    clearvars arrangedLFP data1 data1n1 data1n1Evo data1n1Ind datan;
            
 % bandpass filtering
    dataF = zeros(4070,100,100,1);

    for f = 1:2 % filter out 2 frequency bands: h-gamma/ theta

        flow = [80 3]; % first cutoff
        fhigh = [140 8]; % second cutoff
        N = 8; %filter order
        Fs = 1000; % sampling frequency

        h = fdesign.bandpass('N,F3dB1,F3dB2',N,flow(f),fhigh(f),Fs); % design a filter specification object
        Hd = design(h,'butter'); % apply design method to filter specification object
        set(Hd,'arithmetic','double'); 

        SOS = Hd.sosMatrix; % store filter coefficients in SOS as in [ sections x coefficients] (4x6) matrix
        G = Hd.ScaleValues; % store filter scale values in sections (4x1) matrix

        for i = 1:100 % ith channel
           for n1 = 1:100 % nth trial 
               for d = d1:d1
                 dataF(:,i,n1,f) = filtfilt(SOS,G,data(:,i,n1,d)); % apply zero-phase bandpass filter (in both forword and backward directions to avoid phase distortion) 
               end
           end
        end
    end

    clearvars SOS G;

% Hilbert transform data
    for i = 1:100 % ith channel
       for n1 = 1:100 % nth trial 
            for f = 1:2; % fth frequency band
               dataFh(:,i,n1,f) = hilbert(dataF(:,i,n1,f)) ;               
            end
       end
    end

% calculate phase and amplitude
    data_abs = abs(dataFh(:,:,:,1));  % amplitude, [time, channel, trial]
    data_abs_1234d(:,:,:,d1) = data_abs; % amplitude [time, channel, trial, direction]         
    data_phase = angle(dataFh(:,:,:,1));  % phase, [time, channel, trial]
    data_phase_1234d(:,:,:,d1) = data_phase; % phase, [time, channel, trial, direction]       

    clearvars data_abs data_phase dataFh dataF data arrangedSponLFP
end  
