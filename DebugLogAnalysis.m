function DebugLogAnalysis(DebugLog,LogType,figure_handle,varargin)
	% This function analysis the log structure 'DebugLog' outputed by function 'AnisoAnalysis'.
	% Here, the position and PL trace of centers logged in 'DebugLog' will be shown in 'figure_handle'. 

	figure(figure_handle);
	clf(figure_handle);
	FontSize = 13;

	subaxe1 = subplot('Position',[0.1,0.4,0.3,0.55]);
	subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.55]);
	subaxe3 = subplot('Position',[0.1,0.1,0.3,0.2]);
	subaxe4 = subplot('Position',[0.1+0.5,0.1,0.3,0.2]);

	CurrentDataIndex = 0;
	ImageShowFlag = 1;
	
	indexs = 1:length(DebugLog);

	if ImageShowFlag
		if exist(sprintf('%s_sumFrames.mat',DebugLog(1).DataDir),'file')
			load(sprintf('%s_sumFrames.mat',DebugLog(1).DataDir));
		end
	end
	
	if nargin >=4
		if ~mod(nargin,2)
			ME = MException('DebugLogAnalysis:IllegalArgumentsPairs','Illegal input arguments pairs.');
			throw(ME);
		end

		for i = 1:(nargin-3)/2
			switch varargin{i*2-1}
				case 'Indexs'
					indexs = varargin{i*2};
				case 'ImageShowFlag'
					ImageShowFlag =  varargin{i*2};
				otherwise
					ME = MException('DebugLogAnalysis:IllegalArgumentsPairs','Illegal input arguments pairs:%s',varargin{i*2-1});
					throw(ME);
			end
		end
	elseif nargin<=2
		ME = MException('DebugLogAnalysis:NotEnoughArguments','Not enough input arguments!');
		throw(ME);
	end

	for i = 1:length(indexs)
		index = indexs(i);

		I_1 = ThresholdMean(DebugLog(index).ROI1);
		I_2 = ThresholdMean(DebugLog(index).ROI2);

		if (I_1-I_2)/(I_1+I_2) > -0.2 && (I_1-I_2)/(I_1+I_2) < 0.1
			continue;
		end

		fprintf('CurrentLog: index:%d, DataIndex:%d, SpecialCenters1:(%d,%d), SpecialCenters2:(%d,%d)\n',index,DebugLog(index).DataIndex,...
			DebugLog(index).SpecialCenters1(1),DebugLog(index).SpecialCenters1(2),...
			DebugLog(index).SpecialCenters2(1),DebugLog(index).SpecialCenters2(2));
	
		if strcmp(LogType,'old')
			if CurrentDataIndex ~= DebugLog(index).DataIndex
				if mod(DebugLog(index).DataIndex,2) == 1
					CurrentDataIndex = DebugLog(index).DataIndex;
					load(sprintf('%s_%d.mat',DebugLog(index).DataDir,CurrentDataIndex*2-1));
					frame1 = squeeze(sum(data));
					load(sprintf('%s_%d.mat',DebugLog(index).DataDir,CurrentDataIndex*2));
					frame2 = squeeze(sum(data));
				else
					CurrentDataIndex = DebugLog(index).DataIndex;
					load(sprintf('%s_%d.mat',DebugLog(index).DataDir,CurrentDataIndex*2));
					frame1 = squeeze(sum(data));
					load(sprintf('%s_%d.mat',DebugLog(index).DataDir,CurrentDataIndex*2-1));
					frame2 = squeeze(sum(data));
				end
			end

			M = max([max(max(frame1)),max(max(frame2))]);
			set(gcf,'CurrentAxes',subaxe1);
			imshow(frame1/M);
			PlotROI(gcf,subaxe1,DebugLog(index).SpecialCenters1,10,2);
			set(gca,'FontSize',FontSize);

			set(gcf,'CurrentAxes',subaxe2);
			imshow(frame2/M);
			PlotROI(gcf,subaxe2,DebugLog(index).SpecialCenters2,10,2);
			set(gca,'FontSize',FontSize);

		elseif strcmp(LogType,'new')
			if ImageShowFlag
				CurrentDataIndex = DebugLog(index).DataIndex;
				if ~exist('frames','var')
					load(sprintf('%s_%d.mat',DebugLog(index).DataDir,CurrentDataIndex));
					frame = squeeze(sum(data));
				else
					frame = frames(:,:,CurrentDataIndex);
				end
				
				M = max(max(frame));
				set(gcf,'CurrentAxes',subaxe1);
				imshow(frame/M);
				PlotROI(gcf,subaxe1,DebugLog(index).SpecialCenters1,10,2);
				PlotROI(gcf,subaxe1,DebugLog(index).SpecialCenters2,10,2);
				set(gca,'FontSize',FontSize);
			end

			set(gcf,'CurrentAxes',subaxe2);
			Aniso = (DebugLog(index).ROI1-DebugLog(index).ROI2)./(DebugLog(index).ROI1+DebugLog(index).ROI2);
			Aniso(DebugLog(index).ROI1<0)=0;
			Aniso(DebugLog(index).ROI2<0)=0;

			result = sortrows(vertcat(DebugLog(index).ROI1+DebugLog(index).ROI2,Aniso)',1);
			set(gca,'FontSize',FontSize,'YLim',[-1,1]);

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
		plot(DebugLog(index).ROI1);
		set(gca,'FontSize',FontSize);
		ylim([0,max(max(DebugLog(index).ROI1),max(DebugLog(index).ROI2))*1.1]);

		set(gcf,'CurrentAxes',subaxe4);
		plot(DebugLog(index).ROI2);
		set(gca,'FontSize',FontSize);
		ylim([0,max(max(DebugLog(index).ROI1),max(DebugLog(index).ROI2))*1.1]);

		pause;
	end
end