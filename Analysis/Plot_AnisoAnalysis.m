function Plot_AnisoAnalysis(I_1,I_2,figure_handle,varargin)
	% This script plot the result of function 'AnisoAnalysis'.

	% I_1 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI1),1:length(DebugLog));
	% I_2 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI2),1:length(DebugLog));

	figure(figure_handle);
	clf(figure_handle);

	if nargin == 4
		[aniso,~] = AnisoCalc(I_1,I_2,varargin{1});
	else 
		[aniso,~] = AnisoCalc(I_1,I_2);
	end

	% keyboard;
		
	% r = DipoleGeometryRatio(std(aniso)*2);

	PlotMargin = 0.1;
	PlotGap = 0.05;
	MainPlotHeight = 0.5;
	MainPlotWidth = 1 - PlotMargin*2;
	HistoPlotWidth = 0.25;

	% SubGap;
	subplot('Position',[PlotMargin,PlotMargin+HistoPlotWidth+PlotGap,MainPlotWidth,MainPlotHeight]);
	semilogy(aniso,I_1+I_2,'o');
	xlim([-1,1]);
	set(gca,'FontSize',14);

	subplot('Position',[PlotMargin,PlotMargin,MainPlotWidth,HistoPlotWidth]);
	histogram(aniso,linspace(-1,1,20));
	set(gca,'FontSize',14);

	ResizeFigure(1,2);

	% title(sprintf('Anisotropy distribution with a std width: %.4f\n Estimate ratio: %.2f and %.2f',std(aniso)*2,r(1),r(2)));
	
	% figure(3);
	% clf(3);
	% box on;
	% hold on;

	% M = 0;
	% for i = 1:size(ROI,1)
	% 	plot(ROI(i,:)+M);
	% 	M = max(ROI(i,:))*1.2+M;
	% 	plot([0,size(ROI,2)],[M,M],'k--');
	% end
	% hold off;
end