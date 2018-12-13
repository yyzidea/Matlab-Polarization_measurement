function  M = PlotTrace(ROI,M,TraceSpacing,figure_handle,varargin);
	% This function plot the stacked PL traces of multiple points in single figure 'figure_handle'.
	% Here, 'ROI' is the PL trace data, 'M' is the baseline of the stacked plot.

	RefFlag = 1;
	figure(figure_handle);
	if nargin == 6
		subaxes = get(gcf,'Child');
		
		set(gcf,'CurrentAxes',subaxes(varargin{1}));
		RefFlag = varargin{2};
	end

	box on;

	if isempty(ROI)
		return;
	end

	hold on;
	for i = 1:size(ROI,1)
		plot(ROI(i,:)+M);

		ROI_temp = ROI(i,:);

		if RefFlag
			m = mean(ROI_temp(ROI_temp>max(ROI_temp)/2))+M;
		else
			m = mean(ROI_temp)+M;
		end

		% text(10,(M+max(ROI(i,:))+M+200)/2,sprintf('%f',std(ROI_temp(ROI_temp>max(ROI_temp)/2))/(m-M)),'BackgroundColor','w');
		plot([0,size(ROI,2)],[m,m],'k--');
		text(10,m,sprintf('%f',m-M),'BackgroundColor','w');
		
		M = max(ROI(i,:))+M+TraceSpacing;

		plot([0,size(ROI,2)],[M,M],'k');
	end
	hold off;

	drawnow;

end