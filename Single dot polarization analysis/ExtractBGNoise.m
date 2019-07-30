function Noise = ExtractBGNoise(TargetFiles,Sample_size,Sample_center,figure_handle)
	Noise = zeros(1,17);

	for rotationIndex = 1:17
		load(sprintf('%s%d.mat',TargetFiles,rotationIndex-1));
		sumFrame = squeeze(sum(data));
		Noise(rotationIndex) = sum(sum(sumFrame(Sample_center(2)-Sample_size/2:Sample_center(2)+Sample_size/2,Sample_center(1)-Sample_size/2:Sample_center(1)+Sample_size/2)))/(Sample_size+1)^2/500;
	
	end

	if figure_handle > 0
		figure(figure_handle);
		clf(figure_handle)
		box on;
		plot((0:16)*22.5,Noise);
		ylim([0,max(Noise)*1.1]);
	end
end