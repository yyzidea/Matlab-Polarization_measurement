figure(1);

subplot(2,1,1);
histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,20));

set(gca,'FontSize',14);

subplot(2,1,2);
box on;
result = sortrows(vertcat(I_1+I_2,I_1,I_2,(I_1-I_2)./(I_1+I_2))');
yyaxis left;
plot(result(:,4));
yyaxis right;
semilogy(result(:,1));
set(gca,'FontSize',14);

