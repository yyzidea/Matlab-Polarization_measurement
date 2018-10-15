figure_handle = 2;
figure(figure_handle);
clf(figure_handle);

PL = zeros(1,17);

for rotationIndex = 1:17
	load(sprintf('data/QD0207/PL_%d.mat',rotationIndex-1));
	PL(rotationIndex) = sum(sum(sum(data)))/(size(data,1)*size(data,2)*size(data,3));
end

subplot(2,3,1,polaraxes);
hold on;
ft = fittype('A*(C*cos(2*r+phi)+1)','coefficients',{'A','phi','C'},'independent','r');
fo = fitoptions('Method','NonlinearLeastSquares','StartPoint',[mean(PL),pi/2,0.3],'Lower',[min(PL),0,0],'Upper',[max(PL),2*pi,1]);
sfit = fit(22.5/180*pi*(0:16)',PL',ft,fo)

theta = linspace(0,2*pi,100);
polarplot(theta,feval(sfit,theta));

polarplot((0:16)*22.5/180*pi,PL,'LineStyle','none','Marker','o','MarkerFaceColor',[0.8510,0.3255,0.0980],'MarkerEdgeColor',[0.8510,0.3255,0.0980]);
coefficients = coeffvalues(sfit);
set(gca,'FontSize',16)
title(sprintf('System Response\nDegree: %.2f',coefficients(3)),'FontSize',18);
hold off;

for i = 2:6
	subplot(2,3,i,polaraxes);
	if i == 4
		resultFit = FineProcess(eval(sprintf('ROI_%d',i-1)),gca,sfit,[pi,0.5]);
	else
		resultFit = FineProcess(eval(sprintf('ROI_%d',i-1)),gca,sfit);
	end

	coefficients = coeffvalues(resultFit);
	set(gca,'FontSize',16)
	title(sprintf('Point #%d\nDegree: %.2f',i-1,coefficients(3)),'FontSize',18);
end
