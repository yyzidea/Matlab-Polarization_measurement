function [amplitude,ROI_center] = TraceAll(TargetFiles,InitialCenters,ROI_param,figure_handle)

	ROI_size = ROI_param(1);
	% ROI_border_size = ROI_param(2);

	PointNum = size(InitialCenters,1);
	amplitude = zeros(17,PointNum);
	ROI_center = zeros(17,2,PointNum);

	for rotationIndex = 1:17
		% Finding center
		FileName = sprintf('%s%d.mat',TargetFiles,rotationIndex-1);
		load(FileName);
		sumFrame = squeeze(sum(data));

		if rotationIndex == 1
			PrevCenter = InitialCenters;
		else
			if PointNum > 1
				PrevCenter = squeeze(ROI_center(rotationIndex-1,:,:))';
			else
				PrevCenter = ROI_center(rotationIndex-1,:);
			end
		end

		for i = 1:PointNum
			ROI_center(rotationIndex,:,i) = FindPeak2D(sumFrame,PrevCenter(i,:),ROI_size,ROI_size/2);
			
			% Debug for the case that the QD move far away from the previous one.
			if (abs(ROI_center(rotationIndex,1,i)-PrevCenter(i,1))==ROI_size/2 || abs(ROI_center(rotationIndex,2,i)-PrevCenter(i,2))==ROI_size/2) ...
				&& ~isequal(ROI_center(rotationIndex,:,i),FindPeak2D(sumFrame,ROI_center(rotationIndex,:,i),ROI_size,ROI_size/2));
				FrameShow(sumFrame,0,ROI_center(rotationIndex,:,i),ROI_size);
				keyboard;
			end

			ROI = QDPLTraceExtraction(data,ROI_center(rotationIndex,:,i));

			ROI(ROI<(max(ROI)+min(ROI))/2) = [];
			amplitude(rotationIndex,i) = mean(ROI);
		end

		FrameSave(data,sprintf('%s%d.jpg',TargetFiles,rotationIndex-1));

		fprintf('Complete: %s\n',FileName);
	end

	figure(figure_handle)
	clf(figure_handle)
	hold on;
	box on;

	for i = 1:PointNum
		plot((0:16)*22.5,amplitude(:,i)/mean(amplitude(:,i)));
		legendLabels{i} = sprintf('x:%d y:%d',ROI_center(1,1,i),ROI_center(1,2,i)); 
	end

	ylim([0,2]);
	xlim([0,360]);
	legend(legendLabels);
	hold off;

end