figure(1);
subaxe1 = subplot('Position',[0.1,0.4,0.3,0.6]);
subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.6]);

ROI_size = 10;
ROI_border_size = 3;

% ROI_center = zeros(17,2);

for rotationIndex = 1:17
	FileName = sprintf('data/QD107/%d.mat',rotationIndex-1);
	load(FileName);

	% % 
	ROI = QDPLTraceExtraction(data,ROI_center(rotationIndex,:));
	ROI(ROI<(max(ROI)+min(ROI))/2) = [];
	amplitude(rotationIndex) = mean(ROI);

	fprintf('Completed: %s\n',FileName);
end

figure(3)
box on;
plot((0:17)*22.25,amplitude);
ylim([0,200]);
