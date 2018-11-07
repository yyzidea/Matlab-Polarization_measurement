figure(1);

subaxe1 = subplot('Position',[0.1,0.4,0.3,0.55]);
subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.55]);
subaxe3 = subplot('Position',[0.1,0.1,0.3,0.2]);
subaxe4 = subplot('Position',[0.1+0.5,0.1,0.3,0.2]);

% CurrentDataIndex = 0;
Dir = 'data/2018_11/Ensemble anisotropy/11_02';

for i = 1:length(DebugLog)
	if CurrentDataIndex ~= DebugLog(i).DataIndex
		if mod(DebugLog(i).DataIndex,2) == 1
			CurrentDataIndex = DebugLog(i).DataIndex;
			load(sprintf('%s_%d.mat',DebugLog(i).DataDir,CurrentDataIndex*2-1));
			frame1 = squeeze(sum(data));
			load(sprintf('%s_%d.mat',DebugLog(i).DataDir,CurrentDataIndex*2));
			frame2 = squeeze(sum(data));
		else
			CurrentDataIndex = DebugLog(i).DataIndex;
			load(sprintf('%s_%d.mat',DebugLog(i).DataDir,CurrentDataIndex*2));
			frame1 = squeeze(sum(data));
			load(sprintf('%s_%d.mat',DebugLog(i).DataDir,CurrentDataIndex*2-1));
			frame2 = squeeze(sum(data));
		end
	end

	M = max([max(max(frame1)),max(max(frame2))]);
	set(gcf,'CurrentAxes',subaxe1);
	imshow(frame1/M);
	PlotROI(gcf,subaxe1,DebugLog(i).SpecialCenters1,10,2);
	set(gcf,'CurrentAxes',subaxe2);
	imshow(frame2/M);
	PlotROI(gcf,subaxe2,DebugLog(i).SpecialCenters2,10,2);

	set(gcf,'CurrentAxes',subaxe3);
	plot(DebugLog(i).ROI1);
	set(gcf,'CurrentAxes',subaxe4);
	plot(DebugLog(i).ROI2);

	pause;
end