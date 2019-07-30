function [I_1,I_2] = DebugLogFun(DebugLog,Threshold,FluctuationType,figure_handle)
	% This function analysis the log structure 'DebugLog' outputed by function 'AnisoAnalysis'.
	% Here, the position and PL trace of centers logged in 'DebugLog' will be shown in 'figure_handle'. 

	indexs = 1:length(DebugLog);
	
	% if nargin >=4
	% 	if ~mod(nargin,2)
	% 		ME = MException('DebugLogAnalysis:IllegalArgumentsPairs','Illegal input arguments pairs.');
	% 		throw(ME);
	% 	end

	% 	for i = 1:(nargin-3)/2
	% 		switch varargin{i*2-1}
	% 			case 'Indexs'
	% 				indexs = varargin{i*2};
	% 			case 'ImageShowFlag'
	% 				ImageShowFlag =  varargin{i*2};					
	% 			case 'SpecialCenterDetection'
	% 				SpecialCenterDetection =  varargin{i*2};
	% 			otherwise
	% 				ME = MException('DebugLogAnalysis:IllegalArgumentsPairs','Illegal input arguments pairs:%s',varargin{i*2-1});
	% 				throw(ME);
	% 		end
	% 	end
	% elseif nargin<=2
	% 	ME = MException('DebugLogAnalysis:NotEnoughArguments','Not enough input arguments!');
	% 	throw(ME);
	% end

	aniso = [];
	I_1 = [];
	I_2 = [];
	fluctuation = zeros(1,length(indexs));
	for i = 1:length(indexs)
		DataDir = DebugLog(indexs(i)).DataDir;
		DataIndex = DebugLog(indexs(i)).DataIndex;
		SpecialCenters1 = DebugLog(indexs(i)).SpecialCenters1;
		SpecialCenters2 = DebugLog(indexs(i)).SpecialCenters2;
		ROI1 = DebugLog(indexs(i)).ROI1;
		ROI2 = DebugLog(indexs(i)).ROI2;

		% if std((ROI1-ROI2)./(ROI1+ROI2))<=Threshold
		switch FluctuationType
			case 'fluctuation'
				fluctuation(i) = (max(ROI1+ROI2)-min(ROI1+ROI2))/mean(ROI1+ROI2);
			case 'blinking'
				fluctuation(i) = std(ROI1+ROI2)/mean(ROI1+ROI2);
			otherwise
				error('Illegal ''FluctuationType''!');
		end
		% if fluctuation(i) >= 1
		% 	figure(2);subplot(2,1,1);plot(ROI1);subplot(2,1,2);plot(ROI2);
		% 	fprintf('%.4f\n',fluctuation(i));
		% 	pause;
		% end
		if fluctuation(i) <= Threshold
			I_1(end+1) = ThresholdMean(ROI1);
			I_2(end+1) = ThresholdMean(ROI2);
			aniso(end+1) = (I_1(end)-I_2(end))./(I_1(end)+I_2(end));
		end
	end

	figure(figure_handle);
	clf(figure_handle);
	subplot(2,1,1);
	histogram(aniso,linspace(-1,1,20));
	subplot(2,1,2);

	switch FluctuationType
		case 'fluctuation'
			histogram(fluctuation,15);
		case 'blinking'
			histogram(fluctuation,linspace(0,2,16));
		otherwise
			error('Illegal ''FluctuationType''!');
	end

	fprintf('Centers number: %d; Pass ratio: %.1f \n',length(aniso),length(aniso)/length(DebugLog)*100);

end