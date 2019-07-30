theta = (0:16)*22.5/180*pi;

load('PL.mat','Ratio');
figure(2);
clf(2);

subplot(2,2,1,polaraxes);
hold on;
clear('legendLabels_new');
load('results_020702.mat','amplitude','legendLabels','PointIndex');
for i = 1:length(PointIndex)
	amplitude_modify = amplitude(:,PointIndex(i)).*Ratio';
	polarplot(theta',amplitude_modify/mean(amplitude_modify));
	legendLabels_new{i} = sprintf('%s\nDegree:%.3f',legendLabels{i},(max(amplitude_modify)-min(amplitude_modify))/(max(amplitude_modify)+min(amplitude_modify)));
end
title('Point set 1#');
legend(legendLabels_new);

subplot(2,2,2,polaraxes);
hold on;
clear('legendLabels_new');
load('results_020803.mat','amplitude','legendLabels');
for i = 1:5
	amplitude_modify = amplitude(:,i).*Ratio';
	polarplot(theta',amplitude_modify/mean(amplitude_modify));
	legendLabels_new{i} = sprintf('%s\nDegree:%.3f',legendLabels{i},(max(amplitude_modify)-min(amplitude_modify))/(max(amplitude_modify)+min(amplitude_modify)));
end
legend(legendLabels_new);
title('Data 1# in Point set 2#');

subplot(2,2,3,polaraxes);
hold on;
clear('legendLabels_new');
load('results_020804.mat','amplitude','legendLabels');
for i = 1:5
	amplitude_modify = amplitude(:,i).*Ratio';
	polarplot(theta',amplitude_modify/mean(amplitude_modify));
	legendLabels_new{i} = sprintf('%s\nDegree:%.3f',legendLabels{i},(max(amplitude_modify)-min(amplitude_modify))/(max(amplitude_modify)+min(amplitude_modify)));
end
legend(legendLabels_new);
title('Data 2# in Point set 2#');

subplot(2,2,4,polaraxes);
hold on;
clear('legendLabels_new');
load('results_020805.mat','amplitude','legendLabels');
for i = 1:5
	amplitude_modify = amplitude(:,i).*Ratio';
	polarplot(theta',amplitude_modify/mean(amplitude_modify));
	legendLabels_new{i} = sprintf('%s\nDegree:%.3f',legendLabels{i},(max(amplitude_modify)-min(amplitude_modify))/(max(amplitude_modify)+min(amplitude_modify)));
end
legend(legendLabels_new);
title('Data 3# in Point set 2#');

figure(3);
clf(3);
polaraxes;
polarplot(theta',Ratio);
title(sprintf('System polarization response\n(Degree:%f)',(max(Ratio)-min(Ratio))/(max(Ratio)+min(Ratio))));
