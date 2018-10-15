function centers = FindPoints(data,SNR,varargin)
	ROI_size = 10;
	ROI_border_size = 8;

	if nargin = 4
		ROI_size = varargin{1};
		ROI_border_size = varargin{2};
	else if nargin<2 || nargin>4
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

	NoiseLevel = mean(mean(result));

	% FrameShow(sumFrame,0,[]);
	% FrameShow(result,0,[],figure(2));

	centers = [];

	i = 100;

	while 1
		[max_temp,max_x] = max(max(result));
		if max_temp/NoiseLevel >= SNR
			[~,max_y] = max(result(:,max_x));
			result(max_y - ROI_size/5 - ROI_border_size:max_y + ROI_size/5 + ROI_border_size,max_x - ROI_size/5 - ROI_border_size:max_x + ROI_size/5 + ROI_border_size) = NoiseLevel;
			centers(end+1,:) = [max_x,max_y];

			% temp = get(figure(1),'Child');
			% PlotROI(figure(1),temp(2),centers(end,:),ROI_size,ROI_border_size);
			% temp = get(figure(2),'Child');
			% PlotROI(figure(2),temp(2),centers(end,:),ROI_size,ROI_border_size);
			% keyboard;
		else
			break;
		end

		i = i - 1;

		if i == 0
			break;
		end
	end
