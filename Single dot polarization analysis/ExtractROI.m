function ROI = ExtractROI(dataDir,dataSetIndex,InitialPointCenter)
	DEBUG = 0;
	% if DEBUG
	% 	figure(1);
	% 	clf(1);
	% 	% polaraxes;
	% 	hold on;
	% 	pointColor = [0,0.4470,0.7410;0.8510,0.3255,0.0980;0.9294,0.6941,0.1255];
	% end

	InitialPointCenterSize = size(InitialPointCenter);
	if InitialPointCenterSize(1) == 1
		ROI = cell(1,16);
	else
		ROI = cell(1,InitialPointCenterSize(1));
		for i = 1:InitialPointCenterSize(1)
			ROI{i} = cell(1,16);
		end
	end

	ROI_size = 10;
	for i = 1:length(dataSetIndex)
		for rotationIndex = 0:15
			load(sprintf('%s/%d_%d.mat',dataDir,dataSetIndex(i),rotationIndex));

			sumFrame = squeeze(sum(data));

			for j = 1:InitialPointCenterSize(1)
				try
					InitialPointCenter(j,:) = FindPeak2D(sumFrame,InitialPointCenter(j,:),ROI_size,ROI_size/2);
				catch ME
					switch ME.identifier
						case 'MATLAB:badsubscript'
							FrameShow(sumFrame,0,InitialPointCenter(j,:));
							display(InitialPointCenter(j,:));
							fprintf('dataSetIndex = %d and InitialPointCenter = %d',dataSetIndex,InitialPointCenter(j,1),InitialPointCenter(j,2));
							error('The point may go outside the image plane, please check it!');
						otherwise
							rethrow(ME);
					end
				end

				if DEBUG
					FrameShow(sumFrame,0,InitialPointCenter(j,:));
					display(InitialPointCenter(j,:));
					keyboard;
				end
				
				temp = QDPLTraceExtraction(data,InitialPointCenter(j,:));
				if InitialPointCenterSize(1) == 1
					ROI{rotationIndex+1} = horzcat(ROI{rotationIndex+1},temp);
				else
					ROI{i}{rotationIndex+1} = horzcat(ROI{i}{rotationIndex+1},temp);
				end
				
				if DEBUG
					% polarplot(rotationIndex*22.5/180*pi,temp,'LineStyle','none','Marker','.','MarkerEdgeColor',pointColor(mod(dataSetIndex(i),3)+1,:));
					% drawnow;
				end
			end

			fprintf('Completed: %s/%d_%d.mat\n',dataDir,dataSetIndex(i),rotationIndex);
		end
	end

	if DEBUG
		hold off;
	end

end


%% Old version
% figure(1);
% clf(1);
% polaraxes;
% hold on;

% ROI = cell(1,17);
% pointIndex = 3;
% pointColor = [0,0.4470,0.7410;0.8510,0.3255,0.0980;0.9294,0.6941,0.1255];
% for dataSetIndex = 3:5
% 	load(sprintf('results_02080%d.mat',dataSetIndex),'ROI_center');

% 	for rotationIndex = 0:16
% 		if dataSetIndex == 5
% 			load(sprintf('data/QD0207/%d_%d.mat',dataSetIndex,16-rotationIndex));
% 		else
% 			load(sprintf('data/QD0207/%d_%d.mat',dataSetIndex,rotationIndex));
% 		end

% 		temp = QDPLTraceExtraction(data,ROI_center(rotationIndex+1,:,pointIndex));
% 		ROI{rotationIndex+1} = horzcat(ROI{rotationIndex+1},temp);
% 		polarplot(rotationIndex*22.5/180*pi,temp,'LineStyle','none','Marker','.','MarkerEdgeColor',pointColor(dataSetIndex-2,:));
% 		drawnow;
% 		fprintf('Completed: data/QD0207/%d_%d.mat\n',dataSetIndex,rotationIndex);
% 	end
% end
% hold off;