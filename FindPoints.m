function centers = FindPoints(sumFrame,SNR,varargin)
	% This function find all the points in the image 'sumFrame' that satisfy the 'SNR' requirement.
	% The 'ROI_size' and 'ROI_border_size' can be specified via 'varargin', i.e. FindPoints(sumFrame,SNR,ROI_center,ROI_border_size).
	DEBUG = 0;
	ROI_size = 10;
	ROI_border_size = 8;
	PointWidth = 4;

	if nargin == 4
		ROI_size = varargin{1};
		ROI_border_size = varargin{2};
    elseif nargin<2 || nargin>4
		error('Not enough or too many input arguments: 3 or 4 input arguments are needed!');
	end

	CorrelatedFun = ones(14)*-1;
	CorrelatedFun(3:12,3:12) = ones(10);

	result = conv2(sumFrame,ones(ROI_size),'same');
	result = conv2(result,CorrelatedFun,'same');
	result(1:12,:) = 0;
	result(end-11:end,:) = 0;
	result(:,1:12) = 0;
	result(:,end-11:end) = 0;

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
		[BackgroundCount,NoiseStd] = NoiseStdCalc(sumFrame,[max_y,max_x],20);
		if (peak-BackgroundCount)/NoiseStd >= SNR
		% if max_temp/BackgroundCount >= SNR
			r = ROI_size/2+ROI_border_size;
			Y1 = max_y-r;
			Y2 = max_y+r;
			X1 = max_x-r;
			X2 = max_x+r;

			if max_y+r>size(sumFrame,1)
				Y2 = size(sumFrame,1);
			end
			if max_x+r>size(sumFrame,2)
				X2 = size(sumFrame,2);
			end
			if max_y-r<1
				Y1 = 1;
			end
			if max_x-r<1
				X1 = 1;
			end

			result(Y1:Y2,X1:X2) = BackgroundCount;
			if max_x>ROI_border_size+ROI_size && max_y>ROI_border_size+ROI_size && max_x<size(result,2)-ROI_border_size-ROI_size && max_y<size(result,1)-ROI_border_size-ROI_size
				temp = sumFrame(max_y - ROI_size/2 - ROI_border_size:max_y + ROI_size/2 + ROI_border_size,max_x - ROI_size/2 - ROI_border_size:max_x + ROI_size/2 + ROI_border_size);
				if sum(sum(temp-BackgroundCount>(peak-BackgroundCount)*0.2))<PointWidth^2
					continue;
				end

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

	i = 1;
	while 1
		index = find(sum((centers - repmat(centers(i,:),size(centers,1),1)).^2,2) < ROI_size^2*2);

		if length(index) > 1
			centers(vertcat(index,i),:) = [];
		end
		
		i = i + 1;

		if i >= size(centers,1)
			break;
		end
	end

	% ClosePointIndex = find(sum(diff(centers).^2,2) < ROI_size^2*2);

	% if ~isempty(ClosePointIndex)
	% 	centers(ClosePointIndex,:) = 0;
	% 	centers(ClosePointIndex+1,:) = 0;
	% 	centers(centers(:,1)==0,:) = [];
	% end
end

function [m,s] = NoiseStdCalc(data,center,r)
	X1 = center(1)-r;
	X2 = center(1)+r;
	Y1 = center(2)-r;
	Y2 = center(2)+r;

	if center(1)+r>size(data,1)
		X2 = size(data,1);
	end
	if center(2)+r>size(data,2)
		Y2 = size(data,2);
	end
	if center(1)-r<1
		X1 = 1;
	end
	if center(2)-r<1
		Y1 = 1;
	end
	
	region = data(X1:X2,Y1:Y2);

	temp = reshape(movmean(region,10),1,[]);
	[N,edges] = histcounts(temp,10);
	[~,I] = max(N);
	m = mean(temp(temp>=edges(I)&temp<=edges(I+1)));
	region(region>=m) = [];
	s = std(region)*2;

end