figure(3);
clf(3);

dataSetLength = length(ROI{1}{1})/200;
pointIndex = input('pointIndex:');
for i = 1:dataSetLength
	temp_ROI = cell(1,16);
	for j = 1:16
		temp_ROI{j} = ROI{pointIndex}{j}((i-1)*200+1:i*200);
	end

	subplot(1,dataSetLength,i,polaraxes);
	resultFit = FineProcess(temp_ROI,gca,[],[-pi/2,1]);
end
