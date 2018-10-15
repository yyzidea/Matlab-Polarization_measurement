FIRSTPASE = 0;
PointNum = 7;
ROI_centers = [290,318;225,162;363,313;278,367;247,339;371,226;294,277];

figure(2);
clf(2);

% %% Single Plot
% ROI = ExtractROI('data/2018_07_23',1:2,ROI_center);
% resultFit = FineProcess(ROI,polaraxes,[],[-pi/2,1]);

% Mulitple Plot
if FIRSTPASE
	ROI = cell(1,PointNum);
end

for i = 1:PointNum
	subplot(2,4,i,polaraxes);

	if FIRSTPASE
		ROI{i} = ExtractROI('data/2018_09',1:2,ROI_centers(i,:));
	end

	% if i == 4
	% 	resultFit = FineProcess(eval(sprintf('ROI_%d',i)),gca,[],[pi,0.5]);
	% else
	% 	resultFit = FineProcess(eval(sprintf('ROI_%d',i)),gca,[]);
	% end

	resultFit = FineProcess(ROI{i},gca,[]);

	coefficients = coeffvalues(resultFit);
	set(gca,'FontSize',16)
	title(sprintf('Point #%d\nDegree: %.2f',i,coefficients(3)),'FontSize',18);
end
