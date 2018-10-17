figure(1);
clf(1);
subplot(2,1,1);
histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,10));

set(gca,'FontSize',14);

subplot(2,1,2);
box on;
result = sortrows(vertcat(variance_1,variance_2,a+b,(a-b)./(a+b))');
yyaxis left;
plot(abs(result(:,4)));
yyaxis right;
semilogy(1:size(result,1),result(:,1),1:size(result,1),result(:,2),1:size(result,1),result(:,3));
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