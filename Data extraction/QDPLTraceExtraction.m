function ROI = QDPLTraceExtraction(data,ROI_center,varargin)
	% This function extract the PL trace of points in certain image 'data'.
	
	DEBUG = 0;
	ROI_size = 10;
	ROI_border_size = 3;

	if nargin == 3
		if length(varargin{1}) ~= 3
			error('Illegal debug option!');
		end
		DEBUG = 1;
		DEBUG_LOG = varargin{1}(3);
		figure_handle = figure(varargin{1}(1));
		clf(varargin{1}(1));
	elseif nargin ~= 2
		error('No enough or too much input arguments!');
	end

	ROI = zeros(size(ROI_center,1),size(data,1));
	% ROI_noise = ROI;

	if DEBUG
		% Default axes position: [0.1300 0.1100 0.7750 0.8150]
		subaxe1 = subplot('Position',[0.1,0.4,0.3,0.6]);
		subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.6]);
		subaxe3 = subplot('Position',[0.1,0.1,0.8,0.2]);
		hl = animatedline;
	end

	for FrameIndex = 1:size(data,1)
		frame = squeeze(data(FrameIndex,:,:));

		% ROI_center = [119,83];
		for CenterIndex = 1:size(ROI_center,1)
			ROI_range = sum(sum(frame(ROI_center(CenterIndex,2)-ROI_size/2:ROI_center(CenterIndex,2)+ROI_size/2,ROI_center(CenterIndex,1)-ROI_size/2:ROI_center(CenterIndex,1)+ROI_size/2)));
			ROI_background = sum(sum(frame(ROI_center(CenterIndex,2)-ROI_size/2-ROI_border_size:ROI_center(CenterIndex,2)+ROI_size/2+ROI_border_size,ROI_center(CenterIndex,1)-ROI_size/2-ROI_border_size:ROI_center(CenterIndex,1)+ROI_size/2+ROI_border_size)));
			ROI_background = (ROI_background - ROI_range)/((ROI_size+ROI_border_size*2+1)^2-(ROI_size+1)^2);
			ROI(CenterIndex,FrameIndex) = ROI_range - ROI_background*(ROI_size+1)^2;
			if DEBUG
				ROI_noise(CenterIndex,FrameIndex) = ROI_background;
			end

			% % Debug function to choose the ROI center.
			if DEBUG
				frame_bw = frame/max(max(frame));

				ROI_x = [ROI_center(CenterIndex,1)-ROI_size/2,ROI_center(CenterIndex,1)-ROI_size/2,ROI_center(CenterIndex,1)+ROI_size/2,ROI_center(CenterIndex,1)+ROI_size/2];
				ROI_y = [ROI_center(CenterIndex,2)-ROI_size/2,ROI_center(CenterIndex,2)+ROI_size/2,ROI_center(CenterIndex,2)+ROI_size/2,ROI_center(CenterIndex,2)-ROI_size/2];
				ROI_background_x = ROI_x + [-ROI_border_size,-ROI_border_size,ROI_border_size,ROI_border_size];
				ROI_background_y = ROI_y + [-ROI_border_size,ROI_border_size,ROI_border_size,-ROI_border_size];

				set(figure_handle,'CurrentAxes',subaxe1);
				imshow(frame_bw);

				set(figure_handle,'CurrentAxes',subaxe2);
				frame_bw_contrast = (frame-min(min(frame)))/(max(max(frame))-min(min(frame)));
				imshow(frame_bw_contrast);
				hold on;
				plot(ROI_center(CenterIndex,1),ROI_center(CenterIndex,2),'.r')
				fill(ROI_x,ROI_y,'r','FaceColor','none','EdgeColor','w');
				fill(ROI_background_x,ROI_background_y,'r','FaceColor','none','EdgeColor','w');
				
				set(figure_handle,'CurrentAxes',subaxe3);
				box on;
				hold on;
				addpoints(hl,FrameIndex,ROI(FrameIndex));
				drawnow;
				title(sprintf('Current Frame:%d',FrameIndex));

				if DEBUG_LOG
					fprintf('Debug info\nCurrent frame: %d/%d\nROI center:(%d,%d)\nROI_background: %f\nROI_range: %f\nROI: %f\n',...
						FrameIndex,length(ROI),ROI_center(CenterIndex,1),ROI_center(CenterIndex,2),ROI_background,ROI_range/(ROI_size+1)^2,ROI(FrameIndex));
				end

				if varargin{1}(2) == 0
					keyboard;
				elseif varargin{1}(2) > 0
					pause(varargin{1}(2));
				else
					pause(0.1);
				end	
			end
		end
	end

	if DEBUG && ~isempty(ROI_noise)
		fprintf('QDPLTraceExtraction:ROI_noise:%f\n',mean(mean(ROI_noise)));
		% keyboard;
	end
end