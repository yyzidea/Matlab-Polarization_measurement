figure(3);
clf(3);

subplot(4,1,1);
plot(ROI1(4,:));
subplot(4,1,2);
plot(ROI2(4,:));
subplot(4,1,3);

Aniso = (ROI2(4,:)-ROI1(4,:))./(ROI1(4,:)+ROI2(4,:));
Aniso(ROI1(4,:)<0)=0;
Aniso(ROI2(4,:)<0)=0;

result = sortrows(vertcat(ROI1(4,:),ROI2(4,:),ROI1(4,:)+ROI2(4,:),Aniso)',3);

plot(result(:,3),result(:,4));
hold on;
plot(result(:,3),movmean(result(:,4),20));
hold off;

subplot(4,1,4);
plot(result(:,3),movstd(result(:,4),20));
