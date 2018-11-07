% This script plot the result of function 'AnisoAnalysis'.
figure(1);
clf(1);
subplot(2,1,1);
histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,20));

set(gca,'FontSize',14);

subplot(2,1,2);
box on;
result = sortrows(vertcat(I_1+I_2,(I_1-I_2)./(I_1+I_2))');
yyaxis left;
plot(result(:,2));
yyaxis right;
semilogy(result(:,1));
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