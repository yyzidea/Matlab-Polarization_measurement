figure(1);
ErrorBar = mean(ErrorAnalysis(DebugLog));
aniso = AnisoCalc(I_1,I_2,true);

StdWidth = (std(aniso)-ErrorBar)*2;
if StdWidth<0
	StdWidth = 0;
end
r = DipoleGeometryRatio(StdWidth);

Plot_AnisoAnalysis(I_1,I_2,1,true)

subplot(2,1,1);
set(gca,'FontSize',14);
title(sprintf('3 min QD Data\nWidth: %.3f and error bar: %.3f\n Estimate ratio: %.2f or %.2f',StdWidth,ErrorBar*2,r(1),r(2)));


subplot(2,1,1);
title(sprintf('The anisotropy distribution\nfor QDs of a fluctuation less than 20%%'));
set(gca,'FontSize',14);

subplot(2,1,2);
title('PL fluctuation');
set(gca,'FontSize',14);

