%

% Created By: Thomas Colestock
% Based on references from: William Hahn
% Organization: Florida Atlantic University - Machine Perception and
% Cognitive Robotics (MPCR)
% Date Created: March 20, 2016
%
% This script is being designed to create sparse coding dictionaries with the goal
% of being able to classify different bird songs.
%

% Clean and initialize workspace
clear all
close all
clc

% Specify file path to the audio files
audio_path = '~/hdd/Insync/Documents/MPCR/Class_Spring_2016/sparse_coding_audio/Audio/Audio_forest/train_set';
% audio_path = '/Users/williamedwardhahn/Desktop/birdsong/Birdsong1/train_set'

% Move to audio file directory
cd(audio_path)
ls

% Create a structure containing files ending in .wav format
dr1=dir('*.wav'); % dir1.name -> name of all the .wav files
% Parse out file names from structure
f1={dr1.name}; % resuls in a 1xm cell with m .wav files

d=[]; % ! why is this here?? !


for i=1:5%:length(f1) % for each species of bird
    
    
    
    i % show iterative counting to display progress
    
    a1=f1{i}; % does this conversion work for audioread() below?
    
    [y,fs] = audioread(a1);
    % even if it does, write like this:
    % [y,fs] = audioread(f1{i});
    
    % not specifying the datatype means it is of type double, normalized
    % between -1.0 and 1.0
    % y == sampled data values [-1.0, 1.0]
    % fs = sampling rate [Hz]
    
    
    z = y(:,1); % doesn't seem to change what y already is... mX1 we are only working with 1 channel audio?
    
    
    plot(z)
    drawnow()
    
    
    ps=200; %??? why 200? patch size? 
    
    %     soundsc(z(100000:100000+patchsize),fs)
    %
    %     return
    
    % Create array X from z so that length(X) is evenly divided by ps
    X=z(1:end-mod(size(z,1),ps));    
    
    % Create a ps (200) by y/200 (rounded) matrix
    X = reshape(X, ps, size(X,1)/ps);
    %%%%%%%%%%%%
    
    % Save variables to a .mat file
    % save_path = '~/hdd/Insync/Documents/MPCR/Class_Spring_2016/sparse_coding_audio/Audio/Audio_forest/workspace_data';
    % cd('/Users/williamedwardhahn/Desktop/birdsong/birdsongdata')
    % cd(save_path)
    % save(['HahnAudioPatches_' num2str(ps) a1 '_Birdsong_.mat'],'X','-v7.3')
    
    % Whiten the matrix:::
    X = bsxfun(@minus,X,mean(X)); %remove mean
    % is it supposed to be mean(mean(X)) ??
    fX = fft(fft(X,[],2),[],3); %fourier transform of the images
    spectr = sqrt(mean(abs(fX).^2)); %mean spectrum (rms)
    % can write as:
    % spectr = sqrt(mean(fx.^2));
    % is it supposed to be sqrt(mean(mean(fx.^2))); ??
    X = ifft(ifft(bsxfun(@times,fX,1./spectr),[],2),[],3); %whitened X
    
    % Save the whitened matrix
    % savew_path = '~/hdd/Insync/Documents/MPCR/Class_Spring_2016/sparse_coding_audio/Audio/Audio_forest/whitened_data';
    % cd('/Users/williamedwardhahn/Desktop/birdsong/birdsongdata/Whitened')
    % cd(savew_path)
    % save(['HahnAudioPatches_' num2str(ps) a1 '_Birdsong_whitened.mat'],'X','-v7.3')
    
    
    % cd('/Users/williamedwardhahn/Desktop/birdsong/Birdsong1/train_set')
    
    
end











%  save('songbird.mat','z','fs');


