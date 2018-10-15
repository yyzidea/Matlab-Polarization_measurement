DEBUG = 1;

% rotation = 0:10:360;
% ROI_center = zeros(length(rotation),2);


% ROI = QDPLTraceExtraction(data,ROI_center,[1,0.05]);7,8,15

figure_handle = 3;
figure(figure_handle);
clf(figure_handle);

PL = zeros(1,17);

for rotationIndex = 1:17
	load(sprintf('data/QD0207/PL_%d.mat',rotationIndex-1));
	% PL(rotationIndex) = max(max(max(data)));
 
	PL(rotationIndex) = sum(sum(sum(data)))/(size(data,1)*size(data,2)*size(data,3));
end

polaraxes;
hold on;
ft = fittype('A*(C*cos(2*r+phi)+1)','coefficients',{'A','phi','C'},'independent','r');
fo = fitoptions('Method','NonlinearLeastSquares','StartPoint',[mean(PL),pi/2,0.3],'Lower',[min(PL),0,0],'Upper',[max(PL),2*pi,1]);
sfit = fit(22.5/180*pi*(0:16)',PL',ft,fo)

theta = linspace(0,2*pi,100);
polarplot(theta,feval(sfit,theta));

polarplot((0:16)*22.5/180*pi,PL,'LineStyle','none','Marker','o','MarkerFaceColor',[0.8510,0.3255,0.0980],'MarkerEdgeColor',[0.8510,0.3255,0.0980]);
hold off;

for i = 2:6
	subplot(2,3,i,polaraxes);
	FineProcess(eval(sprintf('ROI_%d',i-1)),gca);
end

% subaxe1 = subplot('Position',[0.1,0.4,0.3,0.6]);
% subaxe2 = subplot('Position',[0.1+0.5,0.4,0.3,0.6]);
% subaxe3 = subplot('Position',[0.1,0.1,0.8,0.2]);

% ROI_size = 10;
% ROI_border_size = 3;


% pointColor = [0,0.4470,0.7410;0.8510,0.3255,0.0980;0.9294,0.6941,0.1255];
% for dataSetIndex = 3:5
% 	for rotationIndex = 0:16

% 		% Finding center

% 		% load(sprintf('data/QD0207/1_%d.mat',rotationIndex-1));

% 		% sumFrame = squeeze(sum(data));
% 		% ROI_center(rotationIndex,:) = FindPeak2D(sumFrame,initialCenter,ROI_size,ROI_size/2);

% 		% FrameShow(sumFrame,0,ROI_center(rotationIndex,:),ROI_size);

% 		% % 
		
% 		polarplot(rotationIndex*22.5/180*pi,ROI{rotationIndex+1}((dataSetIndex-3)*200+1:(dataSetIndex-2)*200),'LineStyle','none','Marker','.','MarkerEdgeColor',pointColor(dataSetIndex-2,:));
% 	end
% end

% figure(3)
% clf(3)
% box on;
% plot((0:16)*22.5,amplitude);
% ylim([0,200]);
% xlim([0,360]);

% hold on;

% PointIndex = [1,2,3,4,5,8];
% legendLabels = cell(size(PointIndex));
% figure(3)
% clf(3)
% hold on;
% box on;

% for i = 1:length(PointIndex)
% 	plot((0:16)*22.5,amplitude(:,PointIndex(i))/mean(amplitude(:,PointIndex(i))));
% 	legendLabels{i} = sprintf('x:%d y:%d',ROI_center(1,1,PointIndex(i)),ROI_center(1,2,PointIndex(i))); 
% end

% ylim([0,2]);
% xlim([0,360]);
% legend(legendLabels)
% hold off;
% InitialCenters2 = [67,48;66,129;57,236;159,140;199,99;222,101;222,193;180,232]
% InitialCenters1 = [173,90;151,89;111,130;173,183;131,221]
% InitialCenters3 = [39,129;99,111;124,171;99,189;192,200]
% InitialCenters5 = [65,134;126,116;150,176;125,194;219,205]


