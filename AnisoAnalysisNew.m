function [I_1,I_2,varargout] = AnisoAnalysisNew(Dir,varargin)
	% This function process the raw data in the path 'Dir', 
	% while the user can specify the indexes of data files to be processed.
	% The 'logging' debug mode can output the detail info of extraordinary points.
	% The 'standard' debug mode can plot the PL traces of extraordinary points and output the variances of PL traces.
	% To use the above debug mode, please pass the 'standard' and/or 'logging' string into the function.

	DEBUG_OPTION = struct('standard',0,'logging',0);
	ROI_size = 10;

	DataLen = length(regexp(ls(sprintf('%s_*.mat',Dir)),'[0-9]+.mat','match'));

	result_figure_handle = 1;
	debug_figure_handle = 5;

	DEBUG = 0;
	SNR = 20;
	MaxOverlap = 54;

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

	fprintf('Total No. of Data Set: %d\n',length(DataIndexSeries));

	I_1 = [];
	I_2 = [];

	if DEBUG_OPTION.logging
		variance_1 = [];
		variance_2 = [];
	end

	if ~exist(sprintf('%s_sumFrames.mat',Dir),'file') && length(DataIndexSeries) == DataLen
		frames = [];
	end

	if DEBUG_OPTION.standard
		M1 = 0;
		M2 = 0;
		M3 = 0;
		variance_1 = [];
		variance_2 = [];

		figure(debug_figure_handle);
		clf(debug_figure_handle);

		subplot(1,3,1);
		set(gca,'FontSize',14);
		subplot(1,3,2);
		set(gca,'FontSize',14);
		subplot(1,3,3);
		set(gca,'FontSize',14);
	end

	if DEBUG_OPTION.logging
		DebugLog = struct('DataDir',{},'DataIndex',{},'SpecialCenters1',{},'SpecialCenters2',{},'ROI1',{},'ROI2',{});
	end

	for i = 1:length(DataIndexSeries)
		DataFilePath = sprintf('%s_%d.mat',Dir,DataIndexSeries(i));
		fprintf('Processing %s.\n',DataFilePath);
		load(DataFilePath);

		sumFrame = squeeze(sum(data));

		if exist('frames','var')
			if isempty(frames)
				frames = zeros(size(sumFrame,1),size(sumFrame,2),DataLen);
			end
			frames(:,:,i) = sumFrame;
		end

		centers = FindPoints(sumFrame,SNR);

		% FrameShow(data,0,centers,figure(2));

		centers_LH = centers(centers(:,1)<=256-MaxOverlap,:);
		centers_RH = centers(centers(:,1)>256+MaxOverlap,:);
		try
			[deviation,map] = PointTrace(centers_LH,centers_RH,8);
		catch ex
			switch ex.identifier
			case 'PointTrace:PatternNotFound'
				warning(['This data file has been skipped, since there are too less points for point tracing.']);
				continue;
			otherwise
				rethrow(ex);
			end
		end

		for j = 1:size(centers_RH,1)
			if ~sum(map(:,2)==j) && centers_RH(j,1)<=512-MaxOverlap
				centers_LH = vertcat(centers_LH,FindPeak2D(sumFrame,centers_RH(j,:)-deviation,ROI_size,ROI_size/2));
				% keyboard;
			end
		end

		centers_RHO = centers_RH(centers_RH(:,1)>512-MaxOverlap,:);
		centers_LH = vertcat(centers_LH,FindPeak2D(sumFrame,centers_RHO-repmat(deviation,size(centers_RHO,1),1),ROI_size,ROI_size/2));
		centers_RH = FindPeak2D(sumFrame,centers_LH+repmat(deviation,size(centers_LH,1),1),ROI_size,ROI_size/2);

		% keyboard;
		ROI1 = QDPLTraceExtraction(data,centers_LH);
		ROI2 = QDPLTraceExtraction(data,centers_RH);

		I_1 = horzcat(I_1,ThresholdMean(ROI1));
		I_2 = horzcat(I_2,ThresholdMean(ROI2));

		if DEBUG_OPTION.logging
			% temp = abs((ROI1-ROI2)./(ROI1+ROI2))>0.4;
			temp = ones(size(ROI1,1),1)==1;

			DebugLog(end+1:end+sum(temp)) = struct('DataDir',Dir,'DataIndex',num2cell(ones(sum(temp),1)*DataIndexSeries(i)),...
				'SpecialCenters1',num2cell(centers_LH(temp,:),2),'SpecialCenters2',num2cell(centers_RH(temp,:),2),...
				'ROI1',num2cell(ROI1(temp,:),2),'ROI2',num2cell(ROI2(temp,:),2));

			fprintf('[log]The number of special points: %d\n',length(DebugLog));
		end

		fprintf('No. of Points: %d\n',length(I_1));
		if DEBUG_OPTION.standard
			M1 = PlotTrace(ROI1,M1,200,debug_figure_handle,1,1);
			M2 = PlotTrace(ROI2,M2,200,debug_figure_handle,2,1);
			M3 = PlotTrace((ROI1-ROI2)./(ROI1+ROI2),M3,1,debug_figure_handle,3,0);

			% M1 = PlotTrace(ROI1(abs((ROI1-ROI2)./(ROI1+ROI2))>0.3,:),M1,debug_figure_handle,1);
			% M2 = PlotTrace(ROI2(abs((ROI1-ROI2)./(ROI1+ROI2))>0.3,:),M2,debug_figure_handle,2);
			
			figure(debug_figure_handle);
			subaxes = get(gcf,'Child');
			set(gcf,'CurrentAxes',subaxes(1));
			ylim([0,max(M1,M2)]);
			set(gcf,'CurrentAxes',subaxes(2));
			ylim([0,max(M1,M2)]);
			set(gcf,'CurrentAxes',subaxes(3));
			ylim([0,M3]);

			pause(0.1);
		end

		Plot_AnisoAnalysis(I_1,I_2,result_figure_handle);

		drawnow;
	end

	if exist('frames','var')
		save(sprintf('%s_sumFrames.mat',Dir),'frames');
	end

	if DEBUG_OPTION.logging
		varargout{1} = DebugLog;
	elseif DEBUG_OPTION.standard 
		varargout{1} = variance_1;
		varargout{2} = variance_2;
	end


	if DEBUG
		FrameShow(data,0,[],figure(6));
		keyboard;
	end

end