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
			if size(data,1) == 1
				frame = squeeze(data);
			else
				frame = squeeze(sum(data));
			end
		else
			frame = data;
		end
	end

	set(figure_handle,'CurrentAxes',subaxe1);
	mesh(1:size(frame,2),1:size(frame,1),frame');

	set(figure_handle,'CurrentAxes',subaxe2);
	frame_bw_contrast = (frame-min(min(frame)))/(max(max(frame))-min(min(frame)));
	imshow(frame_bw_contrast);

	if ~isempty(ROI_center)
		arrayfun(@(x,y) PlotROI(gcf,gca,[x,y],10,2),ROI_center(:,1),ROI_center(:,2));
	end
end