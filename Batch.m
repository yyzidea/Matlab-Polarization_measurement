% [Ia_1,Ia_2,DebugLog_a] = AnisoAnalysisNew('data/2018_12/Ensemble anisotropy/12_20a','logging');
% [Ib_1,Ib_2,DebugLog_b] = AnisoAnalysisNew('data/2018_12/Ensemble anisotropy/12_20b','logging');
Plot_AnisoAnalysis(Ia_1,Ia_2,2);
Plot_AnisoAnalysis(Ib_1,Ib_2,3);


aniso = sort((I_1-I_2)./(I_1+I_2));
a1 = aniso(floor(length(aniso)*0.95));
a2 = aniso(floor(length(aniso)*0.05));

region = (a1-a2)/2;
center = (a1+a2)/2;

% SNR = 20;
% load('data/2018_12/Ensemble anisotropy/12_201.mat');

% sumFrame1 = squeeze(sum(data));
center1 = FindPoints(sumFrame1,SNR);
FrameShow(sumFrame1,0,center1,figure(6));
% ROI1 = QDPLTraceExtraction(data,FindPoints(data,SNR));
% m1 = ThresholdMean(ROI1);

% load('data/2018_12/Ensemble anisotropy/12_205.mat');

% sumFrame2 = squeeze(sum(data));
center2 = FindPoints(sumFrame2,SNR);
FrameShow(sumFrame2,0,center2,figure(7));
% ROI2 = QDPLTraceExtraction(data,FindPoints(data,SNR));
% m2 = ThresholdMean(ROI2);

[deviation,map] = PointTrace(center1,center2,6);

figure(4);
clf(4);
box on;
hold on;
plot(m1(map(:,1)),'o');
plot(m2(map(:,2)),'s');
hold off;

m1(map(:,1))./m2(map(:,2))

figure(5);
subplot(1,2,1);
mesh(1:512,1:512,sumFrame1);
subplot(1,2,2);
mesh(1:512,1:512,sumFrame2);


for i = 1:20
	centers = FindPoints(frames(:,:,i),20);
	FrameShow(frames(:,:,i),0,centers,figure(6));
	pause;
end
