function centers = FindPoints(data,SNR,varargin)
	% This function find all the points in the image 'data' that satisfy the 'SNR' requirement.
	% The 'ROI_size' and 'ROI_border_size' can be specified via 'varargin', i.e. FindPoints(data,SNR,ROI_center,ROI_border_size).
	DEBUG = 0;
	ROI_size = 10;
	ROI_border_size = 8;

	if nargin == 4
		ROI_size = varargin{1};
		ROI_border_size = varargin{2};
    elseif nargin<2 || nargin>4
		error('Not enough or too many input arguments: 3 or 4 input arguments are needed!');
	end

	sumFrame = squeeze(sum(data));

	CorrelatedFun = ones(14)*-1;
	CorrelatedFun(3:12,3:12) = ones(10);

	result = conv2(sumFrame,ones(ROI_size),'same');
	result = conv2(result,CorrelatedFun,'same');
	result(1:12,:) = 0;
	result(end-11:end,:) = 0;
	result(:,1:12) = 0;
	result(:,end-11:end) = 0;

	BackgroundCount = mean(mean(sumFrame));
	NoiseStd = std(sumFrame(sumFrame<BackgroundCount))*2;

	% keyboard;
	% Debug
	if DEBUG
		% FrameShow(sumFrame,0,[]);
		figure(2);
		FrameShow(result,0,[],gcf);
	end

	centers = [];

	i = 100;

	while 1
		[max_temp,max_x] = max(max(result));
		[~,max_y] = max(result(:,max_x));

		peak = max(max(sumFrame(max_y - ROI_size/2:max_y + ROI_size/2,max_x - ROI_size/2:max_x + ROI_size/2)));

		if (peak-BackgroundCount)/NoiseStd >= SNR
		% if max_temp/BackgroundCount >= SNR
			result(max_y - ROI_size/2 - ROI_border_size:max_y + ROI_size/2 + ROI_border_size,max_x - ROI_size/2 - ROI_border_size:max_x + ROI_size/2 + ROI_border_size) = BackgroundCount;
			if max_x>ROI_border_size+ROI_size && max_y>ROI_border_size+ROI_size && max_x<size(result,2)-ROI_border_size-ROI_size && max_y<size(result,1)-ROI_border_size-ROI_size
				centers(end+1,:) = [max_x,max_y];
			else
				continue;
			end

			% Debug
			if DEBUG
				subplot(1,2,2);
				PlotROI(gcf,gca,centers(end,:),ROI_size,ROI_border_size);
				keyboard;
			end
		else
			break;
		end

		i = i - 1;

		if i == 0
			break;
		end
	end

	centers = sortrows(FindPeak2D(sumFrame,centers,ROI_size,ROI_size/2));
	ClosePointIndex = find(sum(diff(centers).^2,2) < ROI_size^2*2);
	if ~isempty(ClosePointIndex)
		centers(ClosePointIndex,:) = 0;
		centers(ClosePointIndex+1,:) = 0;
		centers(centers(:,1)==0,:) = [];
	end
end