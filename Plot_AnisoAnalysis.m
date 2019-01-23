function Plot_AnisoAnalysis(I_1,I_2,figure_handle)
	% This script plot the result of function 'AnisoAnalysis'.

	% I_1 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI1),1:length(DebugLog));
	% I_2 = arrayfun(@(x) ThresholdMean(DebugLog(x).ROI2),1:length(DebugLog));

	figure(figure_handle);
	clf(figure_handle);

	subplot(2,1,1);
	histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,10));
	set(gca,'FontSize',14);

	subplot(2,1,2);
	semilogx(I_1+I_2,(I_1-I_2)./(I_1+I_2),'o');
	ylim([-1,1]);
	set(gca,'FontSize',14);

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