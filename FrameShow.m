function FrameShow(data,FrameIndex,ROI_center,varargin)
	if nargin == 6
		ROI_size = varargin{2};
		ROI_border_size = varargin{3};
		figure_handle = varargin{1};
	elseif nargin == 4
		ROI_size = 10;
		ROI_border_size = 3;
		figure_handle = varargin{1}; 
	elseif nargin == 3
		ROI_size = 10;
		ROI_border_size = 3;
		figure_handle = figure(1);
	else
		error('Not enough or too many input arguments: 3 or 4 input arguments are needed!');
	end

	clf(figure_handle);
	% subaxe1 = subplot('Position',[0.1,0.4,0.3,0.6]);
	% subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.6]);
	subaxe1 = subplot(1,2,1);
	subaxe2 = subplot(1,2,2);

	ROI_range = zeros(1,size(data,1));

	if FrameIndex > 0
		frame = squeeze(data(FrameIndex,:,:));
	else
		if length(size(data)) == 3
			frame = squeeze(sum(data));
		else
			frame = data;
		end
	end

	if isempty(ROI_center)
		ROI_center = size(frame)/2;
	end
		
	ROI_x = [ROI_center(1)-ROI_size/2,ROI_center(1)-ROI_size/2,ROI_center(1)+ROI_size/2,ROI_center(1)+ROI_size/2];
	ROI_y = [ROI_center(2)-ROI_size/2,ROI_center(2)+ROI_size/2,ROI_center(2)+ROI_size/2,ROI_center(2)-ROI_size/2];
	ROI_background_x = ROI_x + [-ROI_border_size,-ROI_border_size,ROI_border_size,ROI_border_size];
	ROI_background_y = ROI_y + [-ROI_border_size,ROI_border_size,ROI_border_size,-ROI_border_size];

	set(figure_handle,'CurrentAxes',subaxe1);
	frame_bw = frame/max(max(frame));
	imshow(frame_bw);

	set(figure_handle,'CurrentAxes',subaxe2);
	frame_bw_contrast = (frame-min(min(frame)))/(max(max(frame))-min(min(frame)));
	imshow(frame_bw_contrast);
	
	if ROI_center(1)<0||ROI_center(2)<0
		hold on;
		plot(ROI_center(1),ROI_center(2),'.r')
		fill(ROI_x,ROI_y,'r','FaceColor','none','EdgeColor','w');
		fill(ROI_background_x,ROI_background_y,'r','FaceColor','none','EdgeColor','w');
		hold off;
	end
end