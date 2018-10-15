% This plot script is used to compare the polarization components and the g2 curve.

g2_1 = csvread('/Volumes/SHARE/Polarization Data/data_2018_07_23/1.dat',10,0);
g2_1 = g2_1+csvread('/Volumes/SHARE/Polarization Data/data_2018_07_23/2.dat',10,0);
g2_1 = g2_1+csvread('/Volumes/SHARE/Polarization Data/data_2018_07_23/3.dat',10,0);

g2_2 = csvread('/Volumes/SHARE/Polarization Data/data_2018_07_23/4.dat',10,0);

sfit1 = g2CurveFit(0.128e-9,g2_1(1:1500)');
sfit2 = g2CurveFit(0.128e-9,g2_2(1:1500)');

figure(1);
clf(1);
hold on;

subplot(2,2,1,polaraxes);
resultFit = FineProcess(eval(sprintf('ROI_%d',1)),gca,[],[-pi/2,1]);
coefficients = coeffvalues(resultFit);
set(gca,'FontSize',16)
title(sprintf('Point #%d Degree: %.2f',1,coefficients(3)),'FontSize',18);

subplot(2,2,2);
plot((1:1500)*0.128,g2_1(1:1500));
hold on;
plot((1:1500)*0.128,feval(sfit1,(1:1500)*0.128e-9),'LineWidth',3);
hold off;
coefficients = coeffvalues(sfit1);
set(gca,'FontSize',16,'XLim',[0,150]);
title(sprintf('Point #%d g^2(0): %.2f',1,1-coefficients(2)),'FontSize',18);

subplot(2,2,3,polaraxes);
resultFit = FineProcess(eval(sprintf('ROI_%d',2)),gca,[]);
coefficients = coeffvalues(resultFit);
set(gca,'FontSize',16)
title(sprintf('Point #%d Degree: %.2f',2,coefficients(3)),'FontSize',18);

subplot(2,2,4);
plot((1:1500)*0.128,g2_2(1:1500));
hold on;
plot((1:1500)*0.128,feval(sfit2,(1:1500)*0.128e-9),'LineWidth',3);
hold off;
coefficients = coeffvalues(sfit2);
set(gca,'FontSize',16,'XLim',[0,150]);
title(sprintf('Point #%d g^2(0): %.2f',2,1-coefficients(2)),'FontSize',18);