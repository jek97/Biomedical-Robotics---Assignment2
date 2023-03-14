% load the data:
data = load('ES1_emg.mat');

% devide the data between movement signals and EMG signal:
raw_data = data.Test2.matrix(:,1);
movement_x = data.Test2.matrix(:,2);
movement_y = data.Test2.matrix(:,3);
movement_z = data.Test2.matrix(:,4);

% define the band pass frequency for the filter, they will be used for
% filtering the noises from the signal:
band_pass = [0.03, 0.45];

% define te filter:
band_filter = fir1(300,band_pass,"bandpass");

%filtering the data:
filtered_data = filtfilt(band_filter, 1,raw_data);

% rectify the data:
rectified_data = abs(filtered_data);

% define the low pass filter used to create the envelope of the signal:

low_pass_filter = fir1(10,0.005,"low");

% filtering the data:
enveloped_data = filtfilt(low_pass_filter, 1,rectified_data);

% downsample the data:
down_sampled = downsample(enveloped_data, 50, 0);

% assign the right time for each valeu of the signals to plot them:
for i = 1:size(down_sampled,1)
    t_d(i,1) = (50/2000) * i;
end

for i = 1:size(movement_x,1)
    t_s(i,1) = (1/2000) * i;
end
    
% plot the results:
subplot(3,1,1),plot(t_s, raw_data), hold on, plot(t_s, filtered_data),title('raw data and bandpass filtered data'), xlabel("time [s]"), ylabel("signal intensity [V]");
subplot(3,1,2),plot(t_s, rectified_data), hold on, plot(t_s, enveloped_data),title('rectified data and enveloped data'), xlabel("time [s]"), ylabel("signal intensity [V]");
subplot(3,1,3),plot(t_s, movement_x * 100),hold on,plot(t_s, movement_y * 100),hold on,plot(t_s, movement_z * 100),hold on,plot(t_d, down_sampled),title('movements and envelope'), xlabel("time [s]"), ylabel("signal intensity [V] for the muscle signal, [mm] for the movement");

% i multiplied the movement signals by 100 so it is visible in the graph.

% Question A: because in that way we don't lose information about the
% frequency content of the signal

% Question B: as we can see from the third graph the muscle activation
% start in the same moment of the limb motion, that we can recognize will
% move in a diagonal direction in space since alle the movements signal
% along x, y, z change under the muscle activation.