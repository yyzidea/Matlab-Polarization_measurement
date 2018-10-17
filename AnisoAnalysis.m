function [I_1,I_2] = AnisoAnalysis(Dir)
	ROI_size = 10;

	DataLen = length(regexp(ls(sprintf('%s_*.mat',Dir)),'\w+.mat','match'));
	I_1 = [];
	I_2 = [];

	for i = 1
		if mod(i,2) == 1
			[temp,centers1] = ExtractIntensity(sprintf('%s_%d.mat',Dir,i*2-1),ROI_size);
			I_1 = horzcat(I_1,temp); 
			[temp,center2] = ExtractIntensity(sprintf('%s_%d.mat',Dir,i*2),ROI_size,centers1);
			I_2 = horzcat(I_2,temp);
			keyboard;
		else
			[temp,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,i*2-1),ROI_size);
			I_2 = horzcat(I_2,temp); 
			[temp,centers] = ExtractIntensity(sprintf('%s_%d.mat',Dir,i*2),ROI_size,centers);
			I_1 = horzcat(I_1,temp);
			% keyboard;
		end
		fprintf('No. of Points: %d\n',length(I_1));
	end

	figure(2);
	histogram((I_1-I_2)./(I_1+I_2),linspace(-1,1,20));

end

function [I,centers] = ExtractIntensity(Dir,ROI_size,varargin)
	DEBUG = 0;
	load(Dir);

	if nargin == 3
		centers1 = varargin{1};
		centers2 = FindPoints(data,1.5);
		[~,I] = arrayfun(@(x,y) min(sum((centers2 - repmat([x,y],size(centers2,1),1)).^2,2)),centers1(:,1),centers1(:,2));
		deviation = mode(centers2(I,:)-centers1);
		centers = centers1 + repmat(deviation,size(centers1,1),1);
		centers = FindPeak2D(squeeze(sum(data)),centers,ROI_size,ROI_size/2);
	else
		centers = FindPoints(data,1.5);
	end

	ROI = QDPLTraceExtraction(data,centers);

	I = zeros(1,size(ROI,1));
	for i = 1:size(ROI,1)
		ROI_temp = ROI(i,:);
		I(i) = mean(ROI_temp(ROI_temp>max(ROI_temp)/2));
	end

	if DEBUG
		FrameShow(data,0,[],figure(3));
		arrayfun(@(x,y) PlotROI(gcf,gca,[x,y],10,2),centers(:,1),centers(:,2));
	end

	fprintf('Complete:%s\n', Dir);
end