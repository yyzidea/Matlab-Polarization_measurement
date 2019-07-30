function [I_1,I_2,varargout] = AnisoAnalysis(Dir,varargin)
	% This function process the raw data in the path 'Dir', 
	% while the user can specify the indexes of data files to be processed.
	% The 'logging' debug mode can output the detail info of extraordinary points.
	% The 'standard' debug mode can plot the PL traces of extraordinary points and output the variances of PL traces.
	% To use the above debug mode, please pass the 'standard' and/or 'logging' string into the function.

	DEBUG_OPTION = struct('standard',0,'logging',0);
	ROI_size = 10;

	DataLen = length(regexp(ls(sprintf('%s_*.mat',Dir)),'\w+.mat','match'))/2;

	result_figure_handle = 1;
	debug_figure_handle = 5;

	for i = 1:nargin
		switch i
			case 1
				DataIndexSeries = 1:DataLen;
			case 2
				if ~ischar(varargin{1})
					DataIndexSeries = varargin{1};
				else
					switch varargin{1}
						case 'standard'
							DEBUG_OPTION.standard = 1;
						case 'logging'
							DEBUG_OPTION.logging = 1;
						otherwise
							error(sprintf('Illegal debug option arguments: %s.\n',varargin{1}));
					end
				end
			otherwise
				switch varargin{i-1}
					case 'standard'
						DEBUG_OPTION.standard = 1;
					case 'logging'
						DEBUG_OPTION.logging = 1;
					otherwise
						error(sprintf('Illegal debug option arguments: %s.\n',varargin{i-1}));
				end
		end
	end

	I_1 = [];
	I_2 = [];

	if DEBUG_OPTION.logging
		variance_1 = [];
		variance_2 = [];
	end

	if DEBUG_OPTION.standard
		M1 = 0;
		M2 = 0;
		variance_1 = [];
		variance_2 = [];

		figure(debug_figure_handle);
		clf(debug_figure_handle);

		subplot(1,2,1);
		set(gca,'FontSize',14);
		subplot(1,2,2);
		set(gca,'FontSize',14);
	end

	if DEBUG_OPTION.logging
		DebugLog = struct('DataDir',{},'DataIndex',{},'SpecialCenters1',{},'SpecialCenters2',{},'ROI1',{},'ROI2',{});
	end

	for i = 1:length(DataIndexSeries)
		DataIndex = DataIndexSeries(i);
		if mod(DataIndex,2) == 1
			if DEBUG_OPTION.standard || DEBUG_OPTION.logging
				[temp1,centers1,variance,ROI1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				variance_1 = horzcat(variance_1,variance);
				[temp2,centers2,variance,ROI2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers1);
				variance_2 = horzcat(variance_2,variance);
			else
				[temp1,centers1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				[temp2,centers2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers1);
			end
		else
			if DEBUG_OPTION.standard || DEBUG_OPTION.logging
				[temp2,centers1,variance,ROI2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				variance_2 = horzcat(variance_2,variance);
				[temp1,centers2,variance,ROI1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers1);
				variance_1 = horzcat(variance_1,variance);
			else
				[temp2,centers1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2-1),ROI_size);
				[temp1,centers2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,DataIndex*2),ROI_size,centers1);
			end
		end

		I_1 = horzcat(I_1,temp1);
		I_2 = horzcat(I_2,temp2);

		if DEBUG_OPTION.logging
			% temp = abs((temp1-temp2)./(temp1+temp2))>0.4;
			temp = temp1==temp1;

			DebugLog(end+1:end+sum(temp)) = struct('DataDir',Dir,'DataIndex',num2cell(ones(sum(temp),1)*DataIndexSeries(i)),...
				'SpecialCenters1',num2cell(centers1(temp,:),2),'SpecialCenters2',num2cell(centers2(temp,:),2),...
				'ROI1',num2cell(ROI1(temp,:),2),'ROI2',num2cell(ROI2(temp,:),2));

			fprintf('[log]The number of special points: %d\n',length(DebugLog));
		end

		fprintf('No. of Points: %d\n',length(I_1));
		if DEBUG_OPTION.standard
			M1 = PlotTrace(ROI1,M1,200,debug_figure_handle,1);
			M2 = PlotTrace(ROI2,M2,200,debug_figure_handle,2);
			% M1 = PlotTrace(ROI1(abs((temp1-temp2)./(temp1+temp2))>0.3,:),M1,200,debug_figure_handle,1);
			% M2 = PlotTrace(ROI2(abs((temp1-temp2)./(temp1+temp2))>0.3,:),M2,200,debug_figure_handle,2);
			
			figure(debug_figure_handle);
			subaxes = get(gcf,'Child');
			set(gcf,'CurrentAxes',subaxes(1));
			ylim([0,max(M1,M2)]);
			set(gcf,'CurrentAxes',subaxes(2));
			ylim([0,max(M1,M2)]);
			pause(0.1);
		end

		figure(result_figure_handle);
		histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,20));
		drawnow;
	end

	if DEBUG_OPTION.logging
		varargout{1} = DebugLog;
	elseif DEBUG_OPTION.standard 
		varargout{1} = variance_1;
		varargout{2} = variance_2;
	end

end

function [I,centers,varargout] = ExtractIntensity(Dir,ROI_size,varargin)
	DEBUG = 1;
	SNR = 1.4;
	load(Dir);

	sumFrame = squeeze(sum(data));

	if nargin == 3
		centers1 = varargin{1};
		centers2 = FindPoints(sumFrame,SNR);
		deviation = PointTrace(centers1,centers2,5);
		centers = centers1 + repmat(deviation,size(centers1,1),1);
		centers = FindPeak2D(sumFrame),centers,ROI_size,ROI_size/2);
	else
		centers = FindPoints(sumFrame,SNR);
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
		FrameShow(data,0,[],figure(6));
		keyboard;
	end

	fprintf('Complete:%s\n', Dir);
end