function [results,center] = ShowRegionValue(data,initialCenter,ROI_size,deviation)
	results = zeros(2*deviation+1);
	for i = -deviation:deviation
		for j = -deviation:deviation
			results(i+deviation+1,j+deviation+1) = ROI_value(data,initialCenter+[i,j],ROI_size);
		end
	end

	% keyboard;10
	[row,col] = find(results==max(max(results)));
	center = [row,col]+initialCenter-(deviation+1);
end

function value = ROI_value(data,ROI_center,ROI_size)
	value = sum(sum(data(ROI_center(2)-ROI_size/2:ROI_center(2)+ROI_size/2,ROI_center(1)-ROI_size/2:ROI_center(1)+ROI_size/2)));
end
