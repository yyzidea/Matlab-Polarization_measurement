function frames = SumFramesExtraction(Dir)
	DataLen = length(regexp(ls(sprintf('%s_*.mat',Dir)),'[0-9]+.mat','match'));
	frames = [];

	for i = 1:DataLen
		DataFilePath = sprintf('%s_%d.mat',Dir,i);
		load(DataFilePath);

		sumFrame = squeeze(sum(data));

		if isempty(frames)
			frames = zeros(size(sumFrame,1),size(sumFrame,2),DataLen);
		end

		frames(:,:,i) = sumFrame;
		fprintf('Completed: %s.\n',DataFilePath);
		keyboard;
		
	end
	save(sprintf('%s_sumFrames.mat',Dir),'frames');
end
