function [I_1,I_2,varargout] = AnisoAnalysis(Dir,varargin)
	DEBUG = 0;
	ROI_size = 10;

	DataLen = length(regexp(ls(sprintf('%s_*.mat',Dir)),'\w+.mat','match'))/2;
	if nargin == 2
		DataIndexSeries = varargin{1};
	elseif nargin == 1
		DataIndexSeries = 1:DataLen;
	else
		error('Too many or not enough input argument!');	
	end

	I_1 = [];
	I_2 = [];

	if DEBUG
		M1 = 0;
		M2 = 0;
		variance_1 = [];
		variance_2 = [];

		debug_figure_handle = 5;
		figure(debug_figure_handle);
		clf(debug_figure_handle);

		subplot(1,2,1);
		set(gca,'FontSize',14);
		subplot(1,2,2);
		set(gca,'FontSize',14);

	end

	for i = 1:length(DataIndexSeries)
		DataIndex = DataIndexSeries(i);
		if mod(DataIndex,2) == 1
			if DEBUG
				[temp1,centers,variance,ROI1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				variance_1 = horzcat(variance_1,variance);
				[temp2,centers,variance,ROI2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers);
				variance_2 = horzcat(variance_2,variance);
			else
				[temp1,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				[temp2,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers);
			end
			I_1 = horzcat(I_1,temp1);
			I_2 = horzcat(I_2,temp2);
			% keyboard;
		else
			if DEBUG
				[temp2,centers,variance,ROI2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				variance_2 = horzcat(variance_2,variance);
				[temp1,centers,variance,ROI1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers);
				variance_1 = horzcat(variance_1,variance);
			else
				[temp2,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				[temp1,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers);
			end
			I_2 = horzcat(I_2,temp2);
			I_1 = horzcat(I_1,temp1);

		% keyboard;
		end

		fprintf('No. of Points: %d\n',length(I_1));
		if DEBUG
			% M1 = PlotTrace(ROI1,M1,3);
			% M2 = PlotTrace(ROI2,M2,4);
			M1 = PlotTrace(ROI1(abs((temp1-temp2)./(temp1+temp2))>0.3,:),M1,debug_figure_handle,1);
			M2 = PlotTrace(ROI2(abs((temp1-temp2)./(temp1+temp2))>0.3,:),M2,debug_figure_handle,2);
			
			figure(debug_figure_handle);
			subaxes = get(gcf,'Child');
			set(gcf,'CurrentAxes',subaxes(1));
			ylim([0,max(M1,M2)]);
			set(gcf,'CurrentAxes',subaxes(2));
			ylim([0,max(M1,M2)]);
			pause(0.1);
		end

	end

	figure(2);
	histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,20));

	if DEBUG
		varargout{1} = variance_1;
		varargout{2} = variance_2;
	end

end

function [I,centers,varargout] = ExtractIntensity(Dir,ROI_size,varargin)
	DEBUG = 0;
	SNR = 2;
	load(Dir);

	if nargin == 3
		centers1 = varargin{1};
		centers2 = FindPoints(data,SNR);
		deviation = PointTrace(centers1,centers2,5);
		centers = centers1 + repmat(deviation,size(centers1,1),1);
		centers = FindPeak2D(squeeze(sum(data)),centers,ROI_size,ROI_size/2);
	else
		centers = FindPoints(data,SNR);
	end

	ROI = QDPLTraceExtraction(data,centers);

	I = zeros(1,size(ROI,1));

	for i = 1:size(ROI,1)
		ROI_temp = ROI(i,:);
		I(i) = mean(ROI_temp(ROI_temp>max(ROI_temp)/2));
	end

	if nargout == 4
		varargout{1} = var(ROI');
		varargout{2} = ROI;
	end

	% keyboard;

	if DEBUG
		FrameShow(data,0,[],figure(3));
		arrayfun(@(x,y) PlotROI(gcf,gca,[x,y],10,2),centers(:,1),centers(:,2));
	end

	fprintf('Complete:%s\n', Dir);
end