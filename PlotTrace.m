function  M = PlotTrace(ROI,M,figure_handle);
	figure(figure_handle);

	if isempty(ROI)
		return;
	end

	hold on;
	for i = 1:size(ROI,1)
		plot(ROI(i,:)+M);
		M = max(ROI(i,:))*1.2+M;
		plot([0,size(ROI,2)],[M,M],'k--');
	end
	hold off;

	drawnow;

end