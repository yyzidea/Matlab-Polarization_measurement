function DebugLogAnalysis(DebugLog,LogType,figure_handle)
	% This function analysis the log structure 'DebugLog' outputed by function 'AnisoAnalysis'.
	% Here, the position and PL trace of centers logged in 'Debuglog' will be shown in 'figure_handle'. 

	figure(figure_handle);
	clf(figure_handle);
	FontSize = 13;

	subaxe1 = subplot('Position',[0.1,0.4,0.3,0.55]);
	subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.55]);
	subaxe3 = subplot('Position',[0.1,0.1,0.3,0.2]);
	subaxe4 = subplot('Position',[0.1+0.5,0.1,0.3,0.2]);

	CurrentDataIndex = 0;

	for i = 1:length(DebugLog)
		if strcmp(LogType,'old')
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
			set(gca,'FontSize',FontSize);

			set(gcf,'CurrentAxes',subaxe2);
			imshow(frame2/M);
			PlotROI(gcf,subaxe2,DebugLog(i).SpecialCenters2,10,2);
			set(gca,'FontSize',FontSize);

		elseif strcmp(LogType,'new')
			CurrentDataIndex = DebugLog(i).DataIndex;
			load(sprintf('%s_%d.mat',DebugLog(i).DataDir,CurrentDataIndex));
			frame = squeeze(sum(data));
			
			M = max(max(frame));
			set(gcf,'CurrentAxes',subaxe1);
			imshow(frame/M);
			PlotROI(gcf,subaxe1,DebugLog(i).SpecialCenters1,10,2);
			PlotROI(gcf,subaxe1,DebugLog(i).SpecialCenters2,10,2);
			set(gca,'FontSize',FontSize);

			set(gcf,'CurrentAxes',subaxe2);
			Aniso = (DebugLog(i).ROI2-DebugLog(i).ROI1)./(DebugLog(i).ROI1+DebugLog(i).ROI2);
			Aniso(DebugLog(i).ROI1<0)=0;
			Aniso(DebugLog(i).ROI2<0)=0;

			result = sortrows(vertcat(DebugLog(i).ROI1+DebugLog(i).ROI2,Aniso)',1);
			set(gca,'FontSize',FontSize);

			plot(result(:,1),result(:,2),'o');
			hold on;
			plot(result(:,1),movmean(result(:,2),20));
			plot(result(:,1),movstd(result(:,2),20));
			hold off;
			xlim([min(result(:,1)),max(result(:,1))]);
			legend('Ansiotropy','Moving mean','Moving standard deviation');
			set(gca,'FontSize',FontSize);

		else
			error(sprintf('Illegal LogType: %s',LogType));
		end

		set(gcf,'CurrentAxes',subaxe3);
		plot(DebugLog(i).ROI1);
		set(gca,'FontSize',FontSize);
		ylim([0,max(max(DebugLog(i).ROI1),max(DebugLog(i).ROI2))*1.1]);

		set(gcf,'CurrentAxes',subaxe4);
		plot(DebugLog(i).ROI2);
		set(gca,'FontSize',FontSize);
		ylim([0,max(max(DebugLog(i).ROI1),max(DebugLog(i).ROI2))*1.1]);

		pause;
	end
end