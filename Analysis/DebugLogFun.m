function [I_1,I_2] = DebugLogFun(DebugLog,Threshold,FluctuationType,figure_handle)
	% This function analysis the log structure 'DebugLog' outputed by function 'AnisoAnalysis'.
	% Here, the position and PL trace of centers logged in 'DebugLog' will be shown in 'figure_handle'. 

	indexs = 1:length(DebugLog);

	I_1 = [];
	I_2 = [];
	FluctuationRange = zeros(1,length(indexs));
	FluctuationStd = zeros(1,length(indexs));

	warning off;
	for i = 1:length(indexs)
		DataDir = DebugLog(indexs(i)).DataDir;
		DataIndex = DebugLog(indexs(i)).DataIndex;
		SpecialCenters1 = DebugLog(indexs(i)).SpecialCenters1;
		SpecialCenters2 = DebugLog(indexs(i)).SpecialCenters2;
		ROI1 = DebugLog(indexs(i)).ROI1;
		ROI2 = DebugLog(indexs(i)).ROI2;
		FluctuationRange(i) = (max(ROI1+ROI2)-min(ROI1+ROI2))/mean(ROI1+ROI2);
		FluctuationStd(i) = std(ROI1+ROI2)/mean(ROI1+ROI2);

		% if std((ROI1-ROI2)./(ROI1+ROI2))<=Threshold
		switch FluctuationType
			case 'range'
				fluctuation = FluctuationRange(i);
			case 'std'
				fluctuation = FluctuationStd(i);
			otherwise
				error('Illegal ''FluctuationType''!');
		end

		if 1
		% if fluctuation <= Threshold
			I_1(end+1) = ThresholdMean(ROI1);
			I_2(end+1) = ThresholdMean(ROI2);
		
		% else
		% 	DebugLogAnalysis(DebugLog,'new',2,'Indices',i);
		% 	ResizeFigure(2,1);
		% 	% keyboard;
		end
	end
	warning on;

	figure(figure_handle);
	clf(figure_handle);
	
	subplot(3,1,1);

	aniso = AnisoCalc(I_1,I_2,true);
	ErrorBar = mean(ErrorAnalysis(DebugLog));
	StdWidth = (std(aniso)-ErrorBar)*2;
	if StdWidth<0
		StdWidth = 0;
	end
	r = DipoleGeometryRatio(StdWidth);

	histogram(aniso,linspace(-1,1,20));
	title(sprintf('Width: %.3f, error: %.3f, Ratio: %.2f or %.2f\n Centers number: %d, Pass ratio: %.1f',StdWidth,ErrorBar*2,r(1),r(2),length(aniso),length(aniso)/length(DebugLog)*100));
	set(gca,'FontSize',14);

	subplot(3,1,2);
	histogram(FluctuationRange,linspace(0,2,16));
	title('The histogram of fluctuation range');
	set(gca,'FontSize',14);

	subplot(3,1,3);
	histogram(FluctuationStd,linspace(0,1,16));
	title('The histogram of fluctuation std');
	set(gca,'FontSize',14);

	fprintf('Centers number: %d; Pass ratio: %.1f \n',length(aniso),length(aniso)/length(DebugLog)*100);

end