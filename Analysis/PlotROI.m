function PlotROI(figure_handle,axe,ROI_center,ROI_size,ROI_border_size)
	% This function mark the points 'ROI_center' in certain image specified by 'figure_handle' and 'axe',
	% while the 'ROI_size' and 'ROI_border_size' correspond to,
	% the signal area and background area of target points respectively. 

	ROI_x = [ROI_center(1)-ROI_size/2,ROI_center(1)-ROI_size/2,ROI_center(1)+ROI_size/2,ROI_center(1)+ROI_size/2];
	ROI_y = [ROI_center(2)-ROI_size/2,ROI_center(2)+ROI_size/2,ROI_center(2)+ROI_size/2,ROI_center(2)-ROI_size/2];
	ROI_background_x = ROI_x + [-ROI_border_size,-ROI_border_size,ROI_border_size,ROI_border_size];
	ROI_background_y = ROI_y + [-ROI_border_size,ROI_border_size,ROI_border_size,-ROI_border_size];

	set(figure_handle,'CurrentAxes',axe);
	hold on;
	plot(ROI_center(1),ROI_center(2),'.r')
	fill(ROI_x,ROI_y,'r','FaceColor','none','EdgeColor','w');
	fill(ROI_background_x,ROI_background_y,'r','FaceColor','none','EdgeColor','w');
	hold off;
end