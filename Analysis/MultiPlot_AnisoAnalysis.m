function MultiPlot_AnisoAnalysis(n,m,I_1,I_2,figure_handle,varargin)
	% This script plot the result of function 'AnisoAnalysis'.

	% I_1 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI1),1:length(DebugLog));
	% I_2 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI2),1:length(DebugLog));

	figure(figure_handle);
	clf(figure_handle);

	SubplotGap = 0.05;
	PlotMargin = 0.1;
	SubplotHeight = (1-SubplotGap*(n-1)-PlotMargin*2)/n;
	SubplotWidth = (1-SubplotGap*(m-1)-PlotMargin*2)/m;

	MainPlotHeight = 0.6;
	MainPlotWidth = 1;
	HistoPlotWidth = 0.3;
	PlotGap = 0.1;

	SizeScaleFactor = [SubplotWidth,SubplotHeight,SubplotWidth,SubplotHeight];

	if length(I_1) == length(I_2)
		PlotNum = length(I_1);
	else
		error('The dimensions of I_1 and I_2 must agree!');
	end

	for i = 1:PlotNum
		% r = DipoleGeometryRatio(std(aniso)*2);

		% SubGap;
		if mod(i,m) == 0
			PosOffset = [(SubplotGap+SubplotWidth)*(m-1)+PlotMargin,(SubplotGap+SubplotHeight)*(n-ceil(i/m))+PlotMargin,0,0];
		else
			PosOffset = [(SubplotGap+SubplotWidth)*(mod(i,m)-1)+PlotMargin,(SubplotGap+SubplotHeight)*(n-ceil(i/m))+PlotMargin,0,0];
		end
		
		if nargin == 6
			[aniso,~] = AnisoCalc(I_1{i},I_2{i},varargin{1});
		else 
			[aniso,~] = AnisoCalc(I_1{i},I_2{i});
		end

		subplot('Position',PosOffset+[0,HistoPlotWidth+PlotGap,MainPlotWidth,MainPlotHeight].*SizeScaleFactor);
		semilogy(aniso,I_1{i}+I_2{i},'o');
		xlim([-1,1]);
		set(gca,'FontSize',14);

		subplot('Position',PosOffset+[0,0,MainPlotWidth,HistoPlotWidth].*SizeScaleFactor);
		histogram(aniso,linspace(-1,1,20));
		set(gca,'FontSize',14);

		% ResizeFigure(1,2);

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
end